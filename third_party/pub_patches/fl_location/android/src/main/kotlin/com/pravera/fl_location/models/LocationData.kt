package com.pravera.fl_location.models

import com.google.gson.annotations.SerializedName

data class LocationData(
	@SerializedName("latitude") val latitude: Double,
	@SerializedName("longitude") val longitude: Double,
	@SerializedName("accuracy") val accuracy: Double,
	@SerializedName("altitude") val altitude: Double,
	@SerializedName("heading") val heading: Double,
	@SerializedName("speed") val speed: Double,
	@SerializedName("speedAccuracy") val speedAccuracy: Double?,
	@SerializedName("millisecondsSinceEpoch") val millisecondsSinceEpoch: Double,
	@SerializedName("isMock") val isMock: Boolean?
)
