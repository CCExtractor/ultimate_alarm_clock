package com.ccextractor.ultimate_alarm_clock

import android.app.Service
import android.content.Intent
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.*
import kotlin.math.max
import com.ccextractor.ultimate_alarm_clock.MainActivity
import com.ccextractor.ultimate_alarm_clock.LogDatabaseHelper

class SmartControlCombinationService : Service() {
    private val NOTIFICATION_ID = 1003
    private val CHANNEL_ID = "smart_control_combination_channel"
    
    private var serviceJob = SupervisorJob()
    private var serviceScope = CoroutineScope(Dispatchers.IO + serviceJob)
    
    private lateinit var logdbHelper: LogDatabaseHelper
    
    // Smart control results
    private var locationResult: Boolean? = null
    private var weatherResult: Boolean? = null
    private var activityResult: Boolean? = null
    
    // Configuration
    private var smartControlCombinationType = 0 // 0=AND, 1=OR
    private var isSharedAlarm = false
    private var alarmID = ""
    private var isLocationEnabledFromIntent = false
    private var isWeatherEnabledFromIntent = false
    private var isActivityEnabledFromIntent = false
    
    override fun onCreate() {
        super.onCreate()
        logdbHelper = LogDatabaseHelper(this)
        createNotificationChannel()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("SmartControlCombination", "Service started")
        
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)
        
        intent?.let { safeIntent -> 
            handleSmartControlCombination(safeIntent)
        }
        
