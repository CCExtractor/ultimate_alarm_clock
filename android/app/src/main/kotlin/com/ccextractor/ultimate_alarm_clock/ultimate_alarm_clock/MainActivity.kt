package com.ccextractor.ultimate_alarm_clock

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Bundle
import android.os.SystemClock
import android.provider.Settings
import android.util.Log
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


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
        private var mediaPlayer: MediaPlayer? = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        var intentFilter = IntentFilter()
        intentFilter.addAction("com.ccextractor.ultimate_alarm_clock.START_TIMERNOTIF")
        intentFilter.addAction("com.ccextractor.ultimate_alarm_clock.STOP_TIMERNOTIF")
        context.registerReceiver(TimerNotification(), intentFilter, Context.RECEIVER_EXPORTED)
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
            } else if (call.method == "getSystemRingtones") {
                result.success(getSystemRingtones())
            } else if (call.method == "playSystemRingtone") {
                val ringtoneUri = call.argument<String>("uri")
                if (ringtoneUri != null) {
                    playSystemRingtone(ringtoneUri)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGUMENT", "Ringtone URI is required", null)
                }
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
        try {
            // Stop any existing sounds first
            stopDefaultAlarm()
            
            val alarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            println("Playing default alarm with URI: $alarmUri")
            
            mediaPlayer = MediaPlayer().apply {
                setDataSource(applicationContext, alarmUri)
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
                )
                isLooping = true
                prepare()
                start()
            }
            println("Successfully started default alarm")
        } catch (e: Exception) {
            println("Error playing default alarm: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun stopDefaultAlarm() {
        try {
            println("Stopping all sounds...")
            val playerToStop: MediaPlayer?
            val ringtoneToStop: Ringtone?
            
            synchronized(this) {
                playerToStop = mediaPlayer
                ringtoneToStop = ringtone
                
                // Nullify references first to prevent other operations from using them
                mediaPlayer = null
                ringtone = null
            }
            
            // Stop MediaPlayer if it exists
            playerToStop?.let {
                try {
                    if (it.isPlaying) {
                        try {
                            it.stop()
                        } catch (e: Exception) {
                            println("Error stopping media player: ${e.message}")
                        }
                    }
                    try {
                        it.reset()
                        it.release()
                    } catch (e: Exception) {
                        println("Error releasing media player: ${e.message}")
                    }
                } catch (e: Exception) {
                    println("General error with media player: ${e.message}")
                    try {
                        it.release()
                    } catch (e2: Exception) {
                        // Ignore secondary errors
                    }
                }
            }
            
            // Also stop Ringtone if it exists
            ringtoneToStop?.let {
                try {
                    it.stop()
                } catch (e: Exception) {
                    println("Error stopping ringtone: ${e.message}")
                }
            }
            
            println("Successfully stopped all sounds")
        } catch (e: Exception) {
            println("Error stopping sounds: ${e.message}")
            // In case of error, ensure references are nullified
            synchronized(this) {
                mediaPlayer = null
                ringtone = null
            }
        }
    }

    private fun getSystemRingtones(): List<Map<String, String>> {
        val ringtones = mutableListOf<Map<String, String>>()
        
        try {
            println("Getting system ringtones...")
            
            // Get alarm tones
            println("Fetching alarm tones...")
            addRingtonesToList(ringtones, RingtoneManager.TYPE_ALARM, "alarm")
            
            // Get notification tones
            println("Fetching notification tones...")
            addRingtonesToList(ringtones, RingtoneManager.TYPE_NOTIFICATION, "notification")
            
            // Get ringtones
            println("Fetching ringtones...")
            addRingtonesToList(ringtones, RingtoneManager.TYPE_RINGTONE, "ringtone")
            
            println("Total ringtones found: ${ringtones.size}")
            ringtones.forEach { 
                println("Found ringtone: ${it["title"]}, URI: ${it["uri"]}")
            }
            
            return ringtones
        } catch (e: Exception) {
            println("Error getting system ringtones: ${e.message}")
            e.printStackTrace()
            return emptyList()
        }
    }
    
    private fun addRingtonesToList(ringtones: MutableList<Map<String, String>>, type: Int, category: String) {
        try {
            val manager = RingtoneManager(this)
            manager.setType(type)
            val cursor = manager.cursor
            
            println("Found ${cursor?.count ?: 0} ${category} tones")
            
            while (cursor != null && cursor.moveToNext()) {
                try {
                    val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
                    val uri = manager.getRingtoneUri(cursor.position).toString()
                    
                    println("Adding $category ringtone: $title with URI: $uri")
                    
                    ringtones.add(mapOf(
                        "title" to title,
                        "uri" to uri,
                        "category" to category
                    ))
                } catch (e: Exception) {
                    println("Error processing ringtone at cursor position ${cursor.position}: ${e.message}")
                }
            }
        } catch (e: Exception) {
            println("Error getting $category tones: ${e.message}")
            e.printStackTrace()
        }
    }
    
    private fun playSystemRingtone(uriString: String) {
        try {
            println("Stopping any existing sounds first")
            // Stop any currently playing sound first and wait for it to complete
            stopDefaultAlarm()
            
            // Give more time for resources to be released, especially important between consecutive plays
            Thread.sleep(150)
            
            println("Attempting to play system ringtone: $uriString")
            
            // Create and prepare a MediaPlayer with a unique ID to track
            val uri = Uri.parse(uriString)
            val newMediaPlayer = MediaPlayer()
            
            // Set the new media player as the current one
            synchronized(this) {
                // Release any existing player that might be in-between states
                mediaPlayer?.release()
                mediaPlayer = newMediaPlayer
            }
            
            try {
                newMediaPlayer.apply {
                    setDataSource(applicationContext, uri)
                    setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                            .build()
                    )
                    isLooping = true
                    
                    // Use async prepare to avoid blocking the main thread
                    setOnPreparedListener {
                        try {
                            synchronized(this@MainActivity) {
                                // Check if this media player is still the current one
                                if (mediaPlayer == this) {
                                    start()
                                    println("Successfully started system ringtone playback")
                                } else {
                                    // This media player was replaced, release it
                                    println("Media player was replaced before playback could start")
                                    release()
                                }
                            }
                        } catch (e: Exception) {
                            println("Error starting playback after prepare: ${e.message}")
                            release()
                            playDefaultAlarmAsFallback()
                        }
                    }
                    
                    setOnErrorListener { mp, what, extra ->
                        println("Media player error: what=$what, extra=$extra")
                        mp.release()
                        synchronized(this@MainActivity) {
                            if (mediaPlayer == mp) {
                                mediaPlayer = null
                                playDefaultAlarmAsFallback()
                            }
                        }
                        true
                    }
                    
                    prepareAsync()
                }
            } catch (e: Exception) {
                println("Error setting up media player: ${e.message}")
                newMediaPlayer.release()
                synchronized(this) {
                    if (mediaPlayer == newMediaPlayer) {
                        mediaPlayer = null
                    }
                }
                playDefaultAlarmAsFallback()
            }
        } catch (e: Exception) {
            println("Error playing system ringtone: ${e.message}")
            e.printStackTrace()
            synchronized(this) {
                mediaPlayer?.release()
                mediaPlayer = null
            }
            playDefaultAlarmAsFallback()
        }
    }

    private fun playDefaultAlarmAsFallback() {
        // Try to play default alarm sound as fallback
        try {
            println("Playing default alarm as fallback")
            val defaultUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            
            // Stop any existing media player first
            mediaPlayer?.release()
            
            mediaPlayer = MediaPlayer().apply {
                setDataSource(applicationContext, defaultUri)
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
                )
                isLooping = true
                prepare()
                start()
            }
        } catch (e2: Exception) {
            println("Failed to play default alarm: ${e2.message}")
        }
    }

    private fun openAndroidPermissionsMenu() {
        val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
        intent.data = Uri.parse("package:${packageName}")
        startActivity(intent)
    }
}