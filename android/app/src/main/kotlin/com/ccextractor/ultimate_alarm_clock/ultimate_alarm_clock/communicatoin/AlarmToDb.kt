package com.ccextractor.ultimate_alarm_clock.communication

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.ccextractor.ultimate_alarm_clock.AlarmModel
import com.google.gson.Gson
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.time.LocalDate
import java.time.format.DateTimeFormatter

object ReceivedAlarmModelToDb {

    private const val CHANNEL = "com.ccextractor.alarm_channel"
    private const val TAG = "UAC_ReceivedAlarmModelToDb"

    fun sendToFlutter(flutterEngine: FlutterEngine, alarm: AlarmModel, isNewAlarm: Boolean) {
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        val currentDate = LocalDate.now()
        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
        val formattedDate = currentDate.format(formatter)
        val parsedDays =
                (alarm.days).split(",").mapNotNull {
                    it.trim().toIntOrNull()
                }

        val daysBooleanList =
                List(7) { dayIndex ->
                    parsedDays.contains(dayIndex + 1)
                }

        val weatherTypesIntList = alarm.weatherTypes.split(",")
                .mapNotNull { it.trim().toIntOrNull() }
                ?: emptyList()

        val alarmMap =
                mapOf(
                        "isarId" to alarm.id,
                        "alarmTime" to alarm.alarmTime,
                        "alarmID" to alarm.alarmId,
                        "ownerId" to "watch",
                        "ownerName" to "Watch",
                        "lastEditedUserId" to "watch",
                        "mutexLock" to false,
                        "days" to daysBooleanList,
                        "intervalToAlarm" to 0,
                        "minutesSinceMidnight" to alarm.minutesSinceMidnight,
                        "isSharedAlarmEnabled" to false,
                        
                        "isActivityEnabled" to (alarm.activityMonitor == 1),
                        "activityInterval" to alarm.activityInterval,
                        "activityConditionType" to alarm.activityConditionType,

                        "isLocationEnabled" to (alarm.isLocationEnabled == 1),
                        "locationConditionType" to alarm.locationConditionType,
                        "location" to if (alarm.location.isEmpty()) "0.0,0.0" else alarm.location,
                        
                        "isWeatherEnabled" to (alarm.isWeatherEnabled == 1),
                        "weatherConditionType" to alarm.weatherConditionType,
                        "weatherTypes" to weatherTypesIntList,

                        "isGuardian" to (alarm.isGuardian == 1),
                        "guardianTimer" to alarm.guardianTimer,
                        "guardian" to alarm.guardian.toString(), 
                        "isCall" to (alarm.isCall == 1),

                        "isMathsEnabled" to false,
                        "mathsDifficulty" to 0,
                        "numMathsQuestions" to 0,
                        "isShakeEnabled" to false,
                        "shakeTimes" to 0,
                        "isQrEnabled" to false,
                        "qrValue" to "",
                        "isPedometerEnabled" to false,
                        "numberOfSteps" to 0,
                        "mainAlarmTime" to alarm.alarmTime,
                        "label" to "Synced from Watch",
                        "isOneTime" to (alarm.isOneTime == 1),
                        "snoozeDuration" to 5,
                        "maxSnoozeCount" to 3,
                        "gradient" to 0,
                        "ringtoneName" to "Default",
                        "note" to "",
                        "deleteAfterGoesOff" to false,
                        "showMotivationalQuote" to false,
                        "volMax" to 1.0,
                        "volMin" to 0.5,
                        "activityMonitor" to alarm.activityMonitor,
                        "alarmDate" to formattedDate,
                        "profile" to "Default",
                        "isSunriseEnabled" to false,
                        "sunriseDuration" to 0,
                        "sunriseIntensity" to 0.5,
                        "sunriseColorScheme" to 0,
                        "sharedUserIds" to listOf<String>(),
                        "ringOn" to (alarm.ringOn == 1),
                        "isEnabled" to (alarm.isEnabled == 1),
                )

                val finalAlarmMap = mapOf(
                    "alarmMap" to alarmMap,
                    "isNewAlarm" to isNewAlarm
                )

        // val json = Gson().toJson(alarmMap)
        Log.d(TAG, "📤 Sending alarm to Flutter: $finalAlarmMap")

        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod("onWatchAlarmReceived", finalAlarmMap)
        }
    }
}