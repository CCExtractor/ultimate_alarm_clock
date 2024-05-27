package com.example.ultimate_alarm_clock.TimerBroadcasts

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.example.ultimate_alarm_clock.CommonTimerManager
import com.example.ultimate_alarm_clock.TimerListener

class CancelTimer : BroadcastReceiver()  {
    override fun onReceive(context: Context, intent: Intent?) {
        var notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val commonTimer = CommonTimerManager.getCommonTimer(object : TimerListener {
            override fun onTick(millisUntilFinished: Long) {
            }
            override fun onFinish() {
                notificationManager.cancel(1)
            }
        })
        commonTimer.stopTimer()
    }
}