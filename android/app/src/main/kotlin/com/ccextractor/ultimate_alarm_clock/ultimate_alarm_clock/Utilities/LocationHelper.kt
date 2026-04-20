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
            // Try multiple location providers in order of preference
            val providers = listOf(
                LocationManager.GPS_PROVIDER,
                LocationManager.NETWORK_PROVIDER,
                LocationManager.PASSIVE_PROVIDER
            )
            
            for (provider in providers) {
                if (locationManager.isProviderEnabled(provider)) {
                    val lastKnownLocation = locationManager.getLastKnownLocation(provider)
                    if (lastKnownLocation != null) {
                        val latitude = lastKnownLocation.latitude
                        val longitude = lastKnownLocation.longitude
                        android.util.Log.d("LocationHelper", "Got location from $provider: $latitude,$longitude")
                        return "$latitude,$longitude"
                    } else {
                        android.util.Log.d("LocationHelper", "No last known location from $provider")
                    }
                } else {
                    android.util.Log.d("LocationHelper", "Provider $provider is not enabled")
                }
            }
            
            // If no last known location is available, try to get the best available location from all providers
            val allProviders = locationManager.getProviders(true)
            android.util.Log.d("LocationHelper", "Available providers: $allProviders")
            
            var bestLocation: Location? = null
            for (provider in allProviders) {
                try {
                    val location = locationManager.getLastKnownLocation(provider)
                    if (location != null) {
                        if (bestLocation == null || location.accuracy < bestLocation.accuracy) {
                            bestLocation = location
                            android.util.Log.d("LocationHelper", "Found better location from $provider: accuracy=${location.accuracy}")
                        }
                    }
                } catch (e: SecurityException) {
                    android.util.Log.w("LocationHelper", "No permission for provider $provider")
                }
            }
            
            if (bestLocation != null) {
                val latitude = bestLocation.latitude
                val longitude = bestLocation.longitude
                android.util.Log.d("LocationHelper", "Using best available location: $latitude,$longitude (accuracy=${bestLocation.accuracy}m)")
                return "$latitude,$longitude"
            }
            
        } catch (e: SecurityException) {
            android.util.Log.e("LocationHelper", "Security exception getting location: ${e.message}")
            e.printStackTrace()
        } catch (e: Exception) {
            android.util.Log.e("LocationHelper", "Error getting location: ${e.message}")
            e.printStackTrace()
        }
        
        android.util.Log.w("LocationHelper", "No location available from any provider")
        return "null" // Return null if location is unavailable
    }
}