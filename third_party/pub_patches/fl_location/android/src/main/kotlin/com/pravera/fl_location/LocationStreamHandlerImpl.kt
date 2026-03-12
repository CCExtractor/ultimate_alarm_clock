package com.pravera.fl_location

import android.app.Activity
import android.content.Context
import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationSettings
import com.pravera.fl_location.service.LocationDataCallback
import com.pravera.fl_location.service.ServiceProvider
import com.pravera.fl_location.utils.ErrorHandleUtils
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

/** LocationStreamHandlerImpl */
class LocationStreamHandlerImpl(
		private val context: Context,
		private val serviceProvider: ServiceProvider):
		EventChannel.StreamHandler, FlLocationPluginChannel {

	private lateinit var channel: EventChannel
	private var activity: Activity? = null
	private var locationDataProviderHashCode: Int? = null

	override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
		val callback = object : LocationDataCallback {
			override fun onUpdate(locationJson: String) {
				events.success(locationJson)
			}

			override fun onError(errorCode: ErrorCodes) {
				ErrorHandleUtils.handleStreamError(events, errorCode)
			}
		}

		val argsMap = arguments as? Map<*, *>
		val settings = LocationSettings.fromMap(argsMap)

		locationDataProviderHashCode = serviceProvider
				.getLocationDataProviderManager()
				.requestLocationUpdates(callback, settings)
	}

	override fun onCancel(arguments: Any?) {
		if (locationDataProviderHashCode == null) return

		serviceProvider
				.getLocationDataProviderManager()
				.stopLocationUpdates(locationDataProviderHashCode!!)
	}

	override fun initChannel(messenger: BinaryMessenger) {
		channel = EventChannel(messenger, "plugins.pravera.com/fl_location/updates")
		channel.setStreamHandler(this)
	}

	override fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	override fun disposeChannel() {
		if (::channel.isInitialized) {
			channel.setStreamHandler(null)
		}
	}
}
