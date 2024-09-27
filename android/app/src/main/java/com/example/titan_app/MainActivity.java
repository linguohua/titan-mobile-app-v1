package com.example.titan_app;

import android.Manifest;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;

public class MainActivity extends FlutterActivity {
    private static final String TAG = "MainActivity:";

    private static final String METHOD_CHANNEL = "titan/nativel2";
    private static final int PERMISSION_REQUEST_CODE = 1000;
    final Handler mHandler = new Handler(Looper.getMainLooper());

    L2Service mService;
    boolean mBound = false;
    private boolean mIsL2ServiceNeed2Stop; // use to stop service
    // use to execute service jsoncall method, not to block UI thread
    private final ExecutorService mExecutor = Executors.newSingleThreadExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //Start service
        Intent intent = new Intent(this, L2Service.class);
        intent.putExtra("titan", "startby_titan_app");
        //JobSchedulerHelper.INSTANCE.scheduleJob(this);
        startL2Service(intent);
    }

    @Override
    protected void onStart() {
        // Bind to L2Service.
        Intent intent = new Intent(this, L2Service.class);
        bindService(intent, connection, 0);

        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                grantNotificationPermission();
            }
        }, 3000);

        super.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onStop() {
        super.onStop();
        Log.d(TAG, "onStop");
        if (mBound) {
            mIsL2ServiceNeed2Stop = !mService.isKeepL2Service();
        }
        unbindService(connection);
        mBound = false;
    }

    @Override
    public void onDestroy() {
        mExecutor.shutdownNow();
        super.onDestroy();

        if (mIsL2ServiceNeed2Stop) {
            stopL2Service();
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL).setMethodCallHandler((call, result) -> {
            if (!mBound) {
                result.success("{\"code\":-1,\"msg\":\"service not bound\"}");
                return;
            }
            //      Log.d(TAG, "configureFlutterEngine :" + call.method);
            // This method is invoked on the main thread.
            if (call.method.equals("jsonCall")) {
                mExecutor.execute(new Runnable() {
                    public void run() {
                        String args = call.argument("args");
                        String result2 = mService.jsonCall(args);
                        result.success(result2);
                    }
                });
            } else if (call.method.equals("setServiceStartupCmd")) {
                String args = call.argument("args");
                mService.setServiceStartupCmd(args);
                result.success("{\"code\":0}");
            } else if (call.method.equals("setServiceLocale")) {
                String args = call.argument("args");
                mService.setServiceLocale(args);
                result.success("{\"code\":0}");
            } else if (call.method.equals("isEmulator")) {
                EmulatorCheck emulatorCheck = EmulatorCheck.getInstance(this);
                boolean isEmulator = emulatorCheck.isEmulator();
                String name = emulatorCheck.checkFeaturesByHardware();
                if (isEmulator) {
                    // 处理模拟器环境
                    result.success("{\"code\": true,\"msg\":\"" + name + "\"}");
                } else {
                    // 处理真实设备环境
                    result.success("{\"code\": false,\"msg\":\"" + name + "\"}");
                }
            } else {
                result.notImplemented();
            }
        });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case PERMISSION_REQUEST_CODE:
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Permission is granted. Continue the action or workflow
                    // in your app.

                    // notify service that permission is granted
                    Intent intent = new Intent(this, L2Service.class);
                    intent.putExtra("titan", "permission_changed");
                    startL2Service(intent);
                } else {
                    // Explain to the user that the feature is unavailable because
                    // the feature requires a permission that the user has denied.
                    // At the same time, respect the user's decision. Don't link to
                    // system settings in an effort to convince the user to change
                    // their decision.
                }
        }
        // Other 'case' lines to check for other
        // permissions this app might request.
    }

    /**
     * Defines callbacks for service binding, passed to bindService().
     */
    private final ServiceConnection connection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className, IBinder service) {
            // We've bound to LocalService, cast the IBinder and get LocalService instance.
            L2Service.LocalBinder binder = (L2Service.LocalBinder) service;
            mService = binder.getService();
            mBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            mBound = false;
        }
    };

    private void startL2Service(Intent intent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent);
        } else {
            startService(intent);
        }
    }

    private void stopL2Service() {
        Intent intent = new Intent(this, L2Service.class);
        stopService(intent);
    }

    private void grantNotificationPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) {


        } else if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.POST_NOTIFICATIONS)) {
            // In an educational UI, explain to the user why your app requires this
            // permission for a specific feature to behave as expected, and what
            // features are disabled if it's declined. In this UI, include a
            // "cancel" or "no thanks" button that lets the user continue
            // using your app without granting the permission.
            // showInContextUI(...);
            showMessageOKCancel("For Titan to work better, please allow Titan service to show notification", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (which == DialogInterface.BUTTON_POSITIVE) {
                        requestPermissions();
                    }
                }
            });
        } else {
            // You can directly ask for the permission.
            requestPermissions();
        }
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.POST_NOTIFICATIONS}, PERMISSION_REQUEST_CODE);
    }

    private void showMessageOKCancel(String message, DialogInterface.OnClickListener okListener) {
        new AlertDialog.Builder(MainActivity.this).setMessage(message).setPositiveButton("OK", okListener).setNegativeButton("Cancel", null).create().show();
    }
}
