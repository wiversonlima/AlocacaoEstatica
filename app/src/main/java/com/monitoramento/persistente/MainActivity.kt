package com.monitoramento.persistente

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Bundle
import android.os.IBinder
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.monitoramento.persistente.admin.DeviceAdminReceiver
import com.monitoramento.persistente.services.MonitoringService

class MainActivity : AppCompatActivity() {

    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var adminComponent: ComponentName
    private lateinit var adminStatusText: TextView
    private lateinit var monitoringStatusText: TextView
    private lateinit var toggleAdminButton: Button
    private lateinit var toggleMonitoringButton: Button
    private lateinit var logText: TextView

    private var monitoringService: MonitoringService? = null
    private var isServiceBound = false

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            val binder = service as MonitoringService.LocalBinder
            monitoringService = binder.getService()
            isServiceBound = true
            updateMonitoringStatus()
            
            // Set up log updates
            monitoringService?.setLogUpdateListener { log ->
                runOnUiThread {
                    logText.text = log
                }
            }
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            monitoringService = null
            isServiceBound = false
            updateMonitoringStatus()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        initializeViews()
        initializeDeviceAdmin()
        setupClickListeners()
        updateUI()
    }

    override fun onResume() {
        super.onResume()
        updateUI()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (isServiceBound) {
            unbindService(serviceConnection)
            isServiceBound = false
        }
    }

    private fun initializeViews() {
        adminStatusText = findViewById(R.id.adminStatusText)
        monitoringStatusText = findViewById(R.id.monitoringStatusText)
        toggleAdminButton = findViewById(R.id.toggleAdminButton)
        toggleMonitoringButton = findViewById(R.id.toggleMonitoringButton)
        logText = findViewById(R.id.logText)
    }

    private fun initializeDeviceAdmin() {
        devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        adminComponent = ComponentName(this, DeviceAdminReceiver::class.java)
    }

    private fun setupClickListeners() {
        toggleAdminButton.setOnClickListener {
            if (isDeviceAdminActive()) {
                disableDeviceAdmin()
            } else {
                enableDeviceAdmin()
            }
        }

        toggleMonitoringButton.setOnClickListener {
            if (isMonitoringActive()) {
                stopMonitoring()
            } else {
                startMonitoring()
            }
        }
    }

    private fun updateUI() {
        updateAdminStatus()
        updateMonitoringStatus()
    }

    private fun updateAdminStatus() {
        val isActive = isDeviceAdminActive()
        adminStatusText.text = if (isActive) getString(R.string.enabled) else getString(R.string.disabled)
        adminStatusText.setTextColor(
            ContextCompat.getColor(
                this,
                if (isActive) android.R.color.holo_green_dark else android.R.color.holo_red_dark
            )
        )
        toggleAdminButton.text = if (isActive) getString(R.string.disable_device_admin) else getString(R.string.enable_device_admin)
    }

    private fun updateMonitoringStatus() {
        val isActive = isMonitoringActive()
        monitoringStatusText.text = if (isActive) getString(R.string.enabled) else getString(R.string.disabled)
        monitoringStatusText.setTextColor(
            ContextCompat.getColor(
                this,
                if (isActive) android.R.color.holo_green_dark else android.R.color.holo_red_dark
            )
        )
        toggleMonitoringButton.text = if (isActive) getString(R.string.stop_monitoring) else getString(R.string.start_monitoring)
    }

    private fun isDeviceAdminActive(): Boolean {
        return devicePolicyManager.isAdminActive(adminComponent)
    }

    private fun isMonitoringActive(): Boolean {
        return MonitoringService.isRunning
    }

    private fun enableDeviceAdmin() {
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent)
        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, getString(R.string.device_admin_description))
        startActivityForResult(intent, REQUEST_CODE_ENABLE_ADMIN)
    }

    private fun disableDeviceAdmin() {
        devicePolicyManager.removeActiveAdmin(adminComponent)
        updateAdminStatus()
    }

    private fun startMonitoring() {
        val serviceIntent = Intent(this, MonitoringService::class.java)
        ContextCompat.startForegroundService(this, serviceIntent)
        bindService(serviceIntent, serviceConnection, Context.BIND_AUTO_CREATE)
    }

    private fun stopMonitoring() {
        if (isServiceBound) {
            unbindService(serviceConnection)
            isServiceBound = false
        }
        val serviceIntent = Intent(this, MonitoringService::class.java)
        stopService(serviceIntent)
        updateMonitoringStatus()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_ENABLE_ADMIN) {
            updateAdminStatus()
        }
    }

    companion object {
        private const val REQUEST_CODE_ENABLE_ADMIN = 1
    }
}