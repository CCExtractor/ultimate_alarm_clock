package com.ccextractor.ultimate_alarm_clock

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.hardware.display.DisplayManager
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.android.volley.Response
import com.android.volley.toolbox.Volley
import com.ultimate_alarm_clock.Utilities.LocationHelper
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import java.util.Timer
import kotlin.concurrent.schedule
import android.content.pm.ServiceInfo
import android.database.sqlite.SQLiteDatabase
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale


class WeatherFetcherService() : Service() {

    private val CHANNEL_ID = "location_fetcher_channel"
    private val notificationId = 4
    private var OPEN_METEO_URL=""
    var shouldRing = true
    private lateinit var sharedPreferences: SharedPreferences
    private lateinit var displayManager: DisplayManager
    private var weatherTypes= ""

    override fun onCreate() = runBlocking {
        super.onCreate()

        sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager

        createNotificationChannel()
        var fetchLocationDeffered = async {
            fetchLocation()
        }


        var currentLongitude = 0.0
        var currentLatitude = 0.0
        weatherTypes = sharedPreferences.getString("flutter.weatherTypes", "")!!
        var location = fetchLocationDeffered.await()
        Log.d("Location", location)
        val current = location.split(",")
        if (current.size == 2) {
            try {
                currentLatitude = current[0].toDouble()
                currentLongitude = current[1].toDouble()
                OPEN_METEO_URL = "https://api.open-meteo.com/v1/forecast?latitude=${currentLatitude}&longitude=${currentLongitude}&current=rain,snowfall,cloud_cover,wind_speed_10m"
                Log.d("j", "$OPEN_METEO_URL ")
                var fetchWeatherDeffered = async {
                    fetchWeather()
                }
                fetchWeatherDeffered.await()

            } catch (e: NumberFormatException) {
            }
        } else {
            println("Invalid location string format. Expected: \"lat,long\"")
        }





    }

    suspend fun fetchLocation(): String {
        val location = LocationHelper(this).getCurrentLocation()
        return location
    }
    suspend fun fetchWeather(){
        val dbHelper = HistoryDbHelper(this@WeatherFetcherService)
        val historyDb: SQLiteDatabase = dbHelper.writableDatabase

        var currentWeather = ""
        val request = GsonRequest(OPEN_METEO_URL, WeatherModel::class.java,
            { response ->

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
                Log.d("Weather",currentWeather)
                if(weatherTypes.contains(currentWeather)){
                    shouldRing = false

                    val values = ContentValues().apply {
                        put("didAlarmRing", 0)
                        put("alarmTime", getCurrentTime())
                        put("reason", "weather")
                        put("weatherTypes", weatherTypes)
                        put("weatherAtAlarmTime", currentWeather)
                    }
                    historyDb.insert("alarmHistory", null, values)
                    historyDb.close()

                    if(shouldRing==false)
                    
                    {
                        Timer().schedule(3000) {
                            stopSelf()
                        }
                    }

                }
                else{
                    shouldRing = true

                        if (shouldRing) {

                            val flutterIntent =
                                Intent(this@WeatherFetcherService, MainActivity::class.java).apply {
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                                    putExtra("initialRoute", "/")
                                    putExtra("alarmRing", "true")
                                    putExtra("isAlarm", "true")

                                }

                            Timer().schedule(9000) {
                                println("ANDROID STARTING APP")
                                this@WeatherFetcherService.startActivity(flutterIntent)

                                val values = ContentValues().apply {
                                    put("didAlarmRing", 1)
                                    put("alarmTime", getCurrentTime())
                                    put("reason", "weather")
                                    put("weatherTypes", weatherTypes)
                                    put("weatherAtAlarmTime", currentWeather)
                                }
                                historyDb.insert("alarmHistory", null, values)
                                historyDb.close()

                                Timer().schedule(3000) {
                                    stopSelf()
                                }
                            }



                    }
                }
            },
            { error ->
            })

// Add the request to the Volley request queue
        Volley.newRequestQueue(this)
            .add(request)
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
        startForeground(notificationId, getNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
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

    private fun getCurrentTime(): String {
        val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
        return formatter.format(Date())
    }

    override fun onDestroy() {
        super.onDestroy()
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }


}