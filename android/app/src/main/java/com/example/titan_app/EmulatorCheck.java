package com.example.titan_app;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.Log;

import androidx.core.app.ActivityCompat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import android.util.Log;

public class EmulatorCheck {

    private static EmulatorCheck instance;
    private Context context;
    private static final String[] known_pipes = {"/dev/socket/qemud", "/dev/qemu_pipe"};

    private static final String[] known_qemu_drivers = {"goldfish"};
    private static final String[] known_files = {"/system/lib/libc_malloc_debug_qemu.so", "/sys/qemu_trace", "/system/bin/qemu-props"};

    private static final String[] PKG_NAMES = {"com.mumu.launcher", "com.ami.duosupdater.ui", "com.ami.launchmetro", "com.ami.syncduosservices", "com.bluestacks.home", "com.bluestacks.windowsfilemanager", "com.bluestacks.settings", "com.bluestacks.bluestackslocationprovider", "com.bluestacks.appsettings", "com.bluestacks.bstfolder", "com.bluestacks.BstCommandProcessor", "com.bluestacks.s2p", "com.bluestacks.setup", "com.bluestacks.appmart", "com.kaopu001.tiantianserver", "com.kpzs.helpercenter", "com.kaopu001.tiantianime", "com.android.development_settings", "com.android.development", "com.android.customlocale2", "com.genymotion.superuser", "com.genymotion.clipboardproxy", "com.uc.xxzs.keyboard", "com.uc.xxzs", "com.blue.huang17.agent", "com.blue.huang17.launcher", "com.blue.huang17.ime", "com.microvirt.guide", "com.microvirt.market", "com.microvirt.memuime", "cn.itools.vm.launcher", "cn.itools.vm.proxy", "cn.itools.vm.softkeyboard", "cn.itools.avdmarket", "com.syd.IME", "com.bignox.app.store.hd", "com.bignox.launcher", "com.bignox.app.phone", "com.bignox.app.noxservice", "com.android.noxpush", "com.haimawan.push", "me.haima.helpcenter", "com.windroy.launcher", "com.windroy.superuser", "com.windroy.launcher", "com.windroy.ime", "com.android.flysilkworm", "com.android.emu.inputservice", "com.tiantian.ime", "com.microvirt.launcher", "me.le8.androidassist", "com.vphone.helper", "com.vphone.launcher", "com.duoyi.giftcenter.giftcenter"};

    @SuppressLint("SdCardPath")
    private static final String[] FILES = {"/data/data/com.android.flysilkworm", "/data/data/com.bluestacks.filemanager"};

    private EmulatorCheck(Context context) {
        this.context = context.getApplicationContext();
    }

    public static synchronized EmulatorCheck getInstance(Context context) {
        if (instance == null) {
            instance = new EmulatorCheck(context);
        }
        return instance;
    }

    public String checkFeaturesByHardware() {
        String result = "";
        String hardware = getProperty("ro.hardware");
        if (null == hardware) {
            return "unknown";
        }
        String tempValue = hardware.toLowerCase();
        if (tempValue.startsWith("cancro")) {
            result = "MUMU模拟器";
        } else if (tempValue.contains("nox")) {
            result = "夜神模拟器";
        } else if (tempValue.equals("android_x86")) {
            result = "雷电模拟器";
        } else {
            List<String> pathList = getInstalledSimulatorPackages();
            result = getSimulatorBrand(pathList);
        }
        return result;
    }

    private String getProperty(String propName) {
        String value = null;
        try {
            value = (String) Class.forName("android.os.SystemProperties").getMethod("get", String.class).invoke(null, propName);
        } catch (Exception e) {
            value = null;
        }
        return value;
    }

