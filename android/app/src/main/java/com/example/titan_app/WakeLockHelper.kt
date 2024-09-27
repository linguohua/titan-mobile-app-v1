package com.example.titan_app

import android.content.Context
import android.os.PowerManager

class WakeLockHelper(context: Context) {
    private val wakeLock: PowerManager.WakeLock?

    init {
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "MyApp::MyWakelockTag")
    }

    fun acquireWakeLock() {
        if (wakeLock != null && !wakeLock.isHeld) {
            wakeLock.acquire(10 * 60 * 1000L /*10 minutes*/)
        }
    }

    fun releaseWakeLock() {
        if (wakeLock != null && wakeLock.isHeld) {
            wakeLock.release()
        }
    }

    fun isCpuWakeLockSupported(context: Context): Boolean {
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        return powerManager.isWakeLockLevelSupported(PowerManager.PARTIAL_WAKE_LOCK)
    }
}
