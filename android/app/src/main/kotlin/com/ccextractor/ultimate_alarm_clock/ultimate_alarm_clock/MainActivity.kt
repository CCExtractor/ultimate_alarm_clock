package com.ccextractor.ultimate_alarm_clock

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.RemoteViews
import java.sql.Time
import java.util.Calendar
import java.util.Date
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    companion object {
        const val CHANNEL1 = "ulticlock"
        const val CHANNEL2 = "timer"
        const val ACTION_START_FLUTTER_APP = "com.ccextractor.ultimate_alarm_clock"
        const val EXTRA_KEY = "alarmRing"
        const val ALARM_TYPE = "isAlarm"
        private var isAlarm: String? = "true"
        val alarmConfig = hashMapOf("shouldAlarmRing" to false, "alarmIgnore" to false)
        private var ringtone: Ringtone? = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        var intentFilter = IntentFilter()
        intentFilter.addAction("com.ccextractor.ultimate_alarm_clock.START_TIMERNOTIF")
        intentFilter.addAction("com.ccextractor.ultimate_alarm_clock.STOP_TIMERNOTIF")
        context.registerReceiver(TimerNotification(), intentFilter, Context.RECEIVER_EXPORTED)
        // Start periodic updates of rings_in
        handler.post(updateWidgetRunnable)
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        var methodChannel1 = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL1)
        var methodChannel2 = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2)

        val intent = intent

        if (intent != null && intent.hasExtra(EXTRA_KEY)) {
            val receivedData = intent.getStringExtra(EXTRA_KEY)
            if (receivedData == "true") {
                alarmConfig["shouldAlarmRing"] = true
            }
            isAlarm = intent.getStringExtra(ALARM_TYPE)
            val cleanIntent = Intent(intent)
            cleanIntent.removeExtra(EXTRA_KEY)
            setIntent(cleanIntent)
            println("NATIVE SAID OK")
        } else {
            println("NATIVE SAID NO")
        }

        if (isAlarm == "true") {
            val cleanIntent = Intent(intent)
            cleanIntent.removeExtra(EXTRA_KEY)
            methodChannel1.invokeMethod("appStartup", alarmConfig)
            alarmConfig["shouldAlarmRing"] = false
        }
        methodChannel2.setMethodCallHandler { call, result ->
            if (call.method == "playDefaultAlarm") {
                playDefaultAlarm(this)
                result.success(null)
            } else if (call.method == "stopDefaultAlarm") {
                stopDefaultAlarm()
                result.success(null)
            } else if (call.method == "runtimerNotif") {
                val startTimerIntent =
                    Intent("com.ccextractor.ultimate_alarm_clock.START_TIMERNOTIF")
                context.sendBroadcast(startTimerIntent)

            } else if (call.method == "clearTimerNotif") {
                val stopTimerIntent = Intent("com.ccextractor.ultimate_alarm_clock.STOP_TIMERNOTIF")
                context.sendBroadcast(stopTimerIntent)
                var notificationManager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.cancel(1)
            } else {
                result.notImplemented()
            }
        }
        methodChannel1.setMethodCallHandler { call, result ->
            if (call.method == "scheduleAlarm") {
                println("FLUTTER CALLED SCHEDULE")
                val dbHelper = DatabaseHelper(context)
                val db = dbHelper.readableDatabase
                val sharedPreferences =
                    context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                val profile = sharedPreferences.getString("flutter.profile", "Default")
                val ringTime = getLatestAlarm(db, true, profile ?: "Default", context)
                Log.d("yay yay", "yay ${ringTime ?: "null"}")
                if (ringTime != null) {
                    android.util.Log.d("yay", "yay ${ringTime["interval"]}")
                    Log.d("yay", "yay ${ringTime["isLocation"]}")
                    scheduleAlarm(
                        ringTime["interval"]!! as Long,
                        ringTime["isActivity"]!! as Int,
                        ringTime["isLocation"]!! as Int,
                        ringTime["location"]!! as String,
                        ringTime["isWeather"]!! as Int,
                        ringTime["weatherTypes"]!! as String
                    )
                } else {
                    println("FLUTTER CALLED CANCEL ALARMS")
                    cancelAllScheduledAlarms()
                }
                result.success(null)
            } else if (call.method == "cancelAllScheduledAlarms") {
                println("FLUTTER CALLED CANCEL ALARMS")
                cancelAllScheduledAlarms()
                result.success(null)
            } else if (call.method == "bringAppToForeground") {
                bringAppToForeground(this)
                result.success(null)
            } else if (call.method == "minimizeApp") {
                minimizeApp()
                result.success(null)
            } else if (call.method == "playDefaultAlarm") {
                playDefaultAlarm(this)
                result.success(null)
            } else if (call.method == "stopDefaultAlarm") {
                stopDefaultAlarm()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter/platform").setMethodCallHandler { call, result ->
            if (call.method == "getInitialRoute") {
                val initialRoute = intent.getStringExtra("initialRoute")
                result.success(mapOf("initialRoute" to initialRoute))
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


    @SuppressLint("ScheduleExactAlarm")
    private fun scheduleAlarm(
        milliSeconds: Long,
        activityMonitor: Int,
        locationMonitor: Int,
        setLocation: String,
        isWeather: Int,
        weatherTypes: String
    ) {

        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        val activityCheckIntent = Intent(this, ScreenMonitorService::class.java)
        val pendingActivityCheckIntent = PendingIntent.getService(
            this,
            4,
            activityCheckIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        // Schedule the alarm
        val tenMinutesInMilliseconds = 600000L
        val preTriggerTime =
            System.currentTimeMillis() + (milliSeconds - tenMinutesInMilliseconds)
        val triggerTime = System.currentTimeMillis() + milliSeconds
        if (activityMonitor == 1) {
            val alarmClockInfo = AlarmManager.AlarmClockInfo(preTriggerTime, pendingIntent)
            alarmManager.setAlarmClock(
                alarmClockInfo,
                pendingActivityCheckIntent
            )
        } else {
            val sharedPreferences =
                getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            editor.putLong("flutter.is_screen_off", 0L)
            editor.apply()
            editor.putLong("flutter.is_screen_on", 0L)
            editor.apply()
        }
        if (locationMonitor == 1) {
            val sharedPreferences =
                getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            editor.putString("flutter.set_location", setLocation)
            Log.d("location", setLocation)
            editor.apply()
            editor.putInt("flutter.is_location_on", 1)
            editor.apply()
            val locationAlarmIntent = Intent(this, LocationFetcherService::class.java)
            val pendingLocationAlarmIntent = PendingIntent.getService(
                this,
                5,
                locationAlarmIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerTime - 10000, pendingIntent)
            alarmManager.setAlarmClock(
                alarmClockInfo,
                pendingLocationAlarmIntent
            )
        } else if (isWeather == 1) {
            val sharedPreferences =
                getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            editor.putString("flutter.weatherTypes", getWeatherConditions(weatherTypes))
            Log.d("we", getWeatherConditions(weatherTypes))
            editor.apply()
            val weatherAlarmIntent = Intent(this, WeatherFetcherService::class.java)
            val pendingWeatherAlarmIntent = PendingIntent.getService(
                this,
                6,
                weatherAlarmIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerTime - 10000, pendingIntent)
            alarmManager.setAlarmClock(
                alarmClockInfo,
                pendingWeatherAlarmIntent
            )
        } else {
            val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerTime, pendingIntent)
            alarmManager.setAlarmClock(alarmClockInfo, pendingIntent)
        }

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

        val activityCheckIntent = Intent(this, ScreenMonitorService::class.java)
        val pendingActivityCheckIntent = PendingIntent.getService(
            this,
            4,
            activityCheckIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )

        // Cancel any existing alarms by providing the same pending intent
        alarmManager.cancel(pendingIntent)
        pendingIntent.cancel()
        alarmManager.cancel(pendingActivityCheckIntent)
        pendingActivityCheckIntent.cancel()

    }

    private fun playDefaultAlarm(context: Context) {
        val alarmUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
        ringtone = RingtoneManager.getRingtone(context, alarmUri)
        ringtone?.play()
    }

    private fun stopDefaultAlarm() {
        ringtone?.stop()
    }

    private fun openAndroidPermissionsMenu() {
        val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
        intent.data = Uri.parse("package:${packageName}")
        startActivity(intent)
    }

    // Update the rings_in home_widget in a loop of 1 minute
    private val handler = Handler(Looper.getMainLooper())
    private val updateInterval: Long = 60000

    private val updateWidgetRunnable = object : Runnable {
        override fun run() {
            val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
            val componentName = ComponentName(applicationContext, NextAlarmHomeWidget::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

            for (appWidgetId in appWidgetIds) {
                val views = RemoteViews(packageName, R.layout.next_alarm_home_widget)
                val alarmTime = getAlarmTimeText()
                if (alarmTime != "No upcoming alarms!") {
                    views.setViewVisibility(R.id.repeat_days, View.VISIBLE)
                    views.setTextViewText(R.id.rings_in, alarmTime)
                } else {
                    views.setViewVisibility(R.id.repeat_days, View.GONE)
                    views.setTextViewText(R.id.alarm_date_n_time, "No upcoming alarms!")
                    views.setTextViewText(R.id.rings_in, "")
                }
                appWidgetManager.updateAppWidget(appWidgetId, views)
            }

            handler.postDelayed(this, updateInterval)
        }
    }

    private fun getAlarmTimeText(): String {
        val dbHelper = DatabaseHelper(applicationContext)
        val db = dbHelper.readableDatabase
        val sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val profile = sharedPreferences.getString("flutter.profile", "Default") ?: "Default"
        val latestAlarm = getLatestAlarm(db, true, profile, applicationContext)

        return if (latestAlarm != null) {
            val alarmTime = latestAlarm["alarmTime"] as? String ?: ""
            val days = latestAlarm["days"] as? String ?: ""
            val alarmDate = latestAlarm["alarmDate"] as? String ?: ""

            if (alarmTime.isEmpty() || days.isEmpty() || alarmDate.isEmpty()) {
                return "No upcoming alarms!"
            }
            return "Rings in " + timeUntilAlarm(stringToTime(alarmTime), days.map { it == '1' }, stringToDate(alarmDate))
        } else {
            "No upcoming alarms!"
        }
    }

    private fun timeUntilAlarm(alarmTime: Time, days: List<Boolean>, alarmDate: Date): String {
        val now = Calendar.getInstance()

        val todayAlarm = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, alarmTime.hours)
            set(Calendar.MINUTE, alarmTime.minutes)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }

        var durationMillis: Long

        // If the alarm is for a specific future date
        if (alarmDate.after(now.time)) {
            val specificDateAlarm = Calendar.getInstance().apply {
                time = alarmDate
                set(Calendar.HOUR_OF_DAY, alarmTime.hours)
                set(Calendar.MINUTE, alarmTime.minutes)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }
            durationMillis = specificDateAlarm.timeInMillis - now.timeInMillis
            return formatInterval(durationMillis)
        }

        // One-time alarm (no repeat days)
        if (days.all { !it }) {
            durationMillis = if (now.before(todayAlarm)) {
                todayAlarm.timeInMillis - now.timeInMillis
            } else {
                val nextAlarm = todayAlarm
                nextAlarm.add(Calendar.DAY_OF_YEAR, 1)
                nextAlarm.timeInMillis - now.timeInMillis
            }
        } else if (now.before(todayAlarm) && days[now.get(Calendar.DAY_OF_WEEK) - 1]) {
            durationMillis = todayAlarm.timeInMillis - now.timeInMillis
        } else {
            // var daysUntilNextAlarm = 7
            var nextAlarm: Calendar? = null

            for (i in 1..7) {
                val nextDayIndex = (now.get(Calendar.DAY_OF_WEEK) + i - 1) % 7;
                if (days[nextDayIndex]) {
                    // daysUntilNextAlarm = i;
                    nextAlarm = Calendar.getInstance().apply {
                        add(Calendar.DAY_OF_YEAR, i)
                        set(Calendar.HOUR_OF_DAY, alarmTime.hours)
                        set(Calendar.MINUTE, alarmTime.minutes)
                        set(Calendar.SECOND, 0)
                        set(Calendar.MILLISECOND, 0)
                    }
                    break
                }
            }

            if (nextAlarm != null) {
                durationMillis = nextAlarm.timeInMillis - now.timeInMillis;
            } else {
                return "No upcoming alarms"
            }
        }
        return formatInterval(durationMillis)
    }

    private fun formatInterval(durationMillis: Long): String {
        val minutes = TimeUnit.MILLISECONDS.toMinutes(durationMillis)
        val hours = TimeUnit.MILLISECONDS.toHours(durationMillis)
        val days = TimeUnit.MILLISECONDS.toDays(durationMillis)

        return when {
            minutes < 1 -> "less than 1 minute"
            hours < 24 -> {
                val remainingMinutes = minutes % 60
                when {
                    hours == 0L -> "$remainingMinutes minute${if (remainingMinutes == 1L) "" else "s"}"
                    remainingMinutes == 0L -> "$hours hour${if (hours == 1L) "" else "s"}"
                    else -> "$hours hour${if (hours == 1L) "" else "s"} $remainingMinutes minute${if (remainingMinutes == 1L) "" else "s"}"
                }
            }
            days == 1L -> "1 day"
            else -> "$days days"
        }
    }

    private fun stringToDate(date: String): Date {
        val parts = date.split("-")
        val year = parts[0].trim().toInt() - 1900
        val month = parts[1].trim().toInt() - 1
        val day = parts[2].trim().toInt()
        return Date(year, month, day)
    }

    private fun stringToTime(time: String): Time {
        val parts = time.split(':')
        val hour = parts[0].toInt()
        val minute = parts[1].toInt()
        return Time(hour, minute, 0);
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(updateWidgetRunnable)
    }
}