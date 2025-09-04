// is called 1 min before the alarm to check if the weather condition is met using the WeatherHelper.kt

package com.ccextractor.ultimate_alarm_clock

import android.content.Context
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable

class WeatherCheckWorker(private val appContext: Context, workerParams: WorkerParameters) :
    CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result {
        Log.d("WeatherCheckWorker", "Worker Started.")

        val alarmID = inputData.getString("ALARM_ID") ?: return Result.failure()
        val alarmRequestCode = inputData.getInt("ALARM_REQUEST_CODE", -1)
        val weatherTypesJSON = inputData.getString("WEATHER_TYPES") ?: "[]"
        val weatherConditionType = inputData.getInt("WEATHER_CONDITION_TYPE", 0)
        
        Log.d("WeatherCheckWorker", "Processing alarm ID: $alarmID, Condition: $weatherConditionType")
        
        try {
            val targetWeatherTypes = getWeatherConditionsFromString(weatherTypesJSON)
            val (shouldRing, reason) = checkWeatherCondition(targetWeatherTypes, weatherConditionType)

            Log.d("WeatherCheckWorker", "Verdict for $alarmID: Should Ring = $shouldRing, Reason: $reason")

            if (shouldRing == false) {
                // Save verdict for the phone's AlarmReceiver
                val prefs = appContext.getSharedPreferences("AlarmVerdict", Context.MODE_PRIVATE)
                with(prefs.edit()) {
                    putBoolean(alarmID, false).apply()
                }
                
                sendVerdictToWatch(alarmID, false, reason)
                
                val logdbHelper = LogDatabaseHelper(appContext)
                logdbHelper.insertLog(reason, status = LogDatabaseHelper.Status.WARNING, type = LogDatabaseHelper.LogType.NORMAL, hasRung = 0)
            }

            return Result.success()
        } catch (e: Exception) {
            Log.e("WeatherCheckWorker", "Error: ${e.message}", e)
            return Result.failure()
        }
    }

    private suspend fun checkWeatherCondition(targetWeatherTypes: String, conditionType: Int): Pair<Boolean, String> {
        val locationHelper = LocationHelper(appContext)
        val currentLocationString = locationHelper.getCurrentLocation()
        if (currentLocationString.isEmpty() || currentLocationString.contains("error")) {
            return Pair(true, "Pre-check (Weather): Could not get location, ringing as safeguard.")
        }
        
        return try {
            val coords = currentLocationString.split(",").map { it.toDouble() }
            val latitude = coords[0]
            val longitude = coords[1]
            val weatherHelper = WeatherHelper(appContext)
            val currentWeather = weatherHelper.fetchCurrentWeather(latitude, longitude)

            if (currentWeather == null) {
                return Pair(true, "Pre-check (Weather): Could not fetch weather, ringing as safeguard.")
            }
            val weatherMatches = targetWeatherTypes.contains(currentWeather)

            when (conditionType) {
                1 -> Pair(weatherMatches, if (weatherMatches) "Weather matches." else "Weather doesn't match, skipping.")
                2 -> Pair(!weatherMatches, if (!weatherMatches) "Weather does not match." else "Weather matches, skipping.")
                3 -> Pair(!weatherMatches, if (!weatherMatches) "Weather is different." else "Weather is not different, skipping.")
                4 -> Pair(weatherMatches, if (weatherMatches) "Weather is not different." else "Weather is different, skipping.")
                else -> Pair(true, "Unknown weather condition.")
            }
        } catch (e: Exception) {
            Pair(true, "Error during weather check, ringing as safeguard.")
        }
    }

    private fun getWeatherConditionsFromString(jsonString: String): String {
        val weatherMap = mapOf(0 to "sunny", 1 to "cloudy", 2 to "rainy", 3 to "windy", 4 to "stormy")
        return try {
            if (jsonString.isEmpty() || jsonString == "[]") return ""
            val indices = jsonString.removeSurrounding("[", "]").split(",").filter { it.trim().isNotEmpty() }.map { it.trim().toInt() }
            indices.mapNotNull { weatherMap[it] }.joinToString(",")
        } catch (e: Exception) { "" }
    }

private fun sendVerdictToWatch(alarmId: String, willRing: Boolean, reason: String) {
    val path = "/uac/pre_check_verdict"
    val putDataMapRequest = PutDataMapRequest.create(path)
    putDataMapRequest.dataMap.apply {
        putString("alarmID", alarmId)
        putBoolean("willRing", willRing)
        putString("reason", reason)
    }
    val putDataRequest = putDataMapRequest.asPutDataRequest().setUrgent()
    Wearable.getDataClient(appContext).putDataItem(putDataRequest)
        .addOnSuccessListener { Log.d("WeatherCheckWorker", "✅ Verdict sent to watch.") }
        .addOnFailureListener { Log.e("WeatherCheckWorker", "❌ Failed to send verdict.", it) }
}
}