package com.pravera.fl_location.utils

import android.content.Context
import android.location.LocationManager
import com.pravera.fl_location.models.LocationServicesStatus

class LocationServicesUtils {
	companion object {
		fun checkLocationServicesStatus(context: Context): LocationServicesStatus {
			val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
			val isGpsProviderEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
			val isNetProviderEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)

			return if (isGpsProviderEnabled || isNetProviderEnabled)
				LocationServicesStatus.ENABLED
			else
				LocationServicesStatus.DISABLED
		}
	}
}
