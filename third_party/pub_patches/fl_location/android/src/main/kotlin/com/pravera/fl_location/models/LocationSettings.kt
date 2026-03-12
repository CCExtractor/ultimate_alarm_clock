package com.pravera.fl_location.models

data class LocationSettings(
	val accuracy: LocationAccuracy,
	val interval: Long? = null,
	val distanceFilter: Float? = null
) {
	companion object {
		fun fromMap(map: Map<*, *>?): LocationSettings {
			val accuracy = map?.get("accuracy").toString().toIntOrNull() ?: LocationAccuracy.BEST.ordinal
			val interval = map?.get("interval").toString().toLongOrNull()
			val distanceFilter = map?.get("distanceFilter").toString().toFloatOrNull()

			return LocationSettings(
				accuracy = LocationAccuracy.fromIndex(accuracy),
				interval = interval,
				distanceFilter = distanceFilter
			)
		}
	}
}
