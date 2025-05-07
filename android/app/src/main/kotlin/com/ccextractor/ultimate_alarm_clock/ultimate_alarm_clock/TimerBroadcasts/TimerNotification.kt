package com.ccextractor.ultimate_alarm_clock
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat


class TimerNotification : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val timerdbhelper = TimerDatabaseHelper(context)
        val timerdb = timerdbhelper.readableDatabase
        val time = getLatestTimer(timerdb)
        timerdb.close()
        var notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val commonTimer = CommonTimerManager.getCommonTimer(object : TimerListener {
            override fun onTick(millisUntilFinished: Long) {
                showTimerNotification(millisUntilFinished, "Timer", context)
            }

            override fun onFinish() {
                notificationManager.cancel(1)
            }
        })

        if (intent.action == "com.ccextractor.ultimate_alarm_clock.DISMISS_TIMER"){
            val timerID: Int = intent.getIntExtra("timerID", 0)
            val args = hashMapOf("timerID" to timerID)
            MainActivity.methodChannel2.invokeMethod("dismissTimer", args)
            notificationManager.cancel(2)
        }

        if (intent.action == "com.ccextractor.ultimate_alarm_clock.START_TIMERNOTIF" || intent.action == Intent.ACTION_BOOT_COMPLETED) {
            createNotificationChannel(context)



            if (time != null) {

                // Start or stop the timer based on your requirements
                commonTimer.startTimer(time.second)

            }

        }
        if (intent.action == "com.ccextractor.ultimate_alarm_clock.STOP_TIMERNOTIF") {

            commonTimer.stopTimer()

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

    fun showDismissNotification(milliseconds: Int, timerID: Int, context: Context) {
        var notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val dismissIntent = Intent(context, TimerNotification::class.java).apply {
            action = "com.ccextractor.ultimate_alarm_clock.DISMISS_TIMER"
            putExtra("timerID", timerID)
        }
        val dismissPendingIntent = PendingIntent.getBroadcast(
            context, System.currentTimeMillis().toInt(), dismissIntent,
            PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, TimerService.TIMER_CHANNEL_ID)
            .setSmallIcon(R.mipmap.launcher_icon)
            .setContentTitle("Dismiss Timer")
            .setContentText(formatDuration(milliseconds.toLong()))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setOnlyAlertOnce(true)
            .addAction(R.mipmap.launcher_icon, "Dismiss", dismissPendingIntent)
            .build()
        notificationManager.notify(2, notification)
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