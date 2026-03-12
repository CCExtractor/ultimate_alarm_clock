package com.pravera.fl_location

import android.app.Activity
import android.content.Context
import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationPermission
import com.pravera.fl_location.models.LocationSettings
import com.pravera.fl_location.service.LocationDataCallback
import com.pravera.fl_location.service.LocationPermissionCallback
import com.pravera.fl_location.service.ServiceProvider
import com.pravera.fl_location.utils.ErrorHandleUtils
import com.pravera.fl_location.utils.LocationServicesUtils
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** MethodCallHandlerImpl */
class MethodCallHandlerImpl(
		private val context: Context,
		private val serviceProvider: ServiceProvider):
		MethodChannel.MethodCallHandler, FlLocationPluginChannel {

	private lateinit var channel: MethodChannel
	private var activity: Activity? = null

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		val reqMethod = call.method
		if (reqMethod.contains("checkLocationPermission") ||
				reqMethod.contains("requestLocationPermission")) {
			if (activity == null) {
				ErrorHandleUtils.handleMethodCallError(result, ErrorCodes.ACTIVITY_NOT_ATTACHED)
				return
			}
		}

		when (reqMethod) {
			"checkLocationServicesStatus" -> {
				val checkResult = LocationServicesUtils.checkLocationServicesStatus(context)
				result.success(checkResult.ordinal)
			}
			"checkLocationPermission" -> {
				val checkResult = serviceProvider.getLocationPermissionManager()
						.checkLocationPermission(activity!!)
				result.success(checkResult.ordinal)
			}
			"requestLocationPermission" -> {
				val callback = object : LocationPermissionCallback {
					override fun onResult(locationPermission: LocationPermission) {
						result.success(locationPermission.ordinal)
					}

					override fun onError(errorCode: ErrorCodes) {
						ErrorHandleUtils.handleMethodCallError(result, errorCode)
					}
				}

				serviceProvider.getLocationPermissionManager()
						.requestLocationPermission(activity!!, callback)
			}
			"getLocation" -> {
				val callback = object : LocationDataCallback {
					override fun onUpdate(locationJson: String) {
						// 매니저에서 stopLocationUpdates 처리
						result.success(locationJson)
					}

					override fun onError(errorCode: ErrorCodes) {
						// 매니저에서 stopLocationUpdates 처리
						ErrorHandleUtils.handleMethodCallError(result, errorCode)
					}
				}

				val argsMap = call.arguments as? Map<*, *>
				val settings = LocationSettings.fromMap(argsMap)

				serviceProvider
						.getLocationDataProviderManager()
						.getLocation(callback, settings)
			}
			else -> result.notImplemented()
		}
	}

	override fun initChannel(messenger: BinaryMessenger) {
		channel = MethodChannel(messenger, "plugins.pravera.com/fl_location")
		channel.setMethodCallHandler(this)
	}

	override fun setActivity(activity: Activity?) {
		this.activity = activity
	}

	override fun disposeChannel() {
		if (::channel.isInitialized) {
			channel.setMethodCallHandler(null)
		}
	}
}
