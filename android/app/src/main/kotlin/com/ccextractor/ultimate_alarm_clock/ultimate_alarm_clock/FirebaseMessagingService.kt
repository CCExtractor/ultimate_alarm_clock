package com.ccextractor.ultimate_alarm_clock


import android.app.AlarmManager
import android.content.Context
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.util.Date
import java.util.Locale
import android.util.Log
import android.icu.text.SimpleDateFormat
import com.ccextractor.ultimate_alarm_clock.MainActivity

class FirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        // Only handle silent/data-only messages
        if (remoteMessage.data.isNotEmpty()) {
            val type = remoteMessage.data["type"]
            Log.d("FirebaseMessagingService", "Message $type received at native!")
    
            if (type == "rescheduleAlarm") {
                val triggerTime = remoteMessage.data["triggerTime"]!!
                val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val currentScheduledTime = alarmManager.nextAlarmClock?.triggerTime
    
                if (currentScheduledTime != null) {
                    val date = Date(currentScheduledTime)
                    val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
                    val currentFormattedTime = timeFormat.format(date)
                    val timeToAlarmForScheduledAlarm = getTimeDifferenceInMillis(currentFormattedTime)
                    if (timeToAlarmForScheduledAlarm > -1)
                    {
                        // Scheduled alarm is still for the future
                        val timeToAlarmForRescheduledAlarm = getTimeDifferenceInMillis(triggerTime);
                        if (timeToAlarmForRescheduledAlarm > -1 && timeToAlarmForRescheduledAlarm < timeToAlarmForScheduledAlarm) {
                            // Rescheduled alarm is for the future and earlier than the scheduled alarm
                            Log.d("Alarm", "Rescheduling alarm to: $triggerTime")

                            AlarmUtils.scheduleAlarm(
                                this,
                                timeToAlarmForRescheduledAlarm,
                                if (remoteMessage.data["isActivityEnabled"] == "true") 1 else 0,
                                if (remoteMessage.data["isLocationEnabled"] == "true") 1 else 0,
                                remoteMessage.data["location"]!!,
                                if (remoteMessage.data["isWeatherEnabled"] == "true") 1 else 0,
                                remoteMessage.data["weatherTypes"]!!,
                            )
                        } else {
                            Log.d("Alarm", "Current alarm is still set for: $currentFormattedTime")
                        }

                    }

                    Log.d("Alarm", "Current alarm is set for: $currentFormattedTime")
                }
    
                Log.d("Alarm", "Trigger time received from server: $triggerTime")
            }
        }
    }
}