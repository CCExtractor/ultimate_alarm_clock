package com.ccextractor.ultimate_alarm_clock

import android.content.Context
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle

class LocationHelper(private val context: Context) {

    private val locationManager: LocationManager by lazy {
        context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    }

    fun getCurrentLocation(): String {
        try {
            val lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
            if (lastKnownLocation != null) {
                val latitude = lastKnownLocation.latitude
                val longitude = lastKnownLocation.longitude
                return "$latitude,$longitude"
            }
        } catch (e: SecurityException) {
            // Handle permission issues
            e.printStackTrace()
        }
        return "null" // Return null if location is unavailable
    }
}