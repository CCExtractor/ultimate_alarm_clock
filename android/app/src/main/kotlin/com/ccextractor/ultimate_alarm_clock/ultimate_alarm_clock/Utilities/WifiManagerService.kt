package com.ccextractor.ultimate_alarm_clock.ultimate_alarm_clock.Utilities

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.ConnectivityManager
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.os.IBinder
import com.ccextractor.ultimate_alarm_clock.LogDatabaseHelper
import com.ccextractor.ultimate_alarm_clock.MainActivity
import kotlinx.coroutines.runBlocking

class WifiManagerService: Service() {

    override fun onCreate(): Unit = runBlocking {
        super.onCreate()

        val currBSSID = getCurrentBSSID(this@WifiManagerService)
        val logdbHelper = LogDatabaseHelper(this@WifiManagerService)
        if(currBSSID != null){
            println("WIFI BSSID: $currBSSID")

            val sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val wifiBSSID: String = sharedPreferences.getString("flutter.wifi_BSSID", "")!!

            if(wifiBSSID != currBSSID){
                println("Phone connected to some different wifi network.")
                val flutterIntent =
                    Intent(this@WifiManagerService, MainActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                        putExtra("initialRoute", "/")
                        putExtra("alarmRing", "true")
                        putExtra("isAlarm", "true")

                    }
                println("ANDROID STARTING APP")
                this@WifiManagerService.startActivity(flutterIntent)
                logdbHelper.insertLog(
                    "Alarm is ringing. Phone is connected to different wifi network than what was specified.",
                    status = LogDatabaseHelper.Status.SUCCESS,
                    type = LogDatabaseHelper.LogType.NORMAL,
                    hasRung = 1
                )

                stopSelf()
            }
            else{
                logdbHelper.insertLog(
                    "Alarm doesn't ring. Phone is connected to the same wifi network as what was specified.",
                    status = LogDatabaseHelper.Status.WARNING,
                    type = LogDatabaseHelper.LogType.NORMAL,
                    hasRung = 1
                )
                stopSelf()
            }
        }
        else {
            println("NO WIFI CONNECTED!")
            val flutterIntent =
                Intent(this@WifiManagerService, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                    putExtra("initialRoute", "/")
                    putExtra("alarmRing", "true")
                    putExtra("isAlarm", "true")

                }
            println("ANDROID STARTING APP")
            this@WifiManagerService.startActivity(flutterIntent)
            logdbHelper.insertLog(
                "Alarm is ringing. Phone is not connected to any wifi.",
                status = LogDatabaseHelper.Status.SUCCESS,
                type = LogDatabaseHelper.LogType.NORMAL,
                hasRung = 1
            )

            stopSelf()
        }

        stopSelf()
    }

    fun getCurrentBSSID(context: Context): String? {
        val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager

        val info = wifiManager.connectionInfo
        return info?.bssid
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }
}