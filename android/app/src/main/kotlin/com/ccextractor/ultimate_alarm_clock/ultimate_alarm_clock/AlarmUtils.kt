package com.ccextractor.ultimate_alarm_clock.ultimate_alarm_clock

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.annotation.SuppressLint
import com.ccextractor.ultimate_alarm_clock.AlarmReceiver
import com.ccextractor.ultimate_alarm_clock.MainActivity
import com.ccextractor.ultimate_alarm_clock.ScreenMonitorService
import com.ccextractor.ultimate_alarm_clock.LogDatabaseHelper
import java.text.SimpleDateFormat
import java.util.*
import java.util.Locale

object AlarmUtils {
    @SuppressLint("ScheduleExactAlarm")
    fun scheduleAlarm(
        context: Context,
        intervalToAlarm: Long,
        isActivity: Int,
        isLocation: Int,
        location: String,
        locationConditionType: Int,
        isWeather: Int,
        weatherTypes: String,
        weatherConditionType: Int,
        isShared: Boolean = false,
        alarmID: String = ""
    ) {
        val alarmType = if (isShared) "shared" else "local"
        val logdbHelper = LogDatabaseHelper(context)
        
        try {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val triggerAtMillis = System.currentTimeMillis() + intervalToAlarm
        
            Log.d("AlarmUtils", "Scheduling $alarmType alarm for ${Date(triggerAtMillis)} with ID: $alarmID")
        
            val intent = Intent(context, AlarmReceiver::class.java).apply {
                putExtra("isActivity", isActivity)
                putExtra("isLocation", isLocation)
                putExtra("location", location)
                putExtra("locationConditionType", locationConditionType)
                putExtra("isWeather", isWeather)
                putExtra("weatherTypes", weatherTypes)
                putExtra("weatherConditionType", weatherConditionType)
                if (isShared) {
                    putExtra("isSharedAlarm", true)
                    Log.d("AlarmUtils", "Setting isSharedAlarm flag in intent")
                }
                if (alarmID.isNotEmpty()) {
                    putExtra("alarmID", alarmID)
                }
            }
        
            val requestCode = if (isShared) 
                MainActivity.REQUEST_CODE_SHARED_ALARM 
            else 
                MainActivity.REQUEST_CODE_LOCAL_ALARM
            
            Log.d("AlarmUtils", "Using request code $requestCode for $alarmType alarm")
        
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent
                )
            }
            
            Log.d("AlarmUtils", "$alarmType alarm successfully scheduled for ${Date(triggerAtMillis)}")
            
            // Main detailed alarm scheduling log (NORMAL - always visible)
            val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
            val alarmTime = timeFormat.format(Date(triggerAtMillis))
            val detailedMessage = buildDetailedAlarmScheduleMessage(
                alarmTime, alarmType, alarmID, isActivity, isLocation, 
                locationConditionType, location, isWeather, weatherConditionType, weatherTypes
            )
            
            logdbHelper.insertLog(
                detailedMessage,
                status = LogDatabaseHelper.Status.SUCCESS,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 0,
                alarmID = alarmID
            )
            
            // Developer log (DEV - only in developer mode)
            val devMessage = "System scheduled $alarmType alarm with request code $requestCode"
            logdbHelper.insertLog(
                devMessage,
                status = LogDatabaseHelper.Status.SUCCESS,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0,
                alarmID = alarmID
            )
            
