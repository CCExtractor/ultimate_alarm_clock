package com.ccextractor.ultimate_alarm_clock

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.database.Cursor
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
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
        const val CHANNEL3 = "system_ringtones"
        const val ACTION_START_FLUTTER_APP = "com.ccextractor.ultimate_alarm_clock"
        const val EXTRA_KEY = "alarmRing"
        const val ALARM_TYPE = "isAlarm"
        private var isAlarm: String? = "true"
        val alarmConfig = hashMapOf("shouldAlarmRing" to false, "alarmIgnore" to false)
        private var ringtone: Ringtone? = null
        private var systemRingtone: Ringtone? = null
        private var audioManager: AudioManager? = null
        private var audioFocusRequest: AudioFocusRequest? = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        var intentFilter = IntentFilter()
        intentFilter.addAction("com.ccextractor.ultimate_alarm_clock.START_TIMERNOTIF")
        intentFilter.addAction("com.ccextractor.ultimate_alarm_clock.STOP_TIMERNOTIF")
        context.registerReceiver(TimerNotification(), intentFilter, Context.RECEIVER_EXPORTED)
        
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        var methodChannel1 = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL1)
        var methodChannel2 = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2)
        var methodChannel3 = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL3)

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

        methodChannel3.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSystemRingtones" -> {
                    val category = call.argument<String>("category") ?: "alarm"
                    val ringtones = getSystemRingtones(category)
                    result.success(ringtones)
                }
                "playSystemRingtone" -> {
                    val ringtoneUri = call.argument<String>("ringtoneUri")
                    if (ringtoneUri != null) {
                        playSystemRingtone(ringtoneUri)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Ringtone URI is required", null)
                    }
                }
                "stopSystemRingtone" -> {
                    stopSystemRingtone()
                    result.success(null)
                }
                "testAudio" -> {
                    testAudioSetup()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
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

    private fun getSystemRingtones(category: String): List<Map<String, String>> {
        val ringtonesList = mutableListOf<Map<String, String>>()
        
        val ringtoneType = when (category.lowercase()) {
            "alarm" -> RingtoneManager.TYPE_ALARM
            "notification" -> RingtoneManager.TYPE_NOTIFICATION
            "ringtone" -> RingtoneManager.TYPE_RINGTONE
            else -> RingtoneManager.TYPE_ALARM
        }
        
        val ringtoneManager = RingtoneManager(this)
        ringtoneManager.setType(ringtoneType)
        
        val cursor: Cursor = ringtoneManager.cursor
        
        while (cursor.moveToNext()) {
            val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            val uri = ringtoneManager.getRingtoneUri(cursor.position)
            val id = cursor.getString(RingtoneManager.ID_COLUMN_INDEX)
            
            if (title != null && uri != null) {
                val ringtoneMap = mapOf(
                    "title" to title,
                    "uri" to uri.toString(),
                    "id" to (id ?: ""),
                    "category" to category
                )
                ringtonesList.add(ringtoneMap)
            }
        }
        
        cursor.close()
        return ringtonesList
    }
    
    private fun requestAudioFocus(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()
            
            audioFocusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                .setAudioAttributes(audioAttributes)
                .setAcceptsDelayedFocusGain(false)
                .setWillPauseWhenDucked(false)
                .build()
                
            audioManager?.requestAudioFocus(audioFocusRequest!!) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
        } else {
            @Suppress("DEPRECATION")
            audioManager?.requestAudioFocus(
                null,
                AudioManager.STREAM_ALARM,
                AudioManager.AUDIOFOCUS_GAIN_TRANSIENT
            ) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
        }
    }
    
    private fun abandonAudioFocus() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioFocusRequest?.let { audioManager?.abandonAudioFocusRequest(it) }
        } else {
            @Suppress("DEPRECATION")
            audioManager?.abandonAudioFocus(null)
        }
    }

    private fun playSystemRingtone(ringtoneUri: String) {
        try {
            stopSystemRingtone()
            
            
            if (!requestAudioFocus()) {
                Log.w("SystemRingtone", "Could not gain audio focus")
            }
            
            val uri = Uri.parse(ringtoneUri)
            systemRingtone = RingtoneManager.getRingtone(this, uri)
            
            if (systemRingtone == null) {
                Log.e("SystemRingtone", "Failed to create ringtone from URI: $ringtoneUri")
                playFallbackAlarm()
                return
            }
            
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
                systemRingtone?.audioAttributes = audioAttributes
                systemRingtone?.isLooping = true
            }
            
            
            val alarmVolume = audioManager?.getStreamVolume(AudioManager.STREAM_ALARM) ?: 0
            val maxAlarmVolume = audioManager?.getStreamMaxVolume(AudioManager.STREAM_ALARM) ?: 1
            
            if (alarmVolume == 0) {
                // Set to 50% of max volume if currently muted
                audioManager?.setStreamVolume(
                    AudioManager.STREAM_ALARM, 
                    maxAlarmVolume / 2, 
                    0
                )
                Log.i("SystemRingtone", "Alarm volume was muted, set to 50%")
            }
            
            Log.i("SystemRingtone", "Playing system ringtone: $ringtoneUri, Volume: $alarmVolume/$maxAlarmVolume")
            systemRingtone?.play()
            
        } catch (e: Exception) {
            Log.e("SystemRingtone", "Error playing system ringtone: ${e.message}")
            playFallbackAlarm()
        }
    }
    
    private fun playFallbackAlarm() {
        try {
            val defaultAlarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            systemRingtone = RingtoneManager.getRingtone(this, defaultAlarmUri)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
                systemRingtone?.audioAttributes = audioAttributes
                systemRingtone?.isLooping = true
            }
            
            systemRingtone?.play()
            Log.i("SystemRingtone", "Playing fallback default alarm")
        } catch (fallbackException: Exception) {
            Log.e("SystemRingtone", "Fallback alarm also failed: ${fallbackException.message}")
        }
    }
    
    private fun stopSystemRingtone() {
        try {
            systemRingtone?.stop()
            systemRingtone = null
            abandonAudioFocus()
            Log.i("SystemRingtone", "Stopped system ringtone and abandoned audio focus")
        } catch (e: Exception) {
            Log.e("SystemRingtone", "Error stopping system ringtone: ${e.message}")
        }
    }

    private fun testAudioSetup() {
        Log.i("SystemRingtone", "=== AUDIO DIAGNOSTICS ===")
        
        
        val am = audioManager
        if (am == null) {
            Log.e("SystemRingtone", "AudioManager is null!")
            return
        }
        
        // Check volumes
        val alarmVolume = am.getStreamVolume(AudioManager.STREAM_ALARM)
        val maxAlarmVolume = am.getStreamMaxVolume(AudioManager.STREAM_ALARM)
        val musicVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC)
        val maxMusicVolume = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val ringVolume = am.getStreamVolume(AudioManager.STREAM_RING)
        val maxRingVolume = am.getStreamMaxVolume(AudioManager.STREAM_RING)
        
        Log.i("SystemRingtone", "Alarm Volume: $alarmVolume/$maxAlarmVolume")
        Log.i("SystemRingtone", "Music Volume: $musicVolume/$maxMusicVolume")
        Log.i("SystemRingtone", "Ring Volume: $ringVolume/$maxRingVolume")
        
        
        val ringerMode = am.ringerMode
        val ringerModeText = when (ringerMode) {
            AudioManager.RINGER_MODE_SILENT -> "SILENT"
            AudioManager.RINGER_MODE_VIBRATE -> "VIBRATE"
            AudioManager.RINGER_MODE_NORMAL -> "NORMAL"
            else -> "UNKNOWN($ringerMode)"
        }
        Log.i("SystemRingtone", "Ringer Mode: $ringerModeText")
        
        
        try {
            val defaultAlarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            Log.i("SystemRingtone", "Default alarm URI: $defaultAlarmUri")
            
            val testRingtone = RingtoneManager.getRingtone(this, defaultAlarmUri)
            if (testRingtone != null) {
                Log.i("SystemRingtone", "Default alarm ringtone created successfully")
                
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    val audioAttributes = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                    testRingtone.audioAttributes = audioAttributes
                    Log.i("SystemRingtone", "Audio attributes set")
                }
                
                requestAudioFocus()
                testRingtone.play()
                Log.i("SystemRingtone", "Test alarm started")
                
                // Stop after 3 seconds
                android.os.Handler(mainLooper).postDelayed({
                    testRingtone.stop()
                    abandonAudioFocus()
                    Log.i("SystemRingtone", "Test alarm stopped")
                }, 3000)
                
            } else {
                Log.e("SystemRingtone", "Failed to create test ringtone")
            }
        } catch (e: Exception) {
            Log.e("SystemRingtone", "Test audio failed: ${e.message}")
        }
        
        Log.i("SystemRingtone", "=== END DIAGNOSTICS ===")
    }

}