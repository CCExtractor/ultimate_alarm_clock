package com.example.ultimate_alarm_clock

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle


class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) {
            return
        }


        val flutterIntent = Intent(context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)

            if (intent.action == Intent.ACTION_BOOT_COMPLETED)
            {
                putExtra("initialRoute", "/")
                putExtra("alarmRing", null as String?)
                putExtra("isAlarm",null as String?)
                putExtra("isBoot",true)
            }
            else
            {

                    putExtra("initialRoute", "/")
                    putExtra("alarmRing", "true")
                    putExtra("isAlarm","true")
                    putExtra("isBoot",false)


            }

        }

        println("ANDROID STARTING APP")
        context.startActivity(flutterIntent)
    }
}
