package com.monitoramento.persistente.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import com.monitoramento.persistente.MainActivity
import com.monitoramento.persistente.R

class KeepAliveService : Service() {

    companion object {
        private const val TAG = "KeepAliveService"
        private const val NOTIFICATION_ID = 2
        private const val CHANNEL_ID = "KeepAliveChannel"
        private const val CHECK_INTERVAL = 30000L // 30 seconds
    }

    private val handler = Handler(Looper.getMainLooper())
    private lateinit var notificationManager: NotificationManager

    private val keepAliveRunnable = object : Runnable {
        override fun run() {
            checkAndRestartServices()
            handler.postDelayed(this, CHECK_INTERVAL)
        }
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Keep-alive service created")
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Keep-alive service started")
        
        startForeground(NOTIFICATION_ID, createNotification())
        startKeepAlive()
        
        return START_STICKY // Restart if killed
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Keep-alive service destroyed")
        stopKeepAlive()
        
        // Restart itself
        val restartIntent = Intent(this, KeepAliveService::class.java)
        startForegroundService(restartIntent)
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Keep Alive",
                NotificationManager.IMPORTANCE_MIN
            ).apply {
                description = "Mantém os serviços ativos"
                setShowBadge(false)
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Proteção Ativa")
            .setContentText("Mantendo serviços protegidos")
            .setSmallIcon(R.drawable.ic_notification)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .build()
    }

    private fun startKeepAlive() {
        handler.post(keepAliveRunnable)
    }

    private fun stopKeepAlive() {
        handler.removeCallbacks(keepAliveRunnable)
    }

    private fun checkAndRestartServices() {
        try {
            // Check if monitoring service is running
            if (!MonitoringService.isRunning) {
                Log.d(TAG, "Monitoring service not running, restarting...")
                val monitoringIntent = Intent(this, MonitoringService::class.java)
                startForegroundService(monitoringIntent)
            }
            
            Log.d(TAG, "Keep-alive check completed")
            
        } catch (e: Exception) {
            Log.e(TAG, "Error in keep-alive check", e)
        }
    }
}