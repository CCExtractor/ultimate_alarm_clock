package com.ccextractor.ultimate_alarm_clock

import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.display.DisplayManager
import android.os.IBinder
import android.util.Log
import android.view.Display
import java.util.Calendar
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent

import android.content.SharedPreferences

import androidx.core.app.NotificationCompat
import java.util.Date

class ScreenMonitorService : Service() {

    private val CHANNEL_ID = "wake_up_activity_monitor_channel"
    private val notificationId = 3

    private lateinit var receiver: ScreenBroadcastReceiver
    private lateinit var sharedPreferences: SharedPreferences
    private lateinit var displayManager: DisplayManager

    override fun onCreate() {
        super.onCreate()

        sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager

        createNotificationChannel()

        val intentFilter = IntentFilter(Intent.ACTION_SCREEN_ON).apply {
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        receiver = ScreenBroadcastReceiver()
        registerReceiver(receiver, intentFilter)
        val currentDate = Date()
        val currentTimeMillis = currentDate.time
        Log.d("ScreenMonitorService", "time: $currentTimeMillis")
        // Check initial screen state on service creation
        if (displayManager.getDisplay(0).getState() == Display.STATE_ON) {
            updateScreenStatus(currentTimeMillis, true)
        } else {
            updateScreenStatus(currentTimeMillis, false)
        }
    }

    private fun createNotificationChannel() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val name = "Wake up activity"
            val description = "Checking if user awake"
            val importance = NotificationManager.IMPORTANCE_MIN

            val channel = NotificationChannel(CHANNEL_ID, name, importance)
            channel.description = description

            // Register the channel with the system; you can also configure its behavior (e.g., sound) here
            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun updateScreenStatus(time: Long, isScreenOn: Boolean) {
        val editor = sharedPreferences.edit()
        if (isScreenOn) {
            editor.putLong("flutter.is_screen_on", time)
        } else {
            editor.putLong("flutter.is_screen_off", time)
        }
        editor.apply()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(notificationId, getNotification())
        return START_STICKY
    }

    private fun getNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java) // Replace with your main activity
        val pendingIntent =
            PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE)

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Wake up activity")
            .setContentText("Checking if user is awake")
            .setSmallIcon(R.mipmap.launcher_icon) // Replace with your icon drawable
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setCategory(Notification.CATEGORY_SERVICE)

        return notification.build()
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(receiver)
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }


}

class ScreenBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        val sharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val currentDate = Date()
        val mSec = currentDate.time
        val editor = sharedPreferences.edit()
        Log.d("ScreenBroadcastReceiver", "time: $mSec")
        if (action == Intent.ACTION_SCREEN_ON) {
            editor.putLong("flutter.is_screen_on", mSec)
            editor.apply()
        } else if (action == Intent.ACTION_SCREEN_OFF) {
            editor.putLong("flutter.is_screen_off", mSec)
            editor.apply()
        }
    }
}
