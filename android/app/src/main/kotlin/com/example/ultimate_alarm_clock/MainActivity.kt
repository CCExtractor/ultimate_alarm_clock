package com.example.ultimate_alarm_clock

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.app.ActivityManager
import android.widget.Toast
import android.os.PowerManager
import android.util.Log
import android.view.WindowManager

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL = "ulticlock"
        const val ACTION_START_FLUTTER_APP = "com.example.START_FLUTTER_APP"

    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
    }







    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
GeneratedPluginRegistrant.registerWith(flutterEngine)
      var  methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "scheduleAlarm") {
                val seconds = call.argument<Int>("seconds")

               println("MARKIS CALLED SCHEDULE")
                scheduleAlarm(seconds ?: 0)
                result.success(null)
            } else if(call.method == "bringAppToForeground"){
                bringAppToForeground(this)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

        fun bringAppToForeground(context: Context) {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager?
            val appTasks = activityManager?.appTasks
            appTasks?.forEach { task ->
                if (task.taskInfo.baseIntent.component?.packageName == context.packageName) {
                    task.moveToFront()
                    return@forEach
                }
            }
        }


private fun scheduleAlarm(seconds: Int) {
    val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val intent = Intent(this, AlarmReceiver::class.java)
    val pendingIntent = PendingIntent.getBroadcast(
        this,
        0,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
    )

    // Schedule the alarm
    val triggerTime = SystemClock.elapsedRealtime() + seconds * 1000
    alarmManager.setExact(AlarmManager.ELAPSED_REALTIME_WAKEUP, triggerTime, pendingIntent)
}

}
