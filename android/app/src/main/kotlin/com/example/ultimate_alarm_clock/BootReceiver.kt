package com.example.ultimate_alarm_clock

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.SystemClock

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "android.intent.action.BOOT_COMPLETED") {
            // Open the database
            val dbHelper = DatabaseHelper(context)
            val db = dbHelper.readableDatabase

            // Get the latest alarm
            val alarm = getLatestAlarm(db, true)

            // Close the database
            db.close()

            // Schedule the alarm
            if (alarm != null) {
                scheduleTimer(alarm.minutesSinceMidnight * 60 * 1000, context)
            }
        }
    }
    fun scheduleTimer(milliSeconds: Int, context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, TimerReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            1,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )

        // Schedule the alarm
        val triggerTime = SystemClock.elapsedRealtime() + milliSeconds
        alarmManager.setExact(AlarmManager.ELAPSED_REALTIME_WAKEUP, triggerTime, pendingIntent)
    }
}