    private List<String> getInstalledSimulatorPackages() {
        ArrayList<String> localArrayList = new ArrayList<>();
        try {
            for (String pkgName : PKG_NAMES) {
                try {
                    context.getPackageManager().getPackageInfo(pkgName, PackageManager.GET_ACTIVITIES);
                    localArrayList.add(pkgName);
                } catch (PackageManager.NameNotFoundException ignored) {
                }
            }
            if (localArrayList.isEmpty()) {
                for (String filePath : FILES) {
                    if (new File(filePath).exists()) {
                        localArrayList.add(filePath);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return localArrayList;
    }

    private String getSimulatorBrand(List<String> list) {
        if (list.isEmpty()) {
            return "";
        }
        String pkgName = list.get(0);
        if (pkgName.contains("mumu")) {
            return "mumu";
        } else if (pkgName.contains("ami")) {
            return "AMIDuOS";
        } else if (pkgName.contains("bluestacks")) {
            return "蓝叠";
        } else if (pkgName.contains("kaopu001") || pkgName.contains("tiantian")) {
            return "天天";
        } else if (pkgName.contains("kpzs")) {
            return "靠谱助手";
        } else if (pkgName.contains("genymotion")) {
            if (Build.MODEL.contains("iTools")) {
                return "iTools";
            } else if (Build.MODEL.contains("ChangWan")) {
                return "畅玩";
            } else {
                return "genymotion";
            }
        } else if (pkgName.contains("uc")) {
            return "uc";
        } else if (pkgName.contains("blue")) {
            return "blue";
        } else if (pkgName.contains("microvirt")) {
            return "逍遥";
        } else if (pkgName.contains("itools")) {
            return "itools";
        } else if (pkgName.contains("syd")) {
            return "手游岛";
        } else if (pkgName.contains("bignox")) {
            return "夜神";
        } else if (pkgName.contains("haimawan")) {
            return "海马玩";
        } else if (pkgName.contains("windroy")) {
            return "windroy";
        } else if (pkgName.contains("flysilkworm")) {
            return "雷电";
        } else if (pkgName.contains("emu")) {
            return "emu";
        } else if (pkgName.contains("le8")) {
            return "le8";
        } else if (pkgName.contains("vphone")) {
            return "vphone";
        } else if (pkgName.contains("duoyi")) {
            return "多益";
        }
        return "titan_work";
    }

    public boolean isEmulator() {
        return (checkBuildProperties() || checkPipes() || checkQEmuDriverFile() || checkEmulatorFiles() || checkIsNotRealPhone() || checkSensor() || isYeshenEmulator());
    }

    private boolean checkBuildProperties() {
        String brand = Build.BRAND;
        String device = Build.DEVICE;
        String model = Build.MODEL;
        String product = Build.PRODUCT;

        if (brand.equalsIgnoreCase("generic") || brand.equalsIgnoreCase("android")) {
            return true;
        }
        if (device.equalsIgnoreCase("generic")) {
            return true;
        }
        if (model.equalsIgnoreCase("google_sdk") || model.equalsIgnoreCase("sdk") || model.equalsIgnoreCase("sdk_x86") || model.equalsIgnoreCase("vbox86p") || model.contains("Emulator") || model.contains("Android SDK built for x86")) {
            return true;
        }
        if (product.equalsIgnoreCase("google_sdk") || product.equalsIgnoreCase("sdk") || product.equalsIgnoreCase("sdk_x86") || product.equalsIgnoreCase("vbox86p")) {
            return true;
        }
        return false;
    }

    private boolean isYeshenEmulator() {
        String abiStr = getCpuInfo();
        if (abiStr != null && abiStr.length() > 0) {
            boolean isSupportX86 = false;
            boolean isSupportArm = false;

            if (abiStr.contains("x86_64") || abiStr.contains("x86")) {
                isSupportX86 = true;
            }
            Log.v("checkandroid:", abiStr);

            if (abiStr.contains("armeabi") || abiStr.contains("armeabi-v7a") || abiStr.contains("arm64-v8a")) {
                isSupportArm = true;
            }
            if (isSupportX86 && isSupportArm) {
                //同时拥有X86和arm的判断为模拟器。
                return true;
            }
        }
        return false;
    }

    private String getCpuInfo() {
        String[] abis = new String[]{};
        abis = Build.SUPPORTED_ABIS;
        StringBuilder abiStr = new StringBuilder();
        for (String abi : abis) {
            abiStr.append(abi);
            abiStr.append(',');
        }
        return abiStr.toString();
    }

    private boolean checkPipes() {
        for (String pipe : known_pipes) {
            File qemu_socket = new File(pipe);
            if (qemu_socket.exists()) {
                Log.v("Result:", "Find pipes!");
                return true;
            }
        }
        Log.i("Result:", "Not Find pipes!");
        return false;
    }

    private boolean checkQEmuDriverFile() {
        File driver_file = new File("/proc/tty/drivers");
        if (driver_file.exists() && driver_file.canRead()) {
            byte[] data = new byte[1024];  // (int)driver_file.length()
            try {
                InputStream inStream = null;
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    inStream = Files.newInputStream(driver_file.toPath());
                }
                assert inStream != null;
                inStream.read(data);
                inStream.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            String driver_data = new String(data);
            for (String known_qemu_driver : known_qemu_drivers) {
                if (driver_data.contains(known_qemu_driver)) {
                    Log.i("Result:", "Find know_qemu_drivers!");
                    return true;
                }
            }
        }
        Log.i("Result:", "Not Find known_qemu_drivers!");
        return false;
    }

    private boolean checkEmulatorFiles() {
        for (String file_name : known_files) {
            File qemu_file = new File(file_name);
            if (qemu_file.exists()) {
                Log.v("Result:", "Find Emulator Files!");
                return true;
            }
        }
        Log.v("Result:", "Not Find Emulator Files!");
        return false;
    }

    private boolean checkSensor() {
        SensorManager sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        if (sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER) == null) {
            return true;
        }
        return false;
    }

    private static boolean checkIsNotRealPhone() {
        String cpuInfo = readCpuInfo();
        if ((cpuInfo.contains("intel") || cpuInfo.contains("amd"))) {
            return true;
        }
        return false;
    }

    private static String readCpuInfo() {
        String result = "";
        try {
            String[] args = {"/system/bin/cat", "/proc/cpuinfo"};
            ProcessBuilder cmd = new ProcessBuilder(args);

            Process process = cmd.start();
            StringBuffer sb = new StringBuffer();
            String readLine = "";
            BufferedReader responseReader = new BufferedReader(new InputStreamReader(process.getInputStream(), "utf-8"));
            while ((readLine = responseReader.readLine()) != null) {
                sb.append(readLine);
            }
            responseReader.close();
            result = sb.toString().toLowerCase();
        } catch (IOException ex) {
        }
        return result;
    }
}
