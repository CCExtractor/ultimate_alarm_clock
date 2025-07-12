package com.ccextractor.ultimate_alarm_clock

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.content.SharedPreferences
import android.hardware.display.DisplayManager
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.ccextractor.ultimate_alarm_clock.LocationHelper
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import java.util.Timer
import kotlin.concurrent.schedule
import kotlin.math.atan2
import kotlin.math.cos
import kotlin.math.pow
import kotlin.math.sin
import kotlin.math.sqrt
import kotlinx.coroutines.TimeoutCancellationException
import kotlinx.coroutines.withTimeout

class LocationFetcherService : Service() {

    private val CHANNEL_ID = "location_fetcher_channel"
    private val notificationId = 4

    private lateinit var sharedPreferences: SharedPreferences
    private lateinit var displayManager: DisplayManager
    private var locationConditionType: Int = 2 // Default value
    private var alarmID: String = ""
    private var targetLocation: String = ""
    private var isSharedAlarm: Boolean = false

    override fun onCreate() {
        super.onCreate()
        sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("LocationFetcherService", "onStartCommand called")
        
        // Extract data from intent
        alarmID = intent?.getStringExtra("alarmID") ?: ""
        targetLocation = intent?.getStringExtra("location") ?: ""
        isSharedAlarm = intent?.getBooleanExtra("isSharedAlarm", false) ?: false
        locationConditionType = intent?.getIntExtra("locationConditionType", 2) ?: 2
        
        Log.d("LocationFetcherService", "Processing alarm - ID: $alarmID, isShared: $isSharedAlarm")
        Log.d("LocationFetcherService", "LocationConditionType from intent: $locationConditionType")
        Log.d("LocationFetcherService", "Target location: $targetLocation")
        
        // Validate location data
        if (targetLocation.isEmpty() || targetLocation == "0.0,0.0") {
            Log.e("LocationFetcherService", "Invalid target location: $targetLocation")
            // Still ring the alarm if location data is invalid
            ringAlarmWithError("Invalid target location data")
            return START_NOT_STICKY
        }
        
        startForeground(notificationId, getNotification())
        
        try {
            processLocationAlarm()
        } catch (e: Exception) {
            Log.e("LocationFetcherService", "Error processing location alarm: ${e.message}")
            ringAlarmWithError("Error processing location: ${e.message}")
        }
        
        return START_NOT_STICKY
    }
    
    private fun ringAlarmWithError(errorMessage: String) {
        Log.e("LocationFetcherService", "Ringing alarm due to error: $errorMessage")
        val logdbHelper = LogDatabaseHelper(this)
        logdbHelper.insertLog(
            "Alarm ringing due to location error: $errorMessage",
            status = LogDatabaseHelper.Status.ERROR,
            type = LogDatabaseHelper.LogType.NORMAL,
            hasRung = 1
        )
        
        val flutterIntent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            putExtra("initialRoute", "/")
            putExtra("alarmRing", "true")
            putExtra("isAlarm", "true")
            if (isSharedAlarm) {
                putExtra("isSharedAlarm", true)
            }
        }
        
