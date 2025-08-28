package com.monitoramento.persistente.admin

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast

class DeviceAdminReceiver : DeviceAdminReceiver() {

    companion object {
        private const val TAG = "DeviceAdminReceiver"
    }

    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        Log.d(TAG, "Device admin enabled")
        Toast.makeText(context, "Administrador de dispositivo ativado", Toast.LENGTH_SHORT).show()
        
        // Start the keep-alive service when admin is enabled
        startKeepAliveService(context)
    }

    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Log.d(TAG, "Device admin disabled")
        Toast.makeText(context, "Administrador de dispositivo desativado", Toast.LENGTH_SHORT).show()
    }

    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        Log.d(TAG, "Device admin disable requested")
        return "Desativar o administrador irá reduzir a proteção do monitoramento"
    }

    override fun onPasswordChanged(context: Context, intent: Intent) {
        super.onPasswordChanged(context, intent)
        Log.d(TAG, "Password changed")
    }

    override fun onPasswordFailed(context: Context, intent: Intent) {
        super.onPasswordFailed(context, intent)
        Log.d(TAG, "Password failed")
    }

    override fun onPasswordSucceeded(context: Context, intent: Intent) {
        super.onPasswordSucceeded(context, intent)
        Log.d(TAG, "Password succeeded")
    }

    private fun startKeepAliveService(context: Context) {
        try {
            val serviceIntent = Intent(context, com.monitoramento.persistente.services.KeepAliveService::class.java)
            context.startForegroundService(serviceIntent)
            Log.d(TAG, "Keep-alive service started")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start keep-alive service", e)
        }
    }
}