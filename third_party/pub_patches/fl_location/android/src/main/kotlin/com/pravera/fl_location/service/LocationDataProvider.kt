package com.pravera.fl_location.service

import android.app.Activity
import android.content.Context
import android.content.IntentSender
import android.os.Build
import android.os.Looper
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.*
import com.google.gson.Gson
import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationData
import com.pravera.fl_location.models.LocationSettings

class LocationDataProvider(private val context: Context) {
	companion object {
		private const val DEFAULT_LOCATION_INTERVAL = 5000L
		private const val REQUEST_CHECK_SETTINGS = 0x1
	}

	private val jsonEncoder = Gson()
	private val locationProvider = LocationServices.getFusedLocationProviderClient(context)

	private var activity: Activity? = null
	private var callback: LocationDataCallback? = null
	private var settings: LocationSettings? = null

	private var locationCallback: LocationCallback? = null
	private var locationRequest: LocationRequest? = null

	var isRunningLocationUpdates = false
		private set

	fun onActivityResult(requestCode: Int, resultCode: Int): Boolean {
		if (requestCode == REQUEST_CHECK_SETTINGS) {
			if (resultCode == Activity.RESULT_OK) {
				// The stopLocationUpdates function has already been called.
				if (callback == null) {
					return false
				}
				startLocationUpdates()
				return true
			} else {
				callback?.onError(ErrorCodes.LOCATION_SERVICES_NOT_AVAILABLE)
			}
		}

		return false
	}

	fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	fun requestLocationUpdates(callback: LocationDataCallback, settings: LocationSettings) {
		stopLocationUpdates()
		this.callback = callback
		this.settings = settings
		this.locationCallback = createLocationCallback(callback)
		this.locationRequest = createLocationRequest(settings)
		checkLocationSettingsAndStartLocationUpdates()
	}

	private fun checkLocationSettingsAndStartLocationUpdates() {
		val settingsRequest = LocationSettingsRequest.Builder()
			.addLocationRequest(locationRequest!!)
			.build()

		val settingsClient = LocationServices.getSettingsClient(context)
		settingsClient.checkLocationSettings(settingsRequest)
				.addOnSuccessListener {
					startLocationUpdates()
				}
				.addOnFailureListener {
					val statusCode: Int
					if (it is ResolvableApiException) {
						statusCode = it.statusCode

						// Location settings are not satisfied.
						// But could be fixed by showing the user a dialog.
						if (statusCode == LocationSettingsStatusCodes.RESOLUTION_REQUIRED) {
							try {
								if (activity == null) {
									callback?.onError(ErrorCodes.LOCATION_SETTINGS_CHANGE_FAILED)
									return@addOnFailureListener
								}

								it.startResolutionForResult(activity!!, REQUEST_CHECK_SETTINGS)
							} catch (sendEx: IntentSender.SendIntentException) {
								callback?.onError(ErrorCodes.LOCATION_SETTINGS_CHANGE_FAILED)
							}
						} else {
							callback?.onError(ErrorCodes.LOCATION_SERVICES_NOT_AVAILABLE)
						}
					} else if (it is ApiException) {
						statusCode = it.statusCode

						// Location settings are not satisfied.
						// However, we have no way to fix the settings so we won't show the dialog.
						if (statusCode == LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE) {
							startLocationUpdates()
						} else {
							callback?.onError(ErrorCodes.LOCATION_SERVICES_NOT_AVAILABLE)
						}
					} else {
						callback?.onError(ErrorCodes.LOCATION_SERVICES_NOT_AVAILABLE)
					}
				}
	}

	private fun startLocationUpdates() {
		if (locationRequest == null || locationCallback == null) return

		isRunningLocationUpdates = true
		locationProvider.requestLocationUpdates(
				locationRequest!!, locationCallback!!, Looper.getMainLooper())
	}

	fun stopLocationUpdates() {
		if (locationCallback != null) {
			isRunningLocationUpdates = false
			locationProvider.removeLocationUpdates(locationCallback!!)
		}
		this.callback = null
		this.settings = null
		this.locationCallback = null
		this.locationRequest = null
	}

	private fun createLocationCallback(callback: LocationDataCallback): LocationCallback {
		return object : LocationCallback() {
			override fun onLocationResult(locationResult: LocationResult) {
				val location = locationResult.lastLocation ?: return

				var speedAccuracy: Double? = null
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
					speedAccuracy = location.speedAccuracyMetersPerSecond.toDouble()
				}

				var isMock: Boolean? = null
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
					isMock = location.isMock
				}

				val locationData = LocationData(
					latitude = location.latitude,
					longitude = location.longitude,
					accuracy = location.accuracy.toDouble(),
					altitude = location.altitude,
					heading = location.bearing.toDouble(),
					speed = location.speed.toDouble(),
					speedAccuracy = speedAccuracy,
					millisecondsSinceEpoch = location.time.toDouble(),
					isMock = isMock
				)

				try {
					callback.onUpdate(jsonEncoder.toJson(locationData))
				} catch (ex: Exception) {
					callback.onError(ErrorCodes.LOCATION_DATA_ENCODING_FAILED)
				}
			}
		}
	}

	private fun createLocationRequest(settings: LocationSettings): LocationRequest {
		val accuracy = settings.accuracy.toPriority()
		val interval = settings.interval ?: DEFAULT_LOCATION_INTERVAL
		val distanceFilter = settings.distanceFilter ?: 0F

		return LocationRequest.Builder(accuracy, interval).apply {
			setMinUpdateDistanceMeters(distanceFilter)
			setMinUpdateIntervalMillis(interval)
		}.build()
	}
}
