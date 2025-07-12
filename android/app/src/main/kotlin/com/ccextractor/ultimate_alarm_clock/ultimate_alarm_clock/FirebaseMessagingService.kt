package com.ccextractor.ultimate_alarm_clock


import android.app.AlarmManager
import android.content.Context
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.util.Date
import java.util.Locale
import android.util.Log
import android.icu.text.SimpleDateFormat
import com.ccextractor.ultimate_alarm_clock.MainActivity
import com.ccextractor.ultimate_alarm_clock.ultimate_alarm_clock.AlarmUtils
import com.ccextractor.ultimate_alarm_clock.LogDatabaseHelper
import java.util.Calendar
import android.app.PendingIntent
import android.content.Intent
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.core.app.NotificationCompat
import android.app.ActivityManager

class FirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        
        Log.d("FCM", "📱 FCM Message received: ${remoteMessage.data}")
        Log.d("FCM", "📱 App state: ${if (isAppInForeground()) "FOREGROUND" else "BACKGROUND/KILLED"}")
        
        val data = remoteMessage.data
        val notificationType = data["type"]
        
        when (notificationType) {
            "rescheduleAlarm" -> {
                Log.d("FCM", "🔔 Received reschedule alarm notification")
                handleRescheduleAlarm(data)
                
                
                val alarmTime = data["newAlarmTime"] ?: "Unknown"
                val ownerName = data["ownerName"] ?: "Someone"
                showNotification(
                    "Shared Alarm Updated! 🔔",
                    "$ownerName updated your shared alarm to $alarmTime"
                )
            }
            "sharedAlarm" -> {
                Log.d("FCM", "🔔 Received shared alarm notification")
                
                showNotification(
                    remoteMessage.notification?.title ?: "Shared Alarm",
                    remoteMessage.notification?.body ?: "You have a new shared alarm"
                )
            }
            else -> {
                Log.d("FCM", "🔔 Received general notification")
                
                if (remoteMessage.notification != null) {
                    showNotification(
                        remoteMessage.notification!!.title ?: "Notification",
                        remoteMessage.notification!!.body ?: "You have a new notification"
                    )
                }
            }
        }
    }

    private fun handleRescheduleAlarm(data: Map<String, String>) {
        try {
            val alarmId = data["alarmId"] ?: data["firestoreAlarmId"] ?: ""
            val newAlarmTime = data["newAlarmTime"] ?: ""
            
            Log.d("FCM", "🔄 Handling reschedule for alarm: $alarmId to time: $newAlarmTime")
            
            if (alarmId.isEmpty() || newAlarmTime.isEmpty()) {
                Log.e("FCM", "❌ Missing required data for reschedule: alarmId=$alarmId, newTime=$newAlarmTime")
                return
            }
            
            
            val sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            
            
            val currentAlarmId = sharedPreferences.getString("flutter.shared_alarm_id", "")
            val hasActiveSharedAlarm = sharedPreferences.getBoolean("flutter.has_active_shared_alarm", false)
            
            Log.d("FCM", "📋 Current state - hasActiveAlarm: $hasActiveSharedAlarm, currentId: $currentAlarmId")
            
            if (!hasActiveSharedAlarm || currentAlarmId != alarmId) {
                Log.d("FCM", "⚠️ This alarm is not currently active on this device, ignoring reschedule")
                return
            }
            
            
            Log.d("FCM", "🗑️ Canceling existing shared alarm")
            cancelSharedAlarm()
            
            
            val newIntervalToAlarm = parseAlarmTimeToInterval(newAlarmTime)
            if (newIntervalToAlarm <= 0) {
                Log.e("FCM", "❌ New alarm time is in the past or invalid: $newAlarmTime")
                // Clear the shared alarm data since it's no longer valid
                clearSharedAlarmData()
                return
            }
            
            
            val isActivityEnabled = sharedPreferences.getInt("flutter.shared_alarm_activity", 0) == 1
            val isLocationEnabled = sharedPreferences.getInt("flutter.shared_alarm_location", 0) == 1
            val location = sharedPreferences.getString("flutter.shared_alarm_location_data", "0.0,0.0") ?: "0.0,0.0"
            val locationConditionType = sharedPreferences.getInt("flutter.shared_alarm_location_condition", 2)
            val isWeatherEnabled = sharedPreferences.getInt("flutter.shared_alarm_weather", 0) == 1
            val weatherTypes = sharedPreferences.getString("flutter.shared_alarm_weather_types", "[]") ?: "[]"
            val weatherConditionType = sharedPreferences.getInt("flutter.shared_alarm_weather_condition", 2)
            
            Log.d("FCM", "🔧 Rescheduling with config - activity: $isActivityEnabled, location: $isLocationEnabled, weather: $isWeatherEnabled")
            
            
            AlarmUtils.scheduleAlarm(
                this,
                newIntervalToAlarm,
                if (isActivityEnabled) 1 else 0,
                if (isLocationEnabled) 1 else 0,
                location,
                locationConditionType,
                if (isWeatherEnabled) 1 else 0,
                weatherTypes,
                weatherConditionType,
                true, // isShared = true
                alarmId
            )
            
            
            val editor = sharedPreferences.edit()
            editor.putString("flutter.shared_alarm_time", newAlarmTime)
            editor.apply()
            
            Log.d("FCM", "✅ Successfully rescheduled shared alarm to: $newAlarmTime")
            
            // Log the rescheduling
            val logdbHelper = LogDatabaseHelper(this)
            logdbHelper.insertLog(
                "Shared alarm rescheduled remotely to $newAlarmTime (ID: $alarmId)",
                status = LogDatabaseHelper.Status.SUCCESS,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0,
                alarmID = alarmId
            )
            
            showNotification(
                "Alarm Updated",
                "Your shared alarm has been updated to $newAlarmTime"
            )
            
        } catch (e: Exception) {
            Log.e("FCM", "❌ Error handling reschedule alarm: ${e.message}")
            
            // Log the error
            val logdbHelper = LogDatabaseHelper(this)
            logdbHelper.insertLog(
                "Failed to reschedule shared alarm remotely: ${e.message}",
                status = LogDatabaseHelper.Status.ERROR,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0
            )
        }
    }
    
    private fun parseAlarmTimeToInterval(alarmTime: String): Long {
        try {
            
            val parts = alarmTime.split(":")
            if (parts.size != 2) return 0
            
            val hour = parts[0].toInt()
            val minute = parts[1].toInt()
            
            val calendar = Calendar.getInstance()
            val now = Calendar.getInstance()
            
            calendar.set(Calendar.HOUR_OF_DAY, hour)
            calendar.set(Calendar.MINUTE, minute)
            calendar.set(Calendar.SECOND, 0)
            calendar.set(Calendar.MILLISECOND, 0)
            
            
            if (calendar.before(now)) {
                calendar.add(Calendar.DAY_OF_MONTH, 1)
            }
            
            val intervalToAlarm = calendar.timeInMillis - now.timeInMillis
            Log.d("FCM", "⏰ Parsed alarm time $alarmTime to interval: ${intervalToAlarm}ms")
            
            return intervalToAlarm
        } catch (e: Exception) {
            Log.e("FCM", "❌ Error parsing alarm time $alarmTime: ${e.message}")
            return 0
        }
    }
    
    private fun cancelSharedAlarm() {
        try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(this, AlarmReceiver::class.java).apply {
                putExtra("isSharedAlarm", true)
            }
            
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                MainActivity.REQUEST_CODE_SHARED_ALARM,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            
            alarmManager.cancel(pendingIntent)
            Log.d("FCM", "🗑️ Canceled existing shared alarm")
        } catch (e: Exception) {
            Log.e("FCM", "❌ Error canceling shared alarm: ${e.message}")
        }
    }
    
    private fun clearSharedAlarmData() {
        val sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putBoolean("flutter.has_active_shared_alarm", false)
        editor.remove("flutter.shared_alarm_time")
        editor.remove("flutter.shared_alarm_id")
        editor.remove("flutter.shared_alarm_activity")
        editor.remove("flutter.shared_alarm_location")
        editor.remove("flutter.shared_alarm_location_data")
        editor.remove("flutter.shared_alarm_location_condition")
        editor.remove("flutter.shared_alarm_weather")
        editor.remove("flutter.shared_alarm_weather_types")
        editor.remove("flutter.shared_alarm_weather_condition")
        editor.apply()
        
        Log.d("FCM", "🧹 Cleared shared alarm data")
    }

    private fun showNotification(title: String, message: String) {
        try {
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    "alarm_updates",
                    "Alarm Updates",
                    NotificationManager.IMPORTANCE_HIGH
                )
                notificationManager.createNotificationChannel(channel)
            }
            
            
            val notification = NotificationCompat.Builder(this, "alarm_updates")
                .setContentTitle(title)
                .setContentText(message)
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .build()
            
            notificationManager.notify(System.currentTimeMillis().toInt(), notification)
            Log.d("FCM", "📬 Notification shown: $title - $message")
        } catch (e: Exception) {
            Log.e("FCM", "❌ Error showing notification: ${e.message}")
        }
    }

    private fun isAppInForeground(): Boolean {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val appProcesses = activityManager.runningAppProcesses ?: return false
        
        val packageName = packageName
        for (appProcess in appProcesses) {
            if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND 
                && appProcess.processName == packageName) {
                return true
            }
        }
        return false
    }
}