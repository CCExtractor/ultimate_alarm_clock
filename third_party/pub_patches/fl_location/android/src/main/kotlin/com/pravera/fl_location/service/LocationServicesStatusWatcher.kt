package com.pravera.fl_location.service

import android.content.Context
import android.content.IntentFilter
import android.content.SharedPreferences
import android.location.LocationManager
import com.pravera.fl_location.models.LocationServicesStatus

class LocationServicesStatusWatcher: SharedPreferences.OnSharedPreferenceChangeListener {
	companion object {
		const val LOCATION_SERVICES_STATUS_PREFS_NAME = "LOCATION_SERVICES_STATUS_PREFS"
		const val LOCATION_SERVICES_STATUS_PREFS_KEY  = "LOCATION_SERVICES_STATUS"
	}

	private var onChangedCallback: ((LocationServicesStatus) -> Unit)? = null
	private var broadcastReceiver: LocationServicesStatusReceiver? = null

	fun start(context: Context, onChanged: ((LocationServicesStatus) -> Unit)) {
		if (this.onChangedCallback != null) stop(context)

		this.onChangedCallback = onChanged
		context.registerSharedPreferenceChangeListener()
		context.registerLocationServicesStatusIntentReceiver()
	}

	fun stop(context: Context) {
		this.onChangedCallback = null
		context.unregisterSharedPreferenceChangeListener()
		context.unregisterLocationServicesStatusIntentReceiver()
	}

	private fun Context.registerSharedPreferenceChangeListener() {
		val prefs = getSharedPreferences(
				LOCATION_SERVICES_STATUS_PREFS_NAME, Context.MODE_PRIVATE) ?: return

		with (prefs.edit()) {
			remove(LOCATION_SERVICES_STATUS_PREFS_KEY)
			commit()
		}

		prefs.registerOnSharedPreferenceChangeListener(this@LocationServicesStatusWatcher)
	}

	private fun Context.unregisterSharedPreferenceChangeListener() {
		val prefs = getSharedPreferences(
				LOCATION_SERVICES_STATUS_PREFS_NAME, Context.MODE_PRIVATE) ?: return
		prefs.unregisterOnSharedPreferenceChangeListener(this@LocationServicesStatusWatcher)
	}

	private fun Context.registerLocationServicesStatusIntentReceiver() {
		broadcastReceiver = LocationServicesStatusReceiver()
		registerReceiver(broadcastReceiver, IntentFilter(LocationManager.PROVIDERS_CHANGED_ACTION))
	}

	private fun Context.unregisterLocationServicesStatusIntentReceiver() {
		unregisterReceiver(broadcastReceiver)
		broadcastReceiver = null
	}

	override fun onSharedPreferenceChanged(sharedPreferences: SharedPreferences, key: String) {
		when (key) {
			LOCATION_SERVICES_STATUS_PREFS_KEY -> {
				val value = sharedPreferences.getString(key, null) ?: return
				val locationServicesStatus = LocationServicesStatus.valueOf(value)
				onChangedCallback?.invoke(locationServicesStatus)
			}
		}
	}
}
