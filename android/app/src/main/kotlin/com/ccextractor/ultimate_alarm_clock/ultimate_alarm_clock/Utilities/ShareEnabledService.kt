package com.ccextractor.ultimate_alarm_clock

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.ccextractor.ultimate_alarm_clock.MainActivity
import com.ccextractor.ultimate_alarm_clock.R
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.tasks.await

class ShareEnabledService : Service() {

    private val CHANNEL_ID = "share_activity_channel"
    private val notificationId = 3

    private lateinit var sharedPreferences: SharedPreferences

    override fun onCreate() = runBlocking {
        super.onCreate()
        createNotificationChannel()
        startForeground(notificationId, getNotification())
        sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        val isShared = sharedPreferences.getString("flutter.owner", "")
        val alarmId = sharedPreferences.getString("flutter.alarmId", "")
        Log.d("id", "id $isShared")
        Log.d("id", "id $alarmId")

        var isRemoved = true
        if (isShared != "" && isShared != null) {

            val isRemovedDeferred = async {
                share(isShared, alarmId)
            }
            isRemoved = isRemovedDeferred.await()


        }
        if (isRemoved) {
            Log.d("id", "id $isRemoved")

        }
        val editor = sharedPreferences.edit()
        editor.putString("flutter.isRemoved", "$isRemoved")
        editor.apply()


    }

    suspend fun share(isShared: String, alarmId: String?): Boolean {
        var isRemoved = true
        val dbs = FirebaseFirestore.getInstance()
        val collectionReference = dbs.collection("users")
        val task = collectionReference.document(isShared).get().await()
        if (task.exists()) {
            val data = task.data
            data?.let {
                val sharedAlarms = data["sentAlarms"] as List<*>
                if (sharedAlarms != null) {
                    Log.d("id", "id $sharedAlarms")
                    for (a in sharedAlarms) {
                        val alarmData = a as Map<*, *>
                        val alarmName = alarmData["AlarmName"]
                        if (alarmName.toString() == alarmId) {
                            Log.d("id", "id $alarmName")
                            isRemoved = false
                            break
                        }
                    }
                }
            }
        }
        return isRemoved
    }

    private fun createNotificationChannel() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val name = "Checking alarm status!"
            val description = "The alarm may be dismissed by the owner."
            val importance = NotificationManager.IMPORTANCE_MIN

            val channel = NotificationChannel(CHANNEL_ID, name, importance)
            channel.description = description

            // Register the channel with the system; you can also configure its behavior (e.g., sound) here
            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(notificationId, getNotification())
        return START_STICKY
    }

    private fun getNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java) // Replace with your main activity
        val pendingIntent =
            PendingIntent.getActivity(
                this,
                8,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("User dismissed the alarm!")
            .setContentText("Alarm wont ring now.")
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


}

