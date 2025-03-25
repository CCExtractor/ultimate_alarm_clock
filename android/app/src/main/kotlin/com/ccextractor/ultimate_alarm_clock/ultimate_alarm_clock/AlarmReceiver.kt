package com.ccextractor.ultimate_alarm_clock

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) {
            return
        }



        val logdbHelper = LogDatabaseHelper(context)
        val flutterIntent = Intent(context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)

            putExtra("initialRoute", "/")
            putExtra("alarmRing", "true")
            putExtra("isAlarm", "true")

        }
        val sharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        val screenOnTimeInMillis = sharedPreferences.getLong("flutter.is_screen_on", 0L)
        val screenOffTimeInMillis = sharedPreferences.getLong("flutter.is_screen_off", 0L)
        val activityCheckIntent = Intent(context, ScreenMonitorService::class.java)
        context.stopService(activityCheckIntent)
        val isLocationEnabled = sharedPreferences.getInt("flutter.is_location_on", 0)

        if (Math.abs(screenOnTimeInMillis - screenOffTimeInMillis) < 180000 || screenOnTimeInMillis - screenOffTimeInMillis == 0L) {
            println("ANDROID STARTING APP")
            context.startActivity(flutterIntent)

            if((screenOnTimeInMillis - screenOffTimeInMillis) == 0L) {
                // if alarm rings (no smart controls used)
                val log = mapOf(
                    "Did Alarm Ring" to "Yes",
                    "Alarm Type" to "Normal Alarm"
                )
                logdbHelper.insertLog("Alarm rings: ${getCurrentTime()}", log)
                return
            }

            val activityInterval = Math.abs(screenOnTimeInMillis - screenOffTimeInMillis)
            val log = mapOf(
                "Did Alarm Ring" to "Yes",
                "Alarm Type" to "Activity Based Alarm",
                "Activity Interval" to activityInterval.toString()
            )
            logdbHelper.insertLog("Alarm rings: ${getCurrentTime()}", log)
            return
        }

        val activityInterval = Math.abs(screenOnTimeInMillis - screenOffTimeInMillis)
        val log = mapOf(
            "Did Alarm Ring" to "No",
            "Alarm Type" to "Activity Based Alarm",
            "Activity Interval" to activityInterval.toString()
        )
        logdbHelper.insertLog("Alarm didn't ring: ${getCurrentTime()}", log)
    }

    private fun getCurrentTime(): String {
        val formatter = SimpleDateFormat("HH:mm", Locale.getDefault())
        return formatter.format(Date())
    }
}
