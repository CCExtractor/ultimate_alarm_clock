package com.ccextractor.ultimate_alarm_clock

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.hardware.display.DisplayManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.android.volley.DefaultRetryPolicy
import com.android.volley.Response
import com.android.volley.TimeoutError
import com.android.volley.VolleyError
import com.android.volley.toolbox.Volley
import com.ccextractor.ultimate_alarm_clock.LocationHelper
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import java.util.Timer
import kotlin.concurrent.schedule
import android.content.pm.ServiceInfo

class WeatherFetcherService() : Service() {

    private val CHANNEL_ID = "weather_fetcher_channel"
    private val notificationId = 4
    private var OPEN_METEO_URL=""
    var shouldRing = true
    private lateinit var sharedPreferences: SharedPreferences
    private lateinit var displayManager: DisplayManager
    private var weatherTypes= ""
    private var weatherConditionType = 0
    private var alarmID = ""
    private var isSharedAlarm = false
    
    // Retry configuration
    private val MAX_RETRIES = 3
    private val LOCATION_TIMEOUT = 20000L // 20 seconds
    private val WEATHER_API_TIMEOUT = 15000L // 15 seconds

    override fun onCreate() {
        super.onCreate()
        sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // CRITICAL: Start foreground service IMMEDIATELY to prevent timeout on strict devices
        try {
            startForeground(notificationId, getNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
            Log.d("WeatherFetcherService", "✅ Started foreground service successfully")
        } catch (e: Exception) {
            Log.e("WeatherFetcherService", "❌ Failed to start foreground service: ${e.message}")
            // If we can't start foreground service, ring alarm immediately and stop
            ringAlarm("Failed to start weather service: ${e.message}")
            return START_NOT_STICKY
        }
        
        if (intent != null) {
            alarmID = intent.getStringExtra("alarmID") ?: ""
            weatherTypes = intent.getStringExtra("weatherTypes") ?: ""
            weatherConditionType = intent.getIntExtra("weatherConditionType", 2)
            isSharedAlarm = intent.getBooleanExtra("isSharedAlarm", false)
            
            Log.d("WeatherFetcherService", "onStartCommand called")
            Log.d("WeatherFetcherService", "Processing alarm - ID: $alarmID, isShared: $isSharedAlarm")
            Log.d("WeatherFetcherService", "Weather types JSON: $weatherTypes, condition type: $weatherConditionType")
            
            // Convert weather types from JSON array to comma-separated string
            val weatherTypesString = getWeatherConditions(weatherTypes)
            Log.d("WeatherFetcherService", "Converted weather types: $weatherTypesString")
            
            // Process weather alarm in background
            processWeatherAlarmWithRetry(weatherTypesString)
        } else {
            Log.e("WeatherFetcherService", "Intent is null, ringing alarm with error")
            ringAlarm("Weather service started with null intent")
        }
        
        return START_NOT_STICKY
    }
    
    private fun processWeatherAlarmWithRetry(weatherTypesString: String) {
        Thread {
            var attempt = 1
            var success = false
            
            while (attempt <= MAX_RETRIES && !success) {
                Log.d("WeatherFetcherService", "Weather fetch attempt $attempt/$MAX_RETRIES")
                
                try {
                    // Check network connectivity first
                    if (!isNetworkAvailable()) {
                        Log.w("WeatherFetcherService", "No network connectivity - attempt $attempt")
                        if (attempt == MAX_RETRIES) {
                            ringAlarm("No network connectivity after $MAX_RETRIES attempts - defaulting to ring")
                            return@Thread
                        }
                        Thread.sleep(3000) // Wait 3 seconds before retry
                        attempt++
                        continue
                    }
                    
                    // Get location with timeout
                    val location = getLocationWithTimeout()
                    Log.d("WeatherLocation", "Location (attempt $attempt): $location")
                    
                    if (location == "null" || location.isEmpty()) {
                        Log.w("WeatherFetcherService", "Failed to get location - attempt $attempt")
                        if (attempt == MAX_RETRIES) {
                            ringAlarm("Location unavailable after $MAX_RETRIES attempts - defaulting to ring")
                            return@Thread
                        }
                        Thread.sleep(2000) // Wait 2 seconds before retry
                        attempt++
                        continue
                    }
                    
                    val current = location.split(",")
                    if (current.size == 2) {
                        val currentLatitude = current[0].toDouble()
                        val currentLongitude = current[1].toDouble()
                        OPEN_METEO_URL = "https://api.open-meteo.com/v1/forecast?latitude=${currentLatitude}&longitude=${currentLongitude}&current=rain,snowfall,cloud_cover,wind_speed_10m"
                        Log.d("WeatherAPI", "API URL (attempt $attempt): $OPEN_METEO_URL")
                        
                        // Fetch weather with retry logic
                        fetchWeatherWithRetry(weatherTypesString, attempt)
                        success = true // fetchWeatherWithRetry handles its own logic
                        return@Thread
                    } else {
                        Log.e("WeatherFetcherService", "Invalid location format: $location - attempt $attempt")
                        if (attempt == MAX_RETRIES) {
                            ringAlarm("Invalid location format after $MAX_RETRIES attempts - defaulting to ring")
                            return@Thread
                        }
                    }
                } catch (e: Exception) {
                    Log.e("WeatherFetcherService", "Error in attempt $attempt: ${e.message}")
                    if (attempt == MAX_RETRIES) {
                        ringAlarm("Weather processing failed after $MAX_RETRIES attempts - defaulting to ring")
                        return@Thread
                    }
                }
                
                // Wait before retry
                Thread.sleep(2000)
                attempt++
            }
        }.start()
    }
    
    private fun isNetworkAvailable(): Boolean {
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val network = connectivityManager.activeNetwork ?: return false
        val capabilities = connectivityManager.getNetworkCapabilities(network) ?: return false
        return capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) || 
               capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
               capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)
    }
    
    private fun getLocationWithTimeout(): String {
        return try {
            val locationHelper = LocationHelper(this)
            val location = locationHelper.getCurrentLocation()
            Log.d("WeatherFetcherService", "Location fetch completed: $location")
            location
        } catch (e: Exception) {
            Log.e("WeatherFetcherService", "Error getting location: ${e.message}")
            "null"
        }
    }

    private fun fetchLocation(): String {
        return LocationHelper(this).getCurrentLocation()
    }
    
    private fun fetchWeatherWithRetry(weatherTypesString: String, currentAttempt: Int) {
        var currentWeather = ""
        val logdbHelper = LogDatabaseHelper(this@WeatherFetcherService)
        
        val request = GsonRequest(OPEN_METEO_URL, WeatherModel::class.java,
            { response ->
                Log.d("WeatherFetcherService", "Weather API response received successfully")
                
                if(response.current?.rain!! >0 && response.current?.windSpeed10m!! > 40.0){
                    currentWeather="stormy"
                }
                else if(response.current?.rain!! >0)
                {
                    currentWeather="rainy"
                }
                else if(response.current?.cloudCover!! >60){
                    currentWeather="cloudy"
                }
                else if(response.current?.windSpeed10m!! > 20.0){
                    currentWeather="windy"
                }
                else{
                    currentWeather="sunny"
                }
                
                Log.d("Weather", "Current weather: $currentWeather")
                Log.d("WeatherTypes", "Selected types: $weatherTypesString")
                
                // Check if all weather types are selected (special case)
                val allWeatherTypes = "sunny,cloudy,rainy,windy,stormy"
                val allTypesSelected = weatherTypesString == allWeatherTypes
                
                val weatherMatches = weatherTypesString.contains(currentWeather)
                Log.d("WeatherMatch", "Weather matches selected types: $weatherMatches")
                Log.d("WeatherMatch", "All weather types selected: $allTypesSelected")
                
                // Add condition type name for better debugging
                val conditionTypeName = when (weatherConditionType) {
                    0 -> "OFF"
                    1 -> "RING_WHEN_MATCH"
                    2 -> "CANCEL_WHEN_MATCH"
                    3 -> "RING_WHEN_DIFFERENT"
                    4 -> "CANCEL_WHEN_DIFFERENT"
                    else -> "UNKNOWN"
                }
                
                Log.d("WeatherCondition", "=== WEATHER CONDITION TEST ===")
                Log.d("WeatherCondition", "Condition Type: $conditionTypeName (index: $weatherConditionType)")
                Log.d("WeatherCondition", "Current Weather: $currentWeather")
                Log.d("WeatherCondition", "Selected Weather Types: $weatherTypesString")
                Log.d("WeatherCondition", "Weather Matches Selection: $weatherMatches")
                
                // Enhanced weather condition logic
                when (weatherConditionType) {
                    0 -> { // off - no weather condition
                        shouldRing = true
                        Log.d("WeatherCondition", "OFF: Alarm will ring regardless of weather")
                    }
                    1 -> { // ringWhenMatch - ring when weather matches selected types
                        shouldRing = weatherMatches
                        Log.d("WeatherCondition", "RING_WHEN_MATCH: shouldRing = $shouldRing (${if (weatherMatches) "weather matches" else "weather doesn't match"})")
                    }
                    2 -> { // cancelWhenMatch - cancel when weather matches selected types
                        if (allTypesSelected) {
                            // Special case: if all weather types are selected, always ring (user wants no weather restrictions)
                            shouldRing = true
                            Log.d("WeatherCondition", "CANCEL_WHEN_MATCH: All weather types selected - treating as no weather restrictions, shouldRing = true")
                        } else {
                            shouldRing = !weatherMatches
                            Log.d("WeatherCondition", "CANCEL_WHEN_MATCH: shouldRing = $shouldRing (${if (!weatherMatches) "weather doesn't match, so ring" else "weather matches, so cancel"})")
                        }
                    }
                    3 -> { // ringWhenDifferent - ring when weather is different from selected types
                        if (allTypesSelected) {
                            // Special case: if all weather types are selected, never ring (no weather is different from all types)
                            shouldRing = false
                            Log.d("WeatherCondition", "RING_WHEN_DIFFERENT: All weather types selected - no weather can be different, shouldRing = false")
                        } else {
                            shouldRing = !weatherMatches
                            Log.d("WeatherCondition", "RING_WHEN_DIFFERENT: shouldRing = $shouldRing (${if (!weatherMatches) "weather is different, so ring" else "weather matches, so don't ring"})")
                        }
                    }
                    4 -> { // cancelWhenDifferent - cancel when weather is different from selected types
                        if (allTypesSelected) {
                            // Special case: if all weather types are selected, always ring (no weather is different to cancel)
                            shouldRing = true
                            Log.d("WeatherCondition", "CANCEL_WHEN_DIFFERENT: All weather types selected - no weather is different to cancel, shouldRing = true")
                        } else {
                            shouldRing = weatherMatches
                            Log.d("WeatherCondition", "CANCEL_WHEN_DIFFERENT: shouldRing = $shouldRing (${if (weatherMatches) "weather matches, so ring" else "weather is different, so cancel"})")
                        }
                    }
                    else -> {
                        shouldRing = true
                        Log.d("WeatherCondition", "Unknown condition type $weatherConditionType - defaulting to ring")
                    }
                }
                
                Log.d("WeatherCondition", "=== FINAL DECISION ===")
                Log.d("WeatherCondition", "Should Ring Alarm: $shouldRing")
                Log.d("WeatherCondition", "=== END TEST ===")
                
                val conditionMessage = "Weather condition ($conditionTypeName) evaluated: current weather is $currentWeather, selected types: $weatherTypesString, matches: $weatherMatches"
                
                if (shouldRing) {
                    ringAlarm(conditionMessage)
                } else {
                    cancelAlarm(conditionMessage)
                }
            },
            { error ->
                Log.e("WeatherFetcherService", "Weather API error (attempt $currentAttempt): $error")
                handleWeatherApiError(error, currentAttempt)
            })

        // Set custom retry policy with timeouts
        request.retryPolicy = DefaultRetryPolicy(
            WEATHER_API_TIMEOUT.toInt(), // timeout
            0, // no Volley retries (we handle our own)
            DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
        )

        // Add the request to the Volley request queue
        Volley.newRequestQueue(this).add(request)
    }
    
    private fun handleWeatherApiError(error: VolleyError, currentAttempt: Int) {
        val errorMessage = when (error) {
            is TimeoutError -> "API timeout"
            else -> error.message ?: "Unknown error"
        }
        
        Log.e("WeatherFetcherService", "Weather API error: $errorMessage")
        
        if (currentAttempt < MAX_RETRIES) {
            Log.d("WeatherFetcherService", "Retrying weather API call in 3 seconds... (attempt ${currentAttempt + 1}/$MAX_RETRIES)")
            Timer().schedule(3000) {
                val weatherTypesString = getWeatherConditions(weatherTypes)
                fetchWeatherWithRetry(weatherTypesString, currentAttempt + 1)
            }
        } else {
            Log.e("WeatherFetcherService", "Weather API failed after $MAX_RETRIES attempts - defaulting to ring")
            ringAlarm("Weather API failed after $MAX_RETRIES attempts - defaulting to ring")
        }
    }
    
    private fun ringAlarm(logMessage: String) {
        val logdbHelper = LogDatabaseHelper(this@WeatherFetcherService)
        val flutterIntent = Intent(this@WeatherFetcherService, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            putExtra("initialRoute", "/")
            putExtra("alarmRing", "true")
            putExtra("isAlarm", "true")
            if (isSharedAlarm) {
                putExtra("isSharedAlarm", true)
            }
        }

        // Start alarm immediately after weather evaluation
        println("ANDROID STARTING APP")
        this@WeatherFetcherService.startActivity(flutterIntent)
        logdbHelper.insertLog(
            "Alarm is ringing. $logMessage",
            status = LogDatabaseHelper.Status.SUCCESS,
            type = LogDatabaseHelper.LogType.NORMAL,
            hasRung = 1
        )
        
        // Stop service after a short delay to ensure app launch
        Timer().schedule(2000) {
            stopSelf()
        }
    }
    
    private fun cancelAlarm(logMessage: String) {
        val logdbHelper = LogDatabaseHelper(this@WeatherFetcherService)
        logdbHelper.insertLog(
            "Alarm cancelled. $logMessage",
            status = LogDatabaseHelper.Status.WARNING,
            type = LogDatabaseHelper.LogType.NORMAL,
            hasRung = 0
        )
        
        // Stop service immediately if alarm is canceled
        Timer().schedule(1000) {
            stopSelf()
        }
    }
    
    private fun getWeatherConditions(input: String): String {
        val weatherMap = mapOf(
            0 to "sunny",
            1 to "cloudy", 
            2 to "rainy",
            3 to "windy",
            4 to "stormy"
        )

        return try {
            // Handle empty arrays gracefully
            if (input.isEmpty() || input == "[]") {
                Log.d("WeatherFetcherService", "Empty weather types array - no specific weather types selected")
                return ""
            }
            
            val indices = input
                .removeSurrounding("[", "]")
                .split(",")
                .filter { it.trim().isNotEmpty() } // Filter out empty strings
                .map { it.trim().toInt() }

            val conditions = indices.mapNotNull { weatherMap[it] }
            conditions.joinToString(",")
        } catch (e: Exception) {
            Log.e("WeatherFetcherService", "Error parsing weather types: $input, ${e.message}")
            ""
        }
    }


    private fun createNotificationChannel() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val name = "Weather Fetcher"
            val description = "Weather Fetcher Channel"
            val importance = NotificationManager.IMPORTANCE_HIGH

            val channel = NotificationChannel(CHANNEL_ID, name, importance)
            channel.description = description

            // Register the channel with the system; you can also configure its behavior (e.g., sound) here
            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }


    private fun getNotification(): Notification {
        return try {
            val intent = Intent(this, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                this,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )

            val notification = NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Checking Weather for alarm")
                .setContentText("Evaluating weather conditions...")
                .setSmallIcon(R.mipmap.launcher_icon)
                .setContentIntent(pendingIntent)
                .setOngoing(true)
                .setCategory(Notification.CATEGORY_SERVICE)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setSound(null)
                .setVibrate(null)
                .build()
            
            return notification
        } catch (e: Exception) {
            Log.e("WeatherFetcherService", "Error creating notification: ${e.message}")
            // Fallback: create minimal notification
            return Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("Weather Service")
                .setContentText("Checking weather...")
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .build()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }


}