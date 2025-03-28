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
import android.os.SystemClock.sleep
import android.util.Log
import androidx.core.app.NotificationCompat
import com.ultimate_alarm_clock.Utilities.LocationHelper
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import java.util.Timer
import kotlin.concurrent.schedule
import kotlin.math.atan2
import kotlin.math.cos
import kotlin.math.pow
import kotlin.math.sin
import kotlin.math.sqrt

class LocationFetcherService : Service() {

    private val CHANNEL_ID = "location_fetcher_channel"
    private val notificationId = 4

    private lateinit var sharedPreferences: SharedPreferences
    private lateinit var displayManager: DisplayManager

    override fun onCreate() = runBlocking {
        super.onCreate()

        sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager

        createNotificationChannel()
        startForeground(notificationId, getNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
        var fetchLocationDeffered = async {
            fetchLocation()
        }

        val logdbHelper = LogDatabaseHelper(this@LocationFetcherService)
        var destinationLongitude = 0.0
        var currentLongitude = 0.0
        var destinationLatitude = 0.0
        var currentLatitude = 0.0
        var location = fetchLocationDeffered.await()
        Log.d("Location", location)
        val setLocationString = sharedPreferences.getString("flutter.set_location", "")
        val current = location.split(",")
        if (current.size == 2) {
            try {
                currentLatitude = current[0].toDouble()
                currentLongitude = current[1].toDouble()
            } catch (e: NumberFormatException) {
            }
        } else {
            println("Invalid location string format. Expected: \"lat,long\"")
        }
        val destination = setLocationString!!.split(",")
        if (destination.size == 2) {
            try {
                destinationLatitude = destination[0].toDouble()
                destinationLongitude = destination[1].toDouble()

            } catch (e: NumberFormatException) {
                println("Invalid latitude or longitude format.")
            }
        } else {
            println("Invalid location string format. Expected: \"lat,long\"")
        }
        val distance = calculateDistance(
            Location(currentLatitude, currentLongitude),
            Location(destinationLatitude, destinationLongitude)
        )
        Log.d("Distance", "distance ${distance}")
        if (distance >= 500.0) {

            val flutterIntent =
                Intent(this@LocationFetcherService, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                    putExtra("initialRoute", "/")
                    putExtra("alarmRing", "true")
                    putExtra("isAlarm", "true")

                }

            Timer().schedule(9000){
            println("ANDROID STARTING APP")
            this@LocationFetcherService.startActivity(flutterIntent)
                logdbHelper.insertLog(
                    "Alarm is ringing. Alarm rings because you are ${distance}m away from chosen location",
                    status = LogDatabaseHelper.Status.SUCCESS,
                    type = LogDatabaseHelper.LogType.NORMAL,
                    hasRung = 1
                )
                Timer().schedule(3000){
                    stopSelf()
                }
            }


        }
        if(distance < 500.0){
            logdbHelper.insertLog(
                "Alarm didn't ring. Because you are only ${distance}m away from chosen location",
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


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
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
            .setContentTitle("Fetching Location for alarm")
            .setContentText("Waiting...")
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