        Timer().schedule(3000) {
            println("ANDROID STARTING APP DUE TO ERROR")
            this@LocationFetcherService.startActivity(flutterIntent)
            Timer().schedule(3000) {
                stopSelf()
            }
        }
    }

    private fun processLocationAlarm() {
        runBlocking {
            Log.d("LocationFetcherService", "Starting location fetch...")
            
            val logdbHelper = LogDatabaseHelper(this@LocationFetcherService)
            var destinationLongitude = 0.0
            var currentLongitude = 0.0
            var destinationLatitude = 0.0
            var currentLatitude = 0.0
            
            // Add timeout for location fetching
            val fetchLocationDeffered = async {
                try {
                    withTimeout(30000) { // 30 second timeout
                        fetchLocation()
                    }
                } catch (e: TimeoutCancellationException) {
                    Log.e("LocationFetcherService", "Location fetch timeout after 30 seconds")
                    "timeout"
                } catch (e: Exception) {
                    Log.e("LocationFetcherService", "Location fetch error: ${e.message}")
                    "error"
                }
            }
            
            val location = fetchLocationDeffered.await()
            Log.d("Location", location)
            
            // Handle location fetch failures
            if (location == "timeout" || location == "error" || location.isEmpty()) {
                Log.e("LocationFetcherService", "Failed to get location: $location")
                ringAlarmWithError("Failed to get current location: $location")
                return@runBlocking
            }
            
            // Use targetLocation from intent instead of SharedPreferences
            val setLocationString = targetLocation
            
            val current = location.split(",")
            if (current.size == 2) {
                try {
                    currentLatitude = current[0].toDouble()
                    currentLongitude = current[1].toDouble()
                } catch (e: NumberFormatException) {
                    Log.e("LocationFetcherService", "Invalid current location format: $location")
                    ringAlarmWithError("Invalid current location format")
                    return@runBlocking
                }
            } else {
                Log.e("LocationFetcherService", "Invalid current location format. Expected: \"lat,long\"")
                ringAlarmWithError("Invalid current location format")
                return@runBlocking
            }
            
            val destination = setLocationString.split(",")
            if (destination.size == 2) {
                try {
                    destinationLatitude = destination[0].toDouble()
                    destinationLongitude = destination[1].toDouble()
                } catch (e: NumberFormatException) {
                    Log.e("LocationFetcherService", "Invalid destination location format: $setLocationString")
                    ringAlarmWithError("Invalid destination location format")
                    return@runBlocking
                }
            } else {
                Log.e("LocationFetcherService", "Invalid destination location format. Expected: \"lat,long\"")
                ringAlarmWithError("Invalid destination location format")
                return@runBlocking
            }
            val distance = calculateDistance(
                Location(currentLatitude, currentLongitude),
                Location(destinationLatitude, destinationLongitude)
            )
            
            val isWithin500m = distance < 500.0
            
            Log.d("Distance", "distance ${distance}")
            Log.d("LocationCondition", "type ${locationConditionType}")
            
            // Add detailed condition type logging
            val conditionTypeName = when (locationConditionType) {
                0 -> "OFF"
                1 -> "RING_WHEN_AT"
                2 -> "CANCEL_WHEN_AT" 
                3 -> "RING_WHEN_AWAY"
                4 -> "CANCEL_WHEN_AWAY"
                else -> "UNKNOWN"
            }
            
            Log.d("LocationCondition", "=== LOCATION CONDITION TEST ===")
            Log.d("LocationCondition", "Condition Type: $conditionTypeName (index: $locationConditionType)")
            Log.d("LocationCondition", "Current Location: $currentLatitude, $currentLongitude")
            Log.d("LocationCondition", "Target Location: $destinationLatitude, $destinationLongitude") 
            Log.d("LocationCondition", "Distance: ${String.format("%.2f", distance)}m")
            Log.d("LocationCondition", "Within 500m radius: $isWithin500m")
            
            var shouldRingAlarm = false
            var logMessage = ""
            
            when (locationConditionType) {
                0 -> { // Off - should not reach here, but handle gracefully
                    shouldRingAlarm = true
                    logMessage = "Location condition is off, alarm rings normally"
                }
                1 -> { // Ring when AT location (within 500m)
                    shouldRingAlarm = isWithin500m
                    logMessage = if (isWithin500m) {
                        "Alarm is ringing. You are ${distance}m from chosen location (within 500m)"
                    } else {
                        "Alarm didn't ring. You are ${distance}m away from chosen location (beyond 500m)"
                    }
                }
                2 -> { // Cancel when AT location (within 500m) - original behavior
                    shouldRingAlarm = !isWithin500m
                    logMessage = if (isWithin500m) {
                        "Alarm didn't ring. You are only ${distance}m away from chosen location"
                    } else {
                        "Alarm is ringing. You are ${distance}m away from chosen location"
                    }
                }
                3 -> { // Ring when AWAY from location (beyond 500m)
                    shouldRingAlarm = !isWithin500m
                    logMessage = if (!isWithin500m) {
                        "Alarm is ringing. You are ${distance}m away from chosen location (beyond 500m)"
                    } else {
                        "Alarm didn't ring. You are only ${distance}m from chosen location (within 500m)"
                    }
                }
                4 -> { // Cancel when AWAY from location (beyond 500m)
                    shouldRingAlarm = isWithin500m
                    logMessage = if (!isWithin500m) {
                        "Alarm didn't ring. You are ${distance}m away from chosen location (beyond 500m)"
                    } else {
                        "Alarm is ringing. You are ${distance}m from chosen location (within 500m)"
                    }
                }
                else -> { // Default fallback
                    shouldRingAlarm = true
                    logMessage = "Unknown location condition type, alarm rings normally"
                }
            }

            // Log final decision
            Log.d("LocationCondition", "=== FINAL DECISION ===")
            Log.d("LocationCondition", "Should Ring Alarm: $shouldRingAlarm")
            Log.d("LocationCondition", "Reason: $logMessage")
            Log.d("LocationCondition", "=== END TEST ===")

            if (shouldRingAlarm) {
                val flutterIntent =
                    Intent(this@LocationFetcherService, MainActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                        putExtra("initialRoute", "/")
                        putExtra("alarmRing", "true")
                        putExtra("isAlarm", "true")
                        if (isSharedAlarm) {
                            putExtra("isSharedAlarm", true)
                        }
                    }

                Timer().schedule(9000){
                    println("ANDROID STARTING APP")
                    this@LocationFetcherService.startActivity(flutterIntent)
                    logdbHelper.insertLog(
                        logMessage,
                        status = LogDatabaseHelper.Status.SUCCESS,
                        type = LogDatabaseHelper.LogType.NORMAL,
                        hasRung = 1
                    )
                    Timer().schedule(3000){
                        stopSelf()
                    }
                }
            } else {
                logdbHelper.insertLog(
                    logMessage,
                    status = LogDatabaseHelper.Status.WARNING,
                    type = LogDatabaseHelper.LogType.NORMAL,
                    hasRung = 0
                )
                Timer().schedule(9000){
                    Timer().schedule(3000){
                        stopSelf()
                    }
                }
            }
        }
    }

    suspend fun fetchLocation(): String {
        val location = LocationHelper(this).getCurrentLocation()
        return location
    }

    private fun createNotificationChannel() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val name = "Location Fetcher"
            val description = "Location Fetcher Channel"
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
        val intent = Intent(this, MainActivity::class.java) // Replace with your main activity
        val pendingIntent =
            PendingIntent.getActivity(
                this,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Checking Location for alarm")
            .setContentText("Evaluating location condition...")
            .setSmallIcon(R.mipmap.launcher_icon) // Replace with your icon drawable
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setCategory(Notification.CATEGORY_SERVICE)

        return notification.build()
    }

    override fun onDestroy() {
        super.onDestroy()
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    data class Location(val latitude: Double, val longitude: Double)

    fun calculateDistance(current: Location, destination: Location): Double {
        val earthRadius = 6371.0 // Earth's radius in kilometers

        val lat1 = Math.toRadians(current.latitude)
        val lon1 = Math.toRadians(current.longitude)
        val lat2 = Math.toRadians(destination.latitude)
        val lon2 = Math.toRadians(destination.longitude)

        val dlon = lon2 - lon1
        val dlat = lat2 - lat1

        val a = sin(dlat / 2).pow(2) + cos(lat1) * cos(lat2) * sin(dlon / 2).pow(2)
        val c = 2 * atan2(sqrt(a), sqrt(1 - a))

        val distance = earthRadius * c * 1000 // Convert to meters
        return distance
    }
}