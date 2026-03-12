package com.pravera.fl_location

import android.app.Activity
import android.content.Context
import com.pravera.fl_location.service.ServiceProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

/** LocationServicesStatusStreamHandlerImpl */
class LocationServicesStatusStreamHandlerImpl(
		private val context: Context,
		private val serviceProvider: ServiceProvider):
		EventChannel.StreamHandler, FlLocationPluginChannel {

	private lateinit var channel: EventChannel
	private var activity: Activity? = null

	override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
		serviceProvider.getLocationServicesStatusWatcher()
				.start(context, onChanged = { events?.success(it.ordinal) })
	}

	override fun onCancel(arguments: Any?) {
		serviceProvider.getLocationServicesStatusWatcher().stop(context)
	}

	override fun initChannel(messenger: BinaryMessenger) {
		channel = EventChannel(messenger,
				"plugins.pravera.com/fl_location/location_services_status")
		channel.setStreamHandler(this)
	}

	override fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	override fun disposeChannel() {
		if (::channel.isInitialized)
			channel.setStreamHandler(null)
	}
}