            if (isActivity == 1) {
                scheduleActivityMonitoring(context, alarmManager, isShared, triggerAtMillis)
            }
        } catch (e: Exception) {
            Log.e("AlarmUtils", "Error scheduling $alarmType alarm: ${e.message}")
            
            // Main error log (NORMAL - always visible)
            logdbHelper.insertLog(
                "Failed to schedule ${alarmType.uppercase()} ALARM - Error: ${e.message}",
                status = LogDatabaseHelper.Status.ERROR,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 0,
                alarmID = alarmID
            )
            
            // Developer error log (DEV - only in developer mode)
            logdbHelper.insertLog(
                "System error during $alarmType alarm scheduling: ${e.message}",
                status = LogDatabaseHelper.Status.ERROR,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0,
                alarmID = alarmID
            )
        }
    }

    fun cancelAlarmById(context: Context, alarmID: String, isShared: Boolean) {
        val logdbHelper = LogDatabaseHelper(context)
        val alarmType = if (isShared) "shared" else "local"
        
        try {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, AlarmReceiver::class.java)
            
            val requestCode = if (isShared) 
                MainActivity.REQUEST_CODE_SHARED_ALARM 
            else 
                MainActivity.REQUEST_CODE_LOCAL_ALARM
            
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            
            alarmManager.cancel(pendingIntent)
            
            Log.d("AlarmUtils", "Canceled $alarmType alarm with ID: $alarmID")
            
            // Main detailed cancellation log (NORMAL - always visible)
            val detailedMessage = "CANCELLED ${alarmType.uppercase()} ALARM - ID: $alarmID, Type: ${alarmType.uppercase()}, Status: System cancelled"
            logdbHelper.insertLog(
                detailedMessage,
                status = LogDatabaseHelper.Status.WARNING,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 0,
                alarmID = alarmID
            )
            
            // Developer log (DEV - only in developer mode)
            logdbHelper.insertLog(
                "System cancelled $alarmType alarm using request code $requestCode",
                status = LogDatabaseHelper.Status.WARNING,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0,
                alarmID = alarmID
            )
        } catch (e: Exception) {
            Log.e("AlarmUtils", "Error canceling alarm with ID $alarmID: ${e.message}")
            
            // Main error log (NORMAL - always visible)
            logdbHelper.insertLog(
                "Failed to cancel ${alarmType.uppercase()} ALARM - ID: $alarmID, Error: ${e.message}",
                status = LogDatabaseHelper.Status.ERROR,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 0,
                alarmID = alarmID
            )
            
            // Developer error log (DEV - only in developer mode)
            logdbHelper.insertLog(
                "System error during $alarmType alarm cancellation: ${e.message}",
                status = LogDatabaseHelper.Status.ERROR,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0,
                alarmID = alarmID
            )
        }
    }

    private fun scheduleActivityMonitoring(
        context: Context,
        alarmManager: AlarmManager,
        isShared: Boolean,
        triggerAtMillis: Long
    ) {
        val logdbHelper = LogDatabaseHelper(context)
        try {
            val activityCheckIntent = Intent(context, ScreenMonitorService::class.java).apply {
                if (isShared) {
                    putExtra("isSharedAlarm", true)
                }
            }
            
            val requestCode = if (isShared) 
                MainActivity.REQUEST_CODE_SHARED_ACTIVITY 
            else 
                MainActivity.REQUEST_CODE_LOCAL_ACTIVITY
            
            val pendingActivityCheckIntent = PendingIntent.getService(
                context,
                requestCode,
                activityCheckIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            
            val activityCheckTime = triggerAtMillis - (15 * 60 * 1000)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    activityCheckTime,
                    pendingActivityCheckIntent
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    activityCheckTime,
                    pendingActivityCheckIntent
                )
            }
            
            val alarmType = if (isShared) "shared" else "local"
            Log.d("AlarmUtils", "Activity monitoring for $alarmType alarm scheduled for ${Date(activityCheckTime)}")
            
            // Log activity monitoring scheduling (DEV only)
            logdbHelper.insertLog(
                "Activity monitoring scheduled for $alarmType alarm (15 min before trigger)",
                status = LogDatabaseHelper.Status.SUCCESS,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0
            )
        } catch (e: Exception) {
            Log.e("AlarmUtils", "Error scheduling activity monitoring: ${e.message}")
            logdbHelper.insertLog(
                "Failed to schedule activity monitoring: ${e.message}",
                status = LogDatabaseHelper.Status.ERROR,
                type = LogDatabaseHelper.LogType.DEV,
                hasRung = 0
            )
        }
    }
    
    private fun buildDetailedAlarmScheduleMessage(
        alarmTime: String,
        alarmType: String,
        alarmID: String,
        isActivity: Int,
        isLocation: Int,
        locationConditionType: Int,
        location: String,
        isWeather: Int,
        weatherConditionType: Int,
        weatherTypes: String
    ): String {
        val conditions = mutableListOf<String>()
        
        // Activity condition
        if (isActivity == 1) {
            conditions.add("Activity Monitoring: ENABLED")
        } else {
            conditions.add("Activity Monitoring: OFF")
        }
        
        // Location condition
        if (isLocation == 1) {
            val locCondition = when (locationConditionType) {
                1 -> "Ring when AT location"
                2 -> "Cancel when AT location"
                3 -> "Ring when AWAY from location"
                4 -> "Cancel when AWAY from location"
                else -> "Unknown location condition"
            }
            conditions.add("Location: $locCondition ($location)")
        } else {
            conditions.add("Location: OFF")
        }
        
        // Weather condition
        if (isWeather == 1) {
            val weatherCondition = when (weatherConditionType) {
                1 -> "Ring when weather matches"
                2 -> "Cancel when weather matches"
                3 -> "Ring when weather different"
                4 -> "Cancel when weather different"
                else -> "Unknown weather condition"
            }
            conditions.add("Weather: $weatherCondition ($weatherTypes)")
        } else {
            conditions.add("Weather: OFF")
        }
        
        return "SCHEDULED ${alarmType.uppercase()} ALARM - Time: $alarmTime, ID: $alarmID, Type: ${alarmType.uppercase()}, Conditions: [${conditions.joinToString(", ")}]"
    }
} 