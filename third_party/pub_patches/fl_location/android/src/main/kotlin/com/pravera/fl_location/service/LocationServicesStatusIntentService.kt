package com.pravera.fl_location.service

import android.content.Context
import android.content.Intent
import androidx.core.app.JobIntentService
import com.pravera.fl_location.utils.LocationServicesUtils

class LocationServicesStatusIntentService: JobIntentService() {
	companion object {
		private const val JOB_ID = 1000

		fun enqueueWork(context: Context, intent: Intent) {
			enqueueWork(context, LocationServicesStatusIntentService::class.java, JOB_ID, intent)
		}
	}

	override fun onHandleWork(intent: Intent) {
		val currValue = LocationServicesUtils.checkLocationServicesStatus(applicationContext).toString()

		val prefs = getSharedPreferences(
				LocationServicesStatusWatcher.LOCATION_SERVICES_STATUS_PREFS_NAME,
				Context.MODE_PRIVATE) ?: return

		val prevValue = prefs.getString(
				LocationServicesStatusWatcher.LOCATION_SERVICES_STATUS_PREFS_KEY, null)
		if (currValue == prevValue) return

		with(prefs.edit()) {
			putString(LocationServicesStatusWatcher.LOCATION_SERVICES_STATUS_PREFS_KEY, currValue)
			commit()
		}
	}
}
