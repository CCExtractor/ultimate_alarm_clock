package com.pravera.fl_location.service

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationSettings
import io.flutter.plugin.common.PluginRegistry

class LocationDataProviderManager(private val context: Context): PluginRegistry.ActivityResultListener {
	private val providers = mutableMapOf<Int, LocationDataProvider>()

	private fun buildLocationDataProvider() = LocationDataProvider(context)

	fun setActivity(activity: Activity?) {
		val iterator = providers.values.iterator()
		for (provider in iterator) {
			provider.setActivity(activity)
		}
	}

	fun getLocation(callback: LocationDataCallback, settings: LocationSettings): Int {
		val newLocationDataProvider = buildLocationDataProvider()
		val hashCode = newLocationDataProvider.hashCode()
		providers[hashCode] = newLocationDataProvider

		val newCallback = object : LocationDataCallback {
			override fun onUpdate(locationJson: String) {
				if (newLocationDataProvider.isRunningLocationUpdates) {
					stopLocationUpdates(hashCode)
					callback.onUpdate(locationJson)
				}
			}

			override fun onError(errorCode: ErrorCodes) {
				if (newLocationDataProvider.isRunningLocationUpdates) {
					stopLocationUpdates(hashCode)
					callback.onError(errorCode)
				}
			}
		}
		newLocationDataProvider.requestLocationUpdates(newCallback, settings)
		return hashCode
	}

	fun requestLocationUpdates(callback: LocationDataCallback, settings: LocationSettings): Int {
		val newLocationDataProvider = buildLocationDataProvider()
		val hashCode = newLocationDataProvider.hashCode()
		providers[hashCode] = newLocationDataProvider

		newLocationDataProvider.requestLocationUpdates(callback, settings)
		return hashCode
	}

	fun stopLocationUpdates(hashCode: Int) {
		providers[hashCode]?.let {
			it.stopLocationUpdates()
			providers.remove(hashCode)
		}
	}

	fun stopAllLocationUpdates() {
		val iterator = providers.values.iterator()
		for (provider in iterator) {
			provider.stopLocationUpdates()
		}
		providers.clear()
	}

	override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
		val iterator = providers.values.iterator()
		for (provider in iterator) {
			if (provider.onActivityResult(requestCode, resultCode)) {
				return true
			}
		}

		return false
	}
}
