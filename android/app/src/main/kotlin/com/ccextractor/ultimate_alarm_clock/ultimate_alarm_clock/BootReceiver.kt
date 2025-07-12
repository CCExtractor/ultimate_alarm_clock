package com.ccextractor.ultimate_alarm_clock

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.CountDownTimer
import androidx.core.app.NotificationCompat
import com.ccextractor.ultimate_alarm_clock.getLatestTimer
import com.ccextractor.ultimate_alarm_clock.ultimate_alarm_clock.AlarmUtils
import com.ccextractor.ultimate_alarm_clock.LogDatabaseHelper
import android.util.Log
import java.util.Calendar
import java.text.SimpleDateFormat
import java.util.Locale


class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            Log.d("BootReceiver", "📱 Device boot completed - checking for alarms to reschedule")
            
           val sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val profile = sharedPreferences.getString("flutter.profile", "Default")

            val nextLocalAlarm = determineNextAlarm(context, profile ?: "Default")
            val logdbHelper = LogDatabaseHelper(context)
            
            if (nextLocalAlarm != null) {
                val isSharedAlarm = nextLocalAlarm["isSharedAlarm"] as? Boolean ?: false
                
                if (!isSharedAlarm) {
                    AlarmUtils.scheduleAlarm(
                        context,
                        nextLocalAlarm["interval"] as Long,
                        nextLocalAlarm["isActivity"] as Int,
                        nextLocalAlarm["isLocation"] as Int,
                        nextLocalAlarm["location"] as String,
                        nextLocalAlarm["locationConditionType"] as? Int ?: 2,
                        nextLocalAlarm["isWeather"] as Int,
                        nextLocalAlarm["weatherTypes"] as String,
                        nextLocalAlarm["weatherConditionType"] as? Int ?: 2,
                        false,
                        ""
                    )
                    Log.d("BootReceiver", "✅ Rescheduled local alarm after boot")
                    logdbHelper.insertLog(
                        "Rescheduled local alarm after device boot",
                        status = LogDatabaseHelper.Status.SUCCESS,
                        type = LogDatabaseHelper.LogType.NORMAL,
                        hasRung = 0
                    )
                }
            } else {
                logdbHelper.insertLog(
                    "No local alarms to reschedule after boot",
                    status = LogDatabaseHelper.Status.WARNING,
                    type = LogDatabaseHelper.LogType.DEV,
                    hasRung = 0
                )
            }
            
            // Reschedule shared alarms
            rescheduleSharedAlarmAfterBoot(context, sharedPreferences)
            
            // Reschedule timers
            rescheduleTimerAfterBoot(context)
        }
    }
    
    private fun determineNextAlarm(context: Context, profile: String): Map<String, Any>? {
        val dbHelper = DatabaseHelper(context)
        val logdbHelper = LogDatabaseHelper(context)
        val db = dbHelper.readableDatabase
        val ringTime = getLatestAlarm(db, true, profile, context)
        db.close()
        return ringTime
    }
    
    private fun rescheduleSharedAlarmAfterBoot(context: Context, sharedPreferences: android.content.SharedPreferences) {
        try {
            // Check if we have an active shared alarm stored
            val hasActiveSharedAlarm = sharedPreferences.getBoolean("flutter.has_active_shared_alarm", false)
           
            if (!hasActiveSharedAlarm) {
                Log.d("BootReceiver", "❌ No active shared alarm found in preferences")
                return
            }
            
            val sharedAlarmTime = sharedPreferences.getString("flutter.shared_alarm_time", null)
            val sharedAlarmId = sharedPreferences.getString("flutter.shared_alarm_id", null)
            
            if (sharedAlarmTime == null || sharedAlarmId == null) {
                Log.d("BootReceiver", "❌ Missing shared alarm data: time=$sharedAlarmTime, id=$sharedAlarmId")
                return
            }
            
            Log.d("BootReceiver", "🔍 Found shared alarm to reschedule: ID=$sharedAlarmId, time=$sharedAlarmTime")
            
            val intervalToAlarm = calculateTimeToAlarm(sharedAlarmTime)
            
            if (intervalToAlarm <= 0) {
                Log.d("BootReceiver", "⏰ Shared alarm time is in the past, clearing cache")
                clearSharedAlarmData(context)
                return
            }
            
            val isActivityEnabled = sharedPreferences.getInt("flutter.shared_alarm_activity", 0)
            val isLocationEnabled = sharedPreferences.getInt("flutter.shared_alarm_location", 0)
            val location = sharedPreferences.getString("flutter.shared_alarm_location_data", "0.0,0.0") ?: "0.0,0.0"
            val locationConditionType = sharedPreferences.getInt("flutter.shared_alarm_location_condition", 2)
            val isWeatherEnabled = sharedPreferences.getInt("flutter.shared_alarm_weather", 0)
            val weatherTypes = sharedPreferences.getString("flutter.shared_alarm_weather_types", "[]") ?: "[]"
            val weatherConditionType = sharedPreferences.getInt("flutter.shared_alarm_weather_condition", 2)
            
            Log.d("BootReceiver", "🔧 Rescheduling shared alarm with config - activity: $isActivityEnabled, location: $isLocationEnabled, weather: $isWeatherEnabled")
            
            AlarmUtils.scheduleAlarm(
                context,
                intervalToAlarm,
                isActivityEnabled,
                isLocationEnabled,
                location,
                locationConditionType,
                isWeatherEnabled,
                weatherTypes,
                weatherConditionType,
                true,
                sharedAlarmId
            )
            
            Log.d("BootReceiver", "✅ Successfully rescheduled shared alarm: $sharedAlarmTime")
            
            // Log the rescheduling
            val logdbHelper = LogDatabaseHelper(context)
            logdbHelper.insertLog(
                "Rescheduled shared alarm after device boot (ID: $sharedAlarmId)",
                status = LogDatabaseHelper.Status.SUCCESS,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 0,
                alarmID = sharedAlarmId
            )
            
        } catch (e: Exception) {
            Log.e("BootReceiver", "❌ Error rescheduling shared alarm after boot: ${e.message}")
            
            // Log the error
            val logdbHelper = LogDatabaseHelper(context)
            logdbHelper.insertLog(
                "Failed to reschedule shared alarm after boot: ${e.message}",
                status = LogDatabaseHelper.Status.ERROR,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0
            )
        }
    }
    
    private fun calculateTimeToAlarm(alarmTime: String): Long {
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
            Log.d("BootReceiver", "⏰ Calculated interval for alarm $alarmTime: ${intervalToAlarm}ms")
            
            return intervalToAlarm
        } catch (e: Exception) {
            Log.e("BootReceiver", "❌ Error calculating time to alarm: ${e.message}")
            return 0
        }
    }
    
    private fun clearSharedAlarmData(context: Context) {
        val sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
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
        
        Log.d("BootReceiver", "🧹 Cleared shared alarm data")
    }

    private fun rescheduleTimerAfterBoot(context: Context) {
        try {
            val timerdbhelper = TimerDatabaseHelper(context)
            val timerdb = timerdbhelper.readableDatabase
            val time = getLatestTimer(timerdb)
            timerdb.close()
            var notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val commonTimer = CommonTimerManager.getCommonTimer(object : TimerListener {
                override fun onTick(millisUntilFinished: Long) {
                    println(millisUntilFinished)
                    showTimerNotification(millisUntilFinished, "Timer", context)
                }

                override fun onFinish() {
                    notificationManager.cancel(1)
                }
            })
            createNotificationChannel(context)

            if (time != null) {
                // Start or stop the timer based on your requirements
                commonTimer.startTimer(time.second)
            }
        } catch (e: Exception) {
            Log.e("BootReceiver", "❌ Error rescheduling timer after boot: ${e.message}")
        }
    }

    private fun createNotificationChannel(context: Context) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                TimerService.TIMER_CHANNEL_ID,
                "Timer Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }


    private fun showTimerNotification(milliseconds: Long, timerName: String, context: Context) {
        var notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val deleteIntent = Intent(context, TimerNotification::class.java)
        deleteIntent.action = "com.ccextractor.ultimate_alarm_clock.STOP_TIMERNOTIF"
        val deletePendingIntent = PendingIntent.getBroadcast(
            context, 5, deleteIntent,
            PendingIntent.FLAG_IMMUTABLE
        )
        val notification = NotificationCompat.Builder(context, TimerService.TIMER_CHANNEL_ID)
            .setSmallIcon(R.mipmap.launcher_icon)
            .setContentText("$timerName")
            .setContentText(formatDuration(milliseconds))
            .setOnlyAlertOnce(true)
            .setDeleteIntent(deletePendingIntent)
            .build()
        notificationManager.notify(1, notification)
    }

    private fun getWeatherConditions(weatherTypes: String): String {
        return weatherTypes
    }

    private fun formatDuration(milliseconds: Long): String {
        val seconds = (milliseconds / 1000) % 60
        val minutes = (milliseconds / (1000 * 60)) % 60
        val hours = (milliseconds / (1000 * 60 * 60)) % 24

        return if (hours > 0) {
            String.format("%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            String.format("%02d:%02d", minutes, seconds)
        }
    }
}