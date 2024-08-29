package com.ccextractor.ultimate_alarm_clock

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.tasks.await


class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) = runBlocking {
        if (context == null || intent == null) {
            return@runBlocking
        }


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
        val shareCheckIntent = Intent(context, ShareEnabledService::class.java)

        context.stopService(activityCheckIntent)
        context.stopService(shareCheckIntent)
        val isRemoved = sharedPreferences.getString("flutter.isRemoved", "")
        Log.d("id", "id $isRemoved")

        if ((Math.abs(screenOnTimeInMillis - screenOffTimeInMillis) < 180000 || screenOnTimeInMillis - screenOffTimeInMillis == 0L) && (isRemoved == "false")) {
            println("ANDROID STARTING APP")
            context.startActivity(flutterIntent)
        }
    }

}

