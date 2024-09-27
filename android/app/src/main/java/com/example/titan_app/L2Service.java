package com.example.titan_app;

import static android.os.Build.VERSION.SDK_INT;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.os.Binder;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.os.PowerManager;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.app.ServiceCompat;

import java.util.concurrent.atomic.AtomicBoolean;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Timer;
import java.util.TimerTask;

public class L2Service extends Service {
    private static final String TAG = "L2Service :";
    private static final int QUERY_NATIVEL2_INTERVAL = 15000;

    // Binder given to clients.
    private final IBinder mBinder = new LocalBinder();

    AtomicBoolean mIsRunning = new AtomicBoolean(false);
    private L2ServiceConfig mConfig;

    private String mNotificationChannelId;
    private int mNotificationId;
    private int mLastShownNotificationId;
    private boolean mIsLocaleEN = true;
    private boolean mIsNativeL2Online = false;
    private long mNativeL2StateUpdateTime = 0;
    private boolean mNeedExecuteNativeL2StartupCmd = false;
    private Timer mTimer; // timer to check native-L2 state
    private int mLastUIAction = 0; // 1 for 'start', 0 for 'stop'
    private WakeLockHelper wakeLockHelper;
    private AlarmHelper alarmHelper;

    @Override
    public IBinder onBind(Intent intent) {
        return mBinder;

    }

    @Override
    public boolean onUnbind(Intent intent) {
        return super.onUnbind(intent);
    }

    @Override
    public void onCreate() {
        super.onCreate();

        wakeLockHelper = new WakeLockHelper(this);
        alarmHelper = new AlarmHelper(this);

        mConfig = new L2ServiceConfig(this);
        mTimer = new Timer();

        String mNotificationChannelId = mConfig.getNotificationChannelId();
        if (mNotificationChannelId == null) {
            this.mNotificationChannelId = "TITAN_EDGE_SERVICE";
            //createNotificationChannel();
        } else {
            this.mNotificationChannelId = mNotificationChannelId;
        }

        mNotificationId = mConfig.getForegroundNotificationId();

        // if not 'zh', use 'en'
        mIsLocaleEN = !mConfig.getLocaleString().equalsIgnoreCase("zh");

        runService();

        Log.v(TAG, "Service onCreate");
    }

    @Override
    public void onDestroy() {
        stopForeground(STOP_FOREGROUND_REMOVE);
        mTimer.cancel();
        mIsRunning.set(false);

        if (wakeLockHelper != null) {
            wakeLockHelper.releaseWakeLock();
        }
        if (alarmHelper != null) {
            alarmHelper.setRepeatingAlarm();
        }
        super.onDestroy();

        Log.v(TAG, "Service onDestroy");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        boolean isStartbySystem = true;
        if (intent != null) {
            Bundle extras = intent.getExtras();
            if (extras != null) {
                String notify = extras.getString("titan");
                if (notify != null) {
                    isStartbySystem = false;
                    if (notify.equalsIgnoreCase("permission_changed")) {
                        updateNotificationInfo();
                    } else if (notify.equalsIgnoreCase("startby_titan_app")) {
                        Log.v(TAG, "Service start by titan app");
                    }
                }
            }
        }

        if (isStartbySystem) {
            mNeedExecuteNativeL2StartupCmd = true;
            Log.v(TAG, "Service start by system, will call native L2 startup cmd later");
        }

        if (wakeLockHelper != null) {
            if (wakeLockHelper.isCpuWakeLockSupported(this)) {
                Log.v(TAG, "is WakeLockLevel Supported");
                wakeLockHelper.acquireWakeLock();
            }else{
                Log.v(TAG, "is WakeLockLevel not Supported");
            }
        }

        if (alarmHelper != null) {
            alarmHelper.setRepeatingAlarm();
        }
        return START_STICKY;
    }


    private void updateNotificationInfo() {
        if (mConfig.isForeground()) {
            createAndShowForegroundNotification(mNotificationId);
        }
    }

    public static NotificationCompat.Builder getNotificationBuilder(Context context, String channelId, int importance) {
        NotificationCompat.Builder builder;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            prepareChannel(context, channelId, importance);
        }

