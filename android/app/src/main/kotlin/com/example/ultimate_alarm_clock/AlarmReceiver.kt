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
        
        if (context != null) {
            val flutterIntent = Intent(context, MainActivity::class.java)
            flutterIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
           flutterIntent.putExtra("initialRoute", "/alarm-ring")
            context.startActivity(flutterIntent)

        }

}
}
