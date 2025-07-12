package com.ccextractor.ultimate_alarm_clock

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AlarmReceiver : BroadcastReceiver() {
    companion object {
        private var lastTriggeredTime = 0L
        private var lastTriggeredType = ""
        private const val DUPLICATE_PREVENTION_WINDOW = 10000 // 10 seconds
    }
    
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) {
            Log.e("AlarmReceiver", "Received null context or intent")
            return
        }
        val extras = intent.extras
        Log.d("AlarmReceiver", "All intent extras: ${extras?.keySet()?.joinToString(", ") { "$it: ${extras.get(it)}" }}")

        val isSharedAlarm = intent.getBooleanExtra("isSharedAlarm", false)
        val currentTime = System.currentTimeMillis()
        val alarmType = if (isSharedAlarm) "shared" else "local"
        
        Log.d("AlarmReceiver", "===== ALARM FIRED: $alarmType ALARM =====")
        if (currentTime - lastTriggeredTime < DUPLICATE_PREVENTION_WINDOW && 
            alarmType == lastTriggeredType) {
            Log.d("AlarmReceiver", "Preventing duplicate $alarmType alarm trigger (within ${DUPLICATE_PREVENTION_WINDOW}ms)")
            return
        }
        
        lastTriggeredTime = currentTime
        lastTriggeredType = alarmType
        
        val logdbHelper = LogDatabaseHelper(context)
        val flutterIntent = Intent(context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            putExtra("initialRoute", "/")
            putExtra("alarmRing", "true")
            putExtra("isAlarm", "true")
            if (isSharedAlarm) {
                putExtra("isSharedAlarm", true)
                Log.d("AlarmReceiver", "Setting isSharedAlarm=true in Flutter intent")
            } else {
                putExtra("isSharedAlarm", false)
                Log.d("AlarmReceiver", "This is a local alarm - setting isSharedAlarm=false")
            }
        }
        
        val sharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        Log.d("AlarmReceiver", "ALARM TRIGGERED: $alarmType alarm at ${getCurrentTime()}")
        println("ANDROID ALARM TRIGGERED: $alarmType alarm at ${getCurrentTime()}")
        
        checkOtherScheduledAlarms(context, isSharedAlarm)
        
        val prefix = if (isSharedAlarm) "flutter.shared_" else "flutter."
        val screenOnTimeInMillis = sharedPreferences.getLong("${prefix}is_screen_on", 0L)
        val screenOffTimeInMillis = sharedPreferences.getLong("${prefix}is_screen_off", 0L)
        
        val activityConditionType = sharedPreferences.getInt("flutter.activity_condition_type", 0)
        val activityInterval = sharedPreferences.getInt("flutter.activity_interval", 30)
        
        val activityCheckIntent = Intent(context, ScreenMonitorService::class.java)
        context.stopService(activityCheckIntent)
        
        val isLocationEnabled = intent.getIntExtra("isLocation", 0) == 1
        val isActivityEnabled = intent.getIntExtra("isActivity", 0) == 1
        val isWeatherEnabled = intent.getIntExtra("isWeather", 0) == 1

        Log.d("AlarmReceiver", "Screen On: $screenOnTimeInMillis, Screen Off: $screenOffTimeInMillis")
        Log.d("AlarmReceiver", "Condition Type: $activityConditionType, Interval: $activityInterval minutes")
        Log.d("AlarmReceiver", "Location Enabled: $isLocationEnabled, Activity Enabled: $isActivityEnabled")
        Log.d("AlarmReceiver", "Weather Enabled: $isWeatherEnabled")
        
        // If location condition is enabled, start LocationFetcherService to handle location logic
        if (isLocationEnabled) {
            Log.d("AlarmReceiver", "Location condition enabled, starting LocationFetcherService")
            val locationConditionType = intent.getIntExtra("locationConditionType", 2)
            Log.d("AlarmReceiver", "Passing locationConditionType: $locationConditionType to LocationFetcherService")
            val locationIntent = Intent(context, LocationFetcherService::class.java).apply {
                putExtra("alarmID", intent.getStringExtra("alarmID"))
                putExtra("location", intent.getStringExtra("location"))
                putExtra("locationConditionType", locationConditionType)
                putExtra("isSharedAlarm", isSharedAlarm)
            }
            context.startForegroundService(locationIntent)
            return // LocationFetcherService will handle the rest
        }
        
        // If weather condition is enabled, start WeatherFetcherService to handle weather logic
        if (isWeatherEnabled) {
            Log.d("AlarmReceiver", "Weather condition enabled, starting WeatherFetcherService")
            val weatherIntent = Intent(context, WeatherFetcherService::class.java).apply {
                putExtra("alarmID", intent.getStringExtra("alarmID"))
                putExtra("weatherTypes", intent.getStringExtra("weatherTypes"))
                putExtra("weatherConditionType", intent.getIntExtra("weatherConditionType", 2))
                putExtra("isSharedAlarm", isSharedAlarm)
            }
            context.startForegroundService(weatherIntent)
            return // WeatherFetcherService will handle the rest
        }
        
        // If no screen activity monitoring (off or no data), ring the alarm
        if (!isActivityEnabled || activityConditionType == 0 || Math.abs(screenOnTimeInMillis - screenOffTimeInMillis) < 180000 || screenOnTimeInMillis - screenOffTimeInMillis == 0L) {
            println("ANDROID STARTING APP")
            context.startActivity(flutterIntent)

            if (isSharedAlarm) {
                logdbHelper.insertLog(
                    "Shared alarm is ringing at ${getCurrentTime()}",
                    status = LogDatabaseHelper.Status.SUCCESS,
                    type = LogDatabaseHelper.LogType.NORMAL,
                    hasRung = 1
                )
                return
            }
            
            if((screenOnTimeInMillis - screenOffTimeInMillis) == 0L) {
                // if alarm rings (no smart controls used)
                logdbHelper.insertLog(
                    "Alarm is ringing",
                    status = LogDatabaseHelper.Status.SUCCESS,
                    type = LogDatabaseHelper.LogType.NORMAL,
                    hasRung = 1
                )
                return
            }

            logdbHelper.insertLog(
                "Alarm is ringing (no screen activity monitoring)",
                status = LogDatabaseHelper.Status.SUCCESS,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 1
            )
            return
        }

        val currentTimeMillis = System.currentTimeMillis()
        val intervalInMillis = activityInterval * 60 * 1000L // Convert minutes to milliseconds
        
        val lastActivityTime = maxOf(screenOnTimeInMillis, screenOffTimeInMillis)
        val timeSinceLastActivity = currentTimeMillis - lastActivityTime
        val isActiveWithinInterval = timeSinceLastActivity <= intervalInMillis
        
        Log.d("AlarmReceiver", "Time since last activity: ${timeSinceLastActivity / 1000} seconds")
        Log.d("AlarmReceiver", "Active within interval ($activityInterval min): $isActiveWithinInterval")

        var shouldRing = false
        var logMessage = ""

        when (activityConditionType) {
            1 -> { // Ring when active
                shouldRing = isActiveWithinInterval
                logMessage = if (shouldRing) {
                    "Alarm is ringing - you have been active within $activityInterval minutes"
                } else {
                    "Alarm cancelled - you have NOT been active within $activityInterval minutes"
                }
            }
            2 -> { // Cancel when active (original behavior)
                shouldRing = !isActiveWithinInterval
                logMessage = if (shouldRing) {
                    "Alarm is ringing - you have NOT been active within $activityInterval minutes"
                } else {
                    "Alarm cancelled - you have been active within $activityInterval minutes"
                }
            }
            3 -> { // Ring when inactive
                shouldRing = !isActiveWithinInterval
                logMessage = if (shouldRing) {
                    "Alarm is ringing - you have been inactive for more than $activityInterval minutes"
                } else {
                    "Alarm cancelled - you have been active within $activityInterval minutes"
                }
            }
            4 -> { // Cancel when inactive
                shouldRing = isActiveWithinInterval
                logMessage = if (shouldRing) {
                    "Alarm is ringing - you have been active within $activityInterval minutes"
                } else {
                    "Alarm cancelled - you have been inactive for more than $activityInterval minutes"
                }
            }
            else -> {
                // Default to ringing if unknown condition type
                shouldRing = true
                logMessage = "Alarm is ringing (unknown condition type: $activityConditionType)"
            }
        }

        Log.d("AlarmReceiver", "Decision: shouldRing = $shouldRing")

        if (shouldRing) {
            println("ANDROID STARTING APP")
            context.startActivity(flutterIntent)
            logdbHelper.insertLog(
                logMessage,
                status = LogDatabaseHelper.Status.SUCCESS,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 1
            )
        } else {
            logdbHelper.insertLog(
                logMessage,
                status = LogDatabaseHelper.Status.WARNING,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 0
            )
        }
    }

    private fun checkOtherScheduledAlarms(context: Context, isCurrentAlarmShared: Boolean) {
        try {
            val requestCode = if (isCurrentAlarmShared) 
                MainActivity.REQUEST_CODE_LOCAL_ALARM 
            else 
                MainActivity.REQUEST_CODE_SHARED_ALARM
                
            val intent = Intent(context, AlarmReceiver::class.java).apply {
                if (!isCurrentAlarmShared) {
                    putExtra("isSharedAlarm", true)
                }
            }
            
            val pendingIntent = android.app.PendingIntent.getBroadcast(
                context,
                requestCode,
                intent,
                android.app.PendingIntent.FLAG_NO_CREATE or android.app.PendingIntent.FLAG_IMMUTABLE
            )
            
            val alarmType = if (isCurrentAlarmShared) "local" else "shared"
            if (pendingIntent != null) {
                Log.d("AlarmReceiver", "Found scheduled $alarmType alarm")
            } else {
                Log.d("AlarmReceiver", "No scheduled $alarmType alarm found")
            }
            
        } catch (e: Exception) {
            Log.e("AlarmReceiver", "Error checking other scheduled alarms: ${e.message}")
        }
    }

    private fun getCurrentTime(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
        return dateFormat.format(Date())
    }
}
