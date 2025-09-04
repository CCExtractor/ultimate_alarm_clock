// checks the location condition 1 min before ringing the alarm
package com.ccextractor.ultimate_alarm_clock

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import kotlin.math.atan2
import kotlin.math.cos
import kotlin.math.pow
import kotlin.math.sin
import kotlin.math.sqrt
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable

class LocationCheckWorker(appContext: Context, workerParams: WorkerParameters) :
    CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result {
        Log.d("LocationCheckWorker", "Worker started.")

        val alarmID = inputData.getString("ALARM_ID") ?: return Result.failure()
        val targetLocation = inputData.getString("LOCATION") ?: return Result.failure()
        val locationConditionType = inputData.getInt("LOCATION_CONDITION_TYPE", 2)
        val isSharedAlarm = inputData.getBoolean("IS_SHARED_ALARM", false)
        val alarmRequestCode = inputData.getInt("ALARM_REQUEST_CODE", -1)

        if (alarmRequestCode == -1) {
             Log.e("LocationCheckWorker", "Invalid Request Code received.")
             return Result.failure()
        }

        Log.d("LocationCheckWorker", "Processing alarm ID: $alarmID, Condition: $locationConditionType")

        try {
            val locationHelper = LocationHelper(applicationContext)
            val currentLocationString = locationHelper.getCurrentLocation()
            if (currentLocationString.isEmpty() || currentLocationString == "error" || currentLocationString == "timeout") {
                Log.e("LocationCheckWorker", "Failed to get current location: $currentLocationString")
                return Result.success()
            }

            val currentCoords = currentLocationString.split(",").map { it.toDouble() }
            val targetCoords = targetLocation.split(",").map { it.toDouble() }
            val currentLocation = Location(currentCoords[0], currentCoords[1])
            val destinationLocation = Location(targetCoords[0], targetCoords[1])

            val distance = calculateDistance(currentLocation, destinationLocation)
            val isWithin500m = distance < 500.0
    
            var shouldRing: Boolean? = null
            var logMessage = ""

    when (locationConditionType) {
        1 -> { // Ring when AT
            shouldRing = isWithin500m
            logMessage = if (shouldRing) "Pre-check: User is AT. Alarm WILL ring." else "Pre-check: User is NOT AT. Alarm will be SKIPPED."
        }
        2 -> { // Cancel when AT
            shouldRing = !isWithin500m
            logMessage = if (!shouldRing) "Pre-check: User is AT. Alarm will be SKIPPED." else "Pre-check: User is NOT AT. Alarm WILL ring."
        }
        3 -> { // Ring when AWAY
            shouldRing = !isWithin500m
            logMessage = if (shouldRing) "Pre-check: User is AWAY. Alarm WILL ring." else "Pre-check: User is NOT AWAY. Alarm will be SKIPPED."
        }
        4 -> { // Cancel when AWAY
            shouldRing = isWithin500m
            logMessage = if (!shouldRing) "Pre-check: User is AWAY. Alarm will be SKIPPED." else "Pre-check: User is NOT AWAY. Alarm WILL ring."
        }
    }
            
            Log.d("LocationCheckWorker", logMessage)

    // Send the CORRECT verdict to the watch
        if (shouldRing != null) {
            sendVerdictToWatch(alarmID, shouldRing, logMessage)
            val prefs = applicationContext.getSharedPreferences("AlarmVerdict", Context.MODE_PRIVATE)
            with(prefs.edit()) {
                putBoolean(alarmID, shouldRing)
                apply()
            }
        }
                  return Result.success()
        } catch (e: Exception) {
            Log.e("LocationCheckWorker", "Error in LocationCheckWorker: ${e.message}", e)
            return Result.failure()
        }
    }

    private fun cancelAlarm(context: Context, requestCode: Int, isSharedAlarm: Boolean) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, AlarmReceiver::class.java).apply {
             putExtra("isSharedAlarm", isSharedAlarm)
        }
        
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )

        if (pendingIntent != null) {
            alarmManager.cancel(pendingIntent)
            pendingIntent.cancel()
            Log.i("LocationCheckWorker", "Successfully cancelled PendingIntent with request code $requestCode")
        } else {
            Log.w("LocationCheckWorker", "Could not find PendingIntent with request code $requestCode to cancel.")
        }
    }
    
    private fun sendVerdictToWatch(alarmId: String, willRing: Boolean, reason: String) {
        Log.d("LocationCheckWorker", "Attempting to send verdict to watch for alarm: $alarmId")
        val path = "/uac/pre_check_verdict"
        
        val putDataMapRequest = PutDataMapRequest.create(path)
        putDataMapRequest.dataMap.apply {
            putString("alarmID", alarmId)
            putBoolean("willRing", willRing)
            putString("reason", reason)
            putLong("timestamp", System.currentTimeMillis())
        }
    
        val putDataRequest = putDataMapRequest.asPutDataRequest().setUrgent()
    
        val dataClient = Wearable.getDataClient(applicationContext)
        dataClient.putDataItem(putDataRequest).apply {
            addOnSuccessListener {
                Log.d("LocationCheckWorker", "✅ Successfully sent verdict to watch: ${it.uri}")
            }
            addOnFailureListener {
                Log.e("LocationCheckWorker", "❌ Failed to send verdict to watch", it)
            }
        }
    }
    
    data class Location(val latitude: Double, val longitude: Double)

    private fun calculateDistance(current: Location, destination: Location): Double {
        val earthRadius = 6371.0
        val lat1 = Math.toRadians(current.latitude)
        val lon1 = Math.toRadians(current.longitude)
        val lat2 = Math.toRadians(destination.latitude)
        val lon2 = Math.toRadians(destination.longitude)
        val dlon = lon2 - lon1
        val dlat = lat2 - lat1
        val a = sin(dlat / 2).pow(2) + cos(lat1) * cos(lat2) * sin(dlon / 2).pow(2)
        val c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return earthRadius * c * 1000
    }
}