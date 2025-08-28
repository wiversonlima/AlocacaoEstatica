package com.monitoramento.persistente.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import com.monitoramento.persistente.MainActivity
import com.monitoramento.persistente.R
import java.text.SimpleDateFormat
import java.util.*
import kotlin.random.Random

class MonitoringService : Service() {

    companion object {
        private const val TAG = "MonitoringService"
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "MonitoringChannel"
        var isRunning = false
            private set
    }

    private val binder = LocalBinder()
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var notificationManager: NotificationManager
    private var logUpdateListener: ((String) -> Unit)? = null
    private val logBuilder = StringBuilder()

    private val monitoringRunnable = object : Runnable {
        override fun run() {
            performMonitoring()
            handler.postDelayed(this, 5000) // Run every 5 seconds
        }
    }

    inner class LocalBinder : Binder() {
        fun getService(): MonitoringService = this@MonitoringService
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Monitoring service created")
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Monitoring service started")
        isRunning = true
        
        startForeground(NOTIFICATION_ID, createNotification())
        startMonitoring()
        
        return START_STICKY // Restart if killed
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Monitoring service destroyed")
        isRunning = false
        stopMonitoring()
    }

    override fun onBind(intent: Intent): IBinder {
        return binder
    }

    fun setLogUpdateListener(listener: (String) -> Unit) {
        logUpdateListener = listener
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Monitoramento",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Canal para notificações de monitoramento"
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
            .setContentTitle(getString(R.string.monitoring_service_notification_title))
            .setContentText(getString(R.string.monitoring_service_notification_text))
            .setSmallIcon(R.drawable.ic_notification)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()
    }

    private fun startMonitoring() {
        logMessage("Monitoramento iniciado")
        handler.post(monitoringRunnable)
    }

    private fun stopMonitoring() {
        handler.removeCallbacks(monitoringRunnable)
        logMessage("Monitoramento parado")
    }

    private fun performMonitoring() {
        try {
            // Collect system information
            val timestamp = SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(Date())
            val memoryInfo = collectMemoryInfo()
            val cpuInfo = collectCpuInfo()
            val batteryInfo = collectBatteryInfo()
            
            val logEntry = "[$timestamp] CPU: $cpuInfo | MEM: $memoryInfo | BAT: $batteryInfo"
            logMessage(logEntry)
            
        } catch (e: Exception) {
            Log.e(TAG, "Error during monitoring", e)
            logMessage("Erro no monitoramento: ${e.message}")
        }
    }

    private fun collectMemoryInfo(): String {
        return try {
            val runtime = Runtime.getRuntime()
            val usedMemory = runtime.totalMemory() - runtime.freeMemory()
            val usedMemoryMB = usedMemory / (1024 * 1024)
            "${usedMemoryMB}MB"
        } catch (e: Exception) {
            "N/A"
        }
    }

    private fun collectCpuInfo(): String {
        return try {
            // Simulate CPU usage (in real implementation, you'd read from /proc/stat)
            "${Random.nextInt(10, 80)}%"
        } catch (e: Exception) {
            "N/A"
        }
    }

    private fun collectBatteryInfo(): String {
        return try {
            // Simulate battery level (in real implementation, you'd use BatteryManager)
            "${Random.nextInt(20, 100)}%"
        } catch (e: Exception) {
            "N/A"
        }
    }

    private fun logMessage(message: String) {
        logBuilder.append(message).append("\n")
        
        // Keep only last 100 lines
        val lines = logBuilder.toString().split("\n")
        if (lines.size > 100) {
            logBuilder.clear()
            logBuilder.append(lines.takeLast(100).joinToString("\n"))
        }
        
        logUpdateListener?.invoke(logBuilder.toString())
        Log.d(TAG, message)
    }
}