        builder = new NotificationCompat.Builder(context, channelId);

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            builder.setForegroundServiceBehavior(Notification.FOREGROUND_SERVICE_IMMEDIATE);
        }

        return builder;
    }

    @TargetApi(26)
    private static void prepareChannel(Context context, String id, int importance) {
        CharSequence name = "Titan edge Service";
        String description = "Titan edge is running on background";
        final NotificationManager nm = (NotificationManager) context.getSystemService(Activity.NOTIFICATION_SERVICE);
        //NotificationManager notificationManager = getSystemService(NotificationManager.class);

        if (nm != null) {
            NotificationChannel nChannel = nm.getNotificationChannel(id);

            if (nChannel == null) {
                nChannel = new NotificationChannel(id, name, importance);
                nChannel.setDescription(description);
                nm.createNotificationChannel(nChannel);
            }
        }
    }

    public String jsonCall(String args) {

        String result = HelloJni.JSONCall(args);

        try {
            JSONObject jj = new JSONObject(args);
            String method = jj.getString("method");

            if (method.equalsIgnoreCase("state")) {
                boolean old = mIsNativeL2Online;

                parseAndUpdateNativeL2State(result);
                if (old != mIsNativeL2Online) {
                    updateNotificationInfo();
                }

                mNativeL2StateUpdateTime = System.currentTimeMillis();
            } else if (method.equalsIgnoreCase("startDaemon")) {
                if (isJsonCodeZero(result)) {
                    mLastUIAction = 1;
                }
            } else if (method.equalsIgnoreCase("stopDaemon")) {
                if (isJsonCodeZero(result)) {
                    mLastUIAction = 0;
                }
            }
        } catch (JSONException e) {
            Log.e(TAG, "jsonCall hook parse args failed:" + e.getMessage());
        }

        return result;
    }

    public void setServiceStartupCmd(String args) {
        mConfig.setServiceStartupCmd(args);
    }

    public void setServiceLocale(String locale) {
        if (locale == null || locale == "") {
            return;
        }
        mConfig.setLocaleString(locale);

        boolean old = mIsLocaleEN;
        mIsLocaleEN = !locale.equalsIgnoreCase("zh");

        if (old != mIsLocaleEN) {
            updateNotificationInfo();
        }
    }

    public boolean isKeepL2Service() {
        return mLastUIAction > 0;
    }

    private TimerTask mQueryNativeL2StateTask = new TimerTask() {
        public void run() {
            if (mNeedExecuteNativeL2StartupCmd) {
                mNeedExecuteNativeL2StartupCmd = false;
                // check whether need to execute or not startup command
                String cmd = mConfig.getServiceStartupCmd();
                if (cmd != "") {
                    String result = jsonCall(cmd);
                    Log.v(TAG, "L2Service start by system, execute startup cmd:" + cmd + ", result:" + result);
                } else {
                    Log.v(TAG, "L2Service start by system, startup cmd is empty");
                }
            } else {
                long now = System.currentTimeMillis();
                if ((now - mNativeL2StateUpdateTime) >= QUERY_NATIVEL2_INTERVAL) {
                    queryNativeL2State();
                }
            }
        }
    };

    private void runService() {
        if (mIsRunning.get()) {
            Log.d(TAG, "Service already running, using existing service");
            return;
        }

        updateNotificationInfo();

        // every 5 seconds
        mTimer.schedule(mQueryNativeL2StateTask, 5, QUERY_NATIVEL2_INTERVAL);

        mIsRunning.set(true);
    }

    private String buildNotificationContent() {
        if (mIsNativeL2Online) {
            return mIsLocaleEN ? "your node is online" : "您的节点在线";
        } else {
            return mIsLocaleEN ? "your node is offline" : "您的节点已离线";
        }
    }

    private String buildNotificationTitle() {
        return mIsLocaleEN ? "Titan backgroud service" : "Titan 后台服务";
    }

    private void queryNativeL2State() {
        String args = "{\"method\":\"state\",\"JSONParams\":\"\"}";
        jsonCall(args);
    }

    private void parseAndUpdateNativeL2State(String j) {
        try {
            JSONObject jObject = new JSONObject(j);
            // Pulling items from the array
            int code = jObject.getInt("code");
            if (code == 0) {
                String dataStr = jObject.getString("data");
                JSONObject jdata = new JSONObject(dataStr);
                mIsNativeL2Online = jdata.getBoolean("online");
            } else {
                mIsNativeL2Online = false;
            }
        } catch (JSONException e) {
            Log.e(TAG, "queryNativeL2State json exception:" + e.getMessage());
        }
    }

    private boolean isJsonCodeZero(String r) {
        try {
            JSONObject jObject = new JSONObject(r);
            // Pulling items from the array
            int code = jObject.getInt("code");
            if (code == 0) {
                return true;
            }
        } catch (JSONException e) {
            Log.e(TAG, "queryNativeL2State json exception:" + e.getMessage());
        }

        return false;
    }

    private void createAndShowForegroundNotification(int mNotificationId) {

        final NotificationCompat.Builder builder = getNotificationBuilder(this, mNotificationChannelId, // Channel id
                NotificationManagerCompat.IMPORTANCE_LOW); //Low importance prevent visual appearance for this notification channel on top

        String packageName = getApplicationContext().getPackageName();
        Intent i = getPackageManager().getLaunchIntentForPackage(packageName);
        int flags = PendingIntent.FLAG_CANCEL_CURRENT;
        if (SDK_INT >= Build.VERSION_CODES.S) {
            flags |= PendingIntent.FLAG_MUTABLE;
        }

        PendingIntent pi = PendingIntent.getActivity(L2Service.this, 11, i, flags);
        String notificationContent = buildNotificationContent();
        String notificationTitle = buildNotificationTitle();
        builder.setOngoing(true).setSmallIcon(R.mipmap.ic_launcher_round).setContentTitle(notificationTitle).setContentText(notificationContent).setContentIntent(pi);

        Notification notification = builder.build();

        try {
            ServiceCompat.startForeground(this, mNotificationId, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MANIFEST);
        } catch (SecurityException e) {
            Log.w(TAG, "Failed to start foreground service due to SecurityException" + " - have you forgotten to request a permission? - " + e.getMessage());
        }

        if (mNotificationId != mLastShownNotificationId) {
            // Cancel previous notification
            final NotificationManager nm = (NotificationManager) this.getSystemService(Activity.NOTIFICATION_SERVICE);
            nm.cancel(mLastShownNotificationId);
        }
        mLastShownNotificationId = mNotificationId;
    }

    /**
     * Class used for the client Binder.  Because we know this service always
     * runs in the same process as its clients, we don't need to deal with IPC.
     */
    public class LocalBinder extends Binder {
        L2Service getService() {
            // Return this instance of L2Service so clients can call public methods.
            return L2Service.this;
        }
    }
}
