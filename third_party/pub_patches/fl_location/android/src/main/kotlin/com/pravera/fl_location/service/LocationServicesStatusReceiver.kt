package com.pravera.fl_location.service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.location.LocationManager

class LocationServicesStatusReceiver: BroadcastReceiver() {
	override fun onReceive(context: Context, intent: Intent) {
		if (intent.action != LocationManager.PROVIDERS_CHANGED_ACTION) return

		intent.setClass(context, LocationServicesStatusIntentService::class.java)
		LocationServicesStatusIntentService.enqueueWork(context, intent)
	}
}
