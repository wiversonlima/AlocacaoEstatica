package com.monitoramento.persistente.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.monitoramento.persistente.services.MonitoringService
import com.monitoramento.persistente.services.KeepAliveService

class BootReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "BootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Boot receiver triggered: ${intent.action}")
        
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED,
            "android.intent.action.QUICKBOOT_POWERON",
            "com.htc.intent.action.QUICKBOOT_POWERON" -> {
                startServices(context)
            }
        }
    }

    private fun startServices(context: Context) {
        try {
            // Start monitoring service
            val monitoringIntent = Intent(context, MonitoringService::class.java)
            context.startForegroundService(monitoringIntent)
            Log.d(TAG, "Monitoring service started on boot")

            // Start keep-alive service
            val keepAliveIntent = Intent(context, KeepAliveService::class.java)
            context.startForegroundService(keepAliveIntent)
            Log.d(TAG, "Keep-alive service started on boot")

        } catch (e: Exception) {
            Log.e(TAG, "Failed to start services on boot", e)
        }
    }
}