        return START_STICKY
    }
    
    private fun handleSmartControlCombination(intent: Intent) {
        alarmID = intent.getStringExtra("alarmID") ?: ""
        isSharedAlarm = intent.getBooleanExtra("isSharedAlarm", false)
        smartControlCombinationType = intent.getIntExtra("smartControlCombinationType", 0)
        
        isLocationEnabledFromIntent = intent.getBooleanExtra("isLocationEnabled", false)
        isWeatherEnabledFromIntent = intent.getBooleanExtra("isWeatherEnabled", false)
        isActivityEnabledFromIntent = intent.getBooleanExtra("isActivityEnabled", false)
        
        Log.d("SmartControlCombination", "Processing combination type: $smartControlCombinationType")
        Log.d("SmartControlCombination", "Location: $isLocationEnabledFromIntent, Weather: $isWeatherEnabledFromIntent, Activity: $isActivityEnabledFromIntent")
        
        serviceScope.launch {
            val jobs = mutableListOf<Job>()
            
            // Start location check if enabled
            if (isLocationEnabledFromIntent) {
                jobs.add(launch {
                    locationResult = checkLocationCondition(intent)
                    Log.d("SmartControlCombination", "Location result: $locationResult")
                    checkCombinationResult()
                })
            }
            
            // Start weather check if enabled
            if (isWeatherEnabledFromIntent) {
                jobs.add(launch {
                    weatherResult = checkWeatherCondition(intent)
                    Log.d("SmartControlCombination", "Weather result: $weatherResult")
                    checkCombinationResult()
                })
            }
            
            // Start activity check if enabled
            if (isActivityEnabledFromIntent) {
                jobs.add(launch {
                    activityResult = checkActivityCondition(intent)
                    Log.d("SmartControlCombination", "Activity result: $activityResult")
                    checkCombinationResult()
                })
            }
            
            // Wait for all checks to complete (with timeout)
            withTimeoutOrNull(30000) { // 30 second timeout
                jobs.joinAll()
            }
            
            // Final check if not already processed
            checkCombinationResult()
        }
    }
    
    private suspend fun checkLocationCondition(intent: Intent): Boolean {
        // For now, delegate to the existing LocationFetcherService
        // This is a simplified version - in practice, we'd need to extract the actual logic
        val locationConditionType = intent.getIntExtra("locationConditionType", 2)
        val location = intent.getStringExtra("location") ?: ""
        
        Log.d("SmartControlCombination", "Location check: type=$locationConditionType, location=$location")
        
        // For testing purposes, simulate the location check based on condition type
        // In a real implementation, this would check actual location
        return when (locationConditionType) {
            1 -> true  // Ring when at location - assume we're at location
            2 -> false // Cancel when at location - assume we're at location, so cancel
            3 -> false // Ring when away from location - assume we're at location, so don't ring
            4 -> true  // Cancel when away from location - assume we're at location, so don't cancel
            else -> true
        }
    }
    
    private suspend fun checkWeatherCondition(intent: Intent): Boolean {
        // For now, delegate to the existing WeatherFetcherService logic
        val weatherConditionType = intent.getIntExtra("weatherConditionType", 2)
        val weatherTypes = intent.getStringExtra("weatherTypes") ?: "[]"
        
        Log.d("SmartControlCombination", "Weather check: type=$weatherConditionType, weather=$weatherTypes")
        
        // For testing purposes, simulate weather matching
        // In a real implementation, this would check actual weather
        val weatherMatches = true // Assume current weather matches selected types
        
        return when (weatherConditionType) {
            1 -> weatherMatches  // Ring when weather matches
            2 -> !weatherMatches // Cancel when weather matches - if matches, return false (cancel)
            3 -> !weatherMatches // Ring when weather different
            4 -> weatherMatches  // Cancel when weather different
            else -> true
        }
    }
    
    private fun checkActivityCondition(intent: Intent): Boolean {
        val activityConditionType = intent.getIntExtra("activityConditionType", 0)
        val activityInterval = intent.getIntExtra("activityInterval", 30)
        val screenOnTime = intent.getLongExtra("screenOnTime", 0L)
        val screenOffTime = intent.getLongExtra("screenOffTime", 0L)
        
        if (activityConditionType == 0) return true // Off condition
        
        val currentTimeMillis = System.currentTimeMillis()
        val intervalInMillis = activityInterval * 60 * 1000L
        val lastActivityTime = kotlin.math.max(screenOnTime, screenOffTime)
        val timeSinceLastActivity = currentTimeMillis - lastActivityTime
        val isActiveWithinInterval = timeSinceLastActivity <= intervalInMillis
        
        return when (activityConditionType) {
            1 -> isActiveWithinInterval      // Ring when active
            2 -> !isActiveWithinInterval     // Cancel when active
            3 -> !isActiveWithinInterval     // Ring when inactive
            4 -> isActiveWithinInterval      // Cancel when inactive
            else -> true
        }
    }
    
    private fun checkCombinationResult() {
        val results = mutableListOf<Boolean>()
        var expectedResultCount = 0
        
        // Use the stored enabled states from initialization
        
        if (isLocationEnabledFromIntent) {
            expectedResultCount++
            locationResult?.let { results.add(it) }
        }
        if (isWeatherEnabledFromIntent) {
            expectedResultCount++
            weatherResult?.let { results.add(it) }
        }
        if (isActivityEnabledFromIntent) {
            expectedResultCount++
            activityResult?.let { results.add(it) }
        }
        
        Log.d("SmartControlCombination", "Results so far: ${results.size}/$expectedResultCount")
        Log.d("SmartControlCombination", "Results: location=$locationResult, weather=$weatherResult, activity=$activityResult")
        
        // Only make decision if we have all expected results
        if (results.size >= expectedResultCount && expectedResultCount > 0) {
            val shouldRing = when (smartControlCombinationType) {
                0 -> { // AND logic - ALL must pass (return true)
                    val allPass = results.all { it }
                    Log.d("SmartControlCombination", "AND logic: all results must be true. Results: $results, All pass: $allPass")
                    allPass
                }
                1 -> { // OR logic - ANY can pass (return true)
                    val anyPass = results.any { it }
                    Log.d("SmartControlCombination", "OR logic: any result can be true. Results: $results, Any pass: $anyPass")
                    anyPass
                }
                else -> {
                    Log.d("SmartControlCombination", "Unknown combination type: $smartControlCombinationType")
                    true
                }
            }
            
            Log.d("SmartControlCombination", "Final decision: shouldRing = $shouldRing (combination type: $smartControlCombinationType)")
            
            if (shouldRing) {
                ringAlarm()
            } else {
                cancelAlarm()
            }
            
            stopSelf()
        } else {
            Log.d("SmartControlCombination", "Waiting for more results...")
        }
    }
    
    private fun ringAlarm() {
        Log.d("SmartControlCombination", "Ringing alarm - smart control combination passed")
        
        val flutterIntent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            putExtra("initialRoute", "/")
            putExtra("alarmRing", "true")
            putExtra("isAlarm", "true")
            putExtra("isSharedAlarm", isSharedAlarm)
        }
        
        startActivity(flutterIntent)
        
        val logMessage = when (smartControlCombinationType) {
            0 -> "Alarm ringing - ALL smart control conditions passed"
            1 -> "Alarm ringing - AT LEAST ONE smart control condition passed"
            else -> "Alarm ringing - smart control combination logic"
        }
        
        logdbHelper.insertLog(
            logMessage,
            status = LogDatabaseHelper.Status.SUCCESS,
            type = LogDatabaseHelper.LogType.NORMAL,
            hasRung = 1
        )
    }
    
    private fun cancelAlarm() {
        Log.d("SmartControlCombination", "Canceling alarm - smart control combination failed")
        
        val logMessage = when (smartControlCombinationType) {
            0 -> "Alarm cancelled - NOT ALL smart control conditions passed"
            1 -> "Alarm cancelled - NO smart control conditions passed"
            else -> "Alarm cancelled - smart control combination logic"
        }
        
        logdbHelper.insertLog(
            logMessage,
            status = LogDatabaseHelper.Status.WARNING,
            type = LogDatabaseHelper.LogType.NORMAL,
            hasRung = 0
        )
    }
    
    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Smart Control Combination",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Processing smart control combinations"
        }
        
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(channel)
    }
    
    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Smart Control Check")
            .setContentText("Checking smart control combinations...")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .build()
    }
    
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
    
    override fun onDestroy() {
        super.onDestroy()
        serviceJob.cancel()
        Log.d("SmartControlCombination", "Service destroyed")
    }
}