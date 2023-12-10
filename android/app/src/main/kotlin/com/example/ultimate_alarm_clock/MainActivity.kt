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
        const val ACTION_START_FLUTTER_APP = "com.example.ultimate_alarm_clock"
const val EXTRA_KEY = "alarmRing"
val alarmConfig = hashMapOf("shouldAlarmRing" to false, "alarmIgnore" to false)
    }



    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        var  methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        val intent = intent
        if (intent != null && intent.hasExtra(EXTRA_KEY)) {
            val receivedData = intent.getStringExtra(EXTRA_KEY)
            alarmConfig["shouldAlarmRing"] = true
            val cleanIntent = Intent(intent)
            cleanIntent.removeExtra(EXTRA_KEY)
            setIntent(cleanIntent)
            println("NATIVE SAID OK")
        } else {
            println("NATIVE SAID NO")
        }
        methodChannel.invokeMethod("appStartup", alarmConfig)
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "scheduleAlarm") {
                val seconds = call.argument<Int>("milliSeconds")
               println("FLUTTER CALLED SCHEDULE")
                scheduleAlarm(seconds ?: 0)
                result.success(null)
            } else if (call.method == "cancelAllScheduledAlarms") {
               println("FLUTTER CALLED CANCEL ALARMS")
               cancelAllScheduledAlarms()
                result.success(null)
            }else if(call.method == "bringAppToForeground"){
                bringAppToForeground(this)
                result.success(null)
            }else if (call.method == "minimizeApp" ){
                minimizeApp()
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


    private fun minimizeApp() {
        moveTaskToBack(true)
    }


private fun scheduleAlarm(milliSeconds: Int) {
    val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val intent = Intent(this, AlarmReceiver::class.java)
    val pendingIntent = PendingIntent.getBroadcast(
        this,
        0,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
    )

    // Schedule the alarm
    val triggerTime = SystemClock.elapsedRealtime() + milliSeconds
    alarmManager.setExact(AlarmManager.ELAPSED_REALTIME_WAKEUP, triggerTime, pendingIntent)
}

private fun cancelAllScheduledAlarms() {
    val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val intent = Intent(this, AlarmReceiver::class.java)
    val pendingIntent = PendingIntent.getBroadcast(
        this,
        0,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
    )

    // Cancel any existing alarms by providing the same pending intent
    alarmManager.cancel(pendingIntent)
    pendingIntent.cancel()
}


}
