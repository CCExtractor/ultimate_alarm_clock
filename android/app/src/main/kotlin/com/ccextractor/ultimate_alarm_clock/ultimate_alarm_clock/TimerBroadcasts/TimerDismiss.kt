package com.ccextractor.ultimate_alarm_clock.ultimate_alarm_clock.TimerBroadcasts


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.ccextractor.ultimate_alarm_clock.MainActivity


class TimerDismiss: BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val timerID: Int = intent.getIntExtra("timerID", 0)
        val args = hashMapOf("timerID" to timerID)
        MainActivity.methodChannel2.invokeMethod("dismissTimer", args)
    }
}