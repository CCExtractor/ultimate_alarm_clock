package com.ccextractor.ultimate_alarm_clock.communication

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.*
import com.google.gson.Gson
import com.ccextractor.ultimate_alarm_clock.AlarmModel
// import com.ccextractor.ultimate_alarm_clock.communication.MinimalAlarmDTO

object PhoneSender {
    private const val TAG = "UAC_PhoneListSender"
//    private const val PATH_ALARM_LIST_SYNC =  "/uac_phone_alarm_list_sync";
//    private const val PATH_ACTION = "/uac_alarm_sync/action"
    private const val PATH_ACTION_PHONE_TO_WATCH = "/uac_phone_to_watch/action"
    private val PATH_ALARM_PHONE_TO_WATCH = "/uac_phone_to_watch/alarm"

private fun anyToBoolean(value: Any?): Boolean {
    return when (value) {
        is Boolean -> value
        is Number -> value.toInt() == 1
        else -> false
    }
}

fun sendAlarmToWatch(context: Context, alarmDataFromFlutter: Map<String, Any>) {
    val watchDataMap = mutableMapOf<String, Any?>()

    watchDataMap["uniqueSyncId"] = alarmDataFromFlutter["alarmID"]
    watchDataMap["id"] = alarmDataFromFlutter["isarId"]
    watchDataMap["time"] = alarmDataFromFlutter["alarmTime"]
    watchDataMap["isOneTime"] = if (anyToBoolean(alarmDataFromFlutter["isOneTime"])) 1 else 0
    watchDataMap["isEnabled"] = if (anyToBoolean(alarmDataFromFlutter["isEnabled"])) 1 else 0

    val daysBoolList = alarmDataFromFlutter["days"] as? List<Boolean> ?: emptyList()
    val daysIntList = daysBoolList.mapIndexedNotNull { index, isSet -> if (isSet) index + 1 else null }
    watchDataMap["days"] = daysIntList

    watchDataMap["isLocationEnabled"] = anyToBoolean(alarmDataFromFlutter["isLocationEnabled"])
    watchDataMap["location"] = alarmDataFromFlutter["location"]
    watchDataMap["locationConditionType"] = alarmDataFromFlutter["locationConditionType"]

    watchDataMap["isWeatherEnabled"] = anyToBoolean(alarmDataFromFlutter["isWeatherEnabled"])
    watchDataMap["weatherTypes"] = alarmDataFromFlutter["weatherTypes"]
    watchDataMap["weatherConditionType"] = alarmDataFromFlutter["weatherConditionType"]
    
    watchDataMap["isActivityEnabled"] = anyToBoolean(alarmDataFromFlutter["isActivityEnabled"])
    watchDataMap["activityInterval"] = alarmDataFromFlutter["activityInterval"]
    watchDataMap["activityConditionType"] = alarmDataFromFlutter["activityConditionType"]

    watchDataMap["isGuardian"] = anyToBoolean(alarmDataFromFlutter["isGuardian"])
    watchDataMap["guardian"] = alarmDataFromFlutter["guardian"]
    watchDataMap["guardianTimer"] = alarmDataFromFlutter["guardianTimer"]
    watchDataMap["isCall"] = anyToBoolean(alarmDataFromFlutter["isCall"])

    val alarmJson = Gson().toJson(watchDataMap)
    Log.d(TAG, "Sending transformed alarm to watch: $alarmJson")

    val putDataMapRequest = PutDataMapRequest.create(PATH_ALARM_PHONE_TO_WATCH)
    putDataMapRequest.dataMap.putString("alarm_json", alarmJson)
    putDataMapRequest.dataMap.putLong("timestamp", System.currentTimeMillis())

    val request = putDataMapRequest.asPutDataRequest().setUrgent()

    Wearable.getDataClient(context).putDataItem(request)
        .addOnSuccessListener {
            Log.d(TAG, "Alarm sent to watch successfully")
        }
        .addOnFailureListener {
            Log.e(TAG, "Failed to send alarm to watch", it)
        }
}

    fun sendActionToWatch(context: Context, action: String, alarmId: String) {
        Log.d(TAG, "Attempting to send action '$action' for alarm ID $alarmId to watch")

        try {
            val dataMap = PutDataMapRequest.create(PATH_ACTION_PHONE_TO_WATCH)
            dataMap.dataMap.putString("action", action)
            dataMap.dataMap.putString("alarm_id", alarmId)
            dataMap.dataMap.putLong("timestamp", System.currentTimeMillis())
            
            val request = dataMap.asPutDataRequest().setUrgent()

            Wearable.getDataClient(context).putDataItem(request)
                .addOnSuccessListener {
                    Log.d(TAG, "✅ Successfully sent action '$action' to watch with PATH -> $PATH_ACTION_PHONE_TO_WATCH")
                }
                .addOnFailureListener { e ->
                    Log.e(TAG, "❌ Failed to send action to watch.", e)
                }
        } catch (e: Exception) {
            Log.e(TAG, "❌ Exception while sending action to watch.", e)
        }
    }
}