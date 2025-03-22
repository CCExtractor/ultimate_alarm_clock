package com.ccextractor.ultimate_alarm_clock

import android.content.BroadcastReceiver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale


class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) {
            return
        }

        val dbHelper = HistoryDbHelper(context)
        val historyDb: SQLiteDatabase = dbHelper.writableDatabase

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
                val values = ContentValues().apply {
                    put("didAlarmRing", 1)
                    put("alarmTime", getCurrentTime())
                }
                historyDb.insert("alarmHistory", null, values)
                historyDb.close()
                return
            }

            // if alarm rings and Screen Activity is turned on
            val values = ContentValues().apply {
                put("didAlarmRing", 1)
                put("alarmTime", getCurrentTime())
                put("reason", "activity")
                put("activityInterval", Math.abs(screenOnTimeInMillis - screenOffTimeInMillis))
            }
            historyDb.insert("alarmHistory", null, values)
            historyDb.close()
            return
        }

        // alarm did not ring because screen activity was more than specified.
        val values = ContentValues().apply {
            put("didAlarmRing", 0)
            put("alarmTime", getCurrentTime())
            put("reason", "activity")
            put("activityInterval", Math.abs(screenOnTimeInMillis - screenOffTimeInMillis))
        }
        historyDb.insert("alarmHistory", null, values)
        historyDb.close()
    }

    private fun getCurrentTime(): String {
        val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
        return formatter.format(Date())
    }

}

