package com.ccextractor.ultimate_alarm_clock

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.PendingIntent
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.ccextractor.ultimate_alarm_clock.getLatestTimer


class BootReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "BootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (
            action != Intent.ACTION_BOOT_COMPLETED &&
            action != Intent.ACTION_USER_UNLOCKED &&
            action != Intent.ACTION_LOCKED_BOOT_COMPLETED
        ) {
            return
        }

        Log.i(TAG, "Handling action=$action")
        val allowLocalFallback = action != Intent.ACTION_LOCKED_BOOT_COMPLETED
        restoreAlarms(context, allowLocalFallback)
        if (action != Intent.ACTION_LOCKED_BOOT_COMPLETED) {
            restoreTimers(context)
        }
    }

    private fun restoreAlarms(context: Context, allowLocalFallback: Boolean) {
        val now = System.currentTimeMillis()
        val persistedAlarm = AlarmScheduleStore.load(context)
        val localAlarm = if (allowLocalFallback) restoreAlarmFromLocalState(context) else null

        val reconciledAlarm = BootRestorePlanner.chooseAlarmToRestore(
            persistedAlarm = persistedAlarm,
            localAlarm = localAlarm,
            nowMs = now,
            allowLocalFallback = allowLocalFallback
        )
        Log.i(
            TAG,
            "restoreAlarms allowLocalFallback=$allowLocalFallback persisted=${persistedAlarm?.triggerAtMs} local=${localAlarm?.triggerAtMs} reconciled=${reconciledAlarm?.triggerAtMs}"
        )
        if (reconciledAlarm != null) {
            AlarmScheduleStore.save(context, reconciledAlarm)
            AlarmScheduler.schedule(
                context,
                reconciledAlarm,
                allowCredentialEncryptedAccess = AlarmScheduleStore.canAccessCredentialEncryptedStorage(context)
            )
            Log.i(TAG, "Scheduled restored alarm at ${reconciledAlarm.triggerAtMs}")
        } else {
            AlarmScheduleStore.clear(context)
            Log.i(TAG, "No valid alarm found to restore")
        }
    }

    private fun restoreTimers(context: Context) {
        val timerdbhelper = TimerDatabaseHelper(context)
        val timerdb = timerdbhelper.readableDatabase
        val time = getLatestTimer(timerdb)
        timerdb.close()
        val notificationManager =
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
            commonTimer.startTimer(time.second)
            Log.i(TAG, "Restored timer for ${time.second} seconds")
        }
        else {
            Log.i(TAG, "No timer found to restore")
        }
    }

    private fun restoreAlarmFromLocalState(context: Context): ScheduledAlarmPayload? {
        val sharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val profile = sharedPreferences.getString("flutter.profile", "Default")
        val dbHelper = DatabaseHelper(context)
        val db = dbHelper.readableDatabase
        val cursor = db.rawQuery(
            """
            SELECT * FROM alarms
            WHERE isEnabled = 1
            AND (profile = ? OR ringOn = 1)
            """.trimIndent(),
            arrayOf(profile ?: "Default")
        )

        return try {
            var bestPayload: ScheduledAlarmPayload? = null
            val now = System.currentTimeMillis()
            while (cursor.moveToNext()) {
                val alarm = AlarmModel.fromCursor(cursor)
                val triggerAtMs = LocalAlarmScheduleResolver.nextTriggerAtMs(alarm, now) ?: continue
                val candidate = ScheduledAlarmPayload(
                    triggerAtMs = triggerAtMs,
                    activityMonitor = alarm.activityMonitor,
                    locationMonitor = alarm.isLocationEnabled,
                    location = alarm.location,
                    isWeather = alarm.isWeatherEnabled,
                    weatherTypes = alarm.weatherTypes
                )
                if (bestPayload == null || candidate.triggerAtMs < bestPayload.triggerAtMs) {
                    bestPayload = candidate
                }
            }
            bestPayload
        } finally {
            cursor.close()
            db.close()
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
