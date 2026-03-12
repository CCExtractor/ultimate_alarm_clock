package com.pravera.fl_location.service

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationPermission
import io.flutter.plugin.common.PluginRegistry

class LocationPermissionManager: PluginRegistry.RequestPermissionsResultListener {
	companion object {
		private const val LOCATION_PERMISSION_REQ_CODE = 109
		private const val BACKGROUND_LOCATION_PERMISSION_REQ_CODE = 110
		private const val PREV_PERMISSION_STATUS_PREFS_NAME = "PREV_PERMISSION_STATUS_PREFS"
	}

	private var activity: Activity? = null
	private var callback: LocationPermissionCallback? = null

	fun checkLocationPermission(activity: Activity): LocationPermission {
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M)
			return LocationPermission.ALWAYS

		val locationPermission = Manifest.permission.ACCESS_FINE_LOCATION
		if (!activity.isPermissionGranted(locationPermission)) {
			val prevPermissionStatus = activity.getPrevPermissionStatus(locationPermission)
			if (prevPermissionStatus != null &&
					prevPermissionStatus == LocationPermission.DENIED_FOREVER &&
					!activity.shouldShowRequestPermissionRationale(locationPermission))
				return LocationPermission.DENIED_FOREVER

			return LocationPermission.DENIED
		}

		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q)
			return LocationPermission.ALWAYS

		val backgroundLocationPermission = Manifest.permission.ACCESS_BACKGROUND_LOCATION
		if (activity.hasPermissionInManifest(backgroundLocationPermission) &&
				activity.isPermissionGranted(backgroundLocationPermission))
			return LocationPermission.ALWAYS

		return LocationPermission.WHILE_IN_USE
	}

	fun requestLocationPermission(activity: Activity, callback: LocationPermissionCallback) {
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
			callback.onResult(LocationPermission.ALWAYS)
			return
		}

		// The app has already requested location permission and is awaiting results.
		if (this.callback != null) return

		this.activity = activity
		this.callback = callback

		ActivityCompat.requestPermissions(
				activity,
				arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
				LOCATION_PERMISSION_REQ_CODE)
	}

	private fun requestBackgroundLocationPermission(activity: Activity) {
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return

		ActivityCompat.requestPermissions(
				activity,
				arrayOf(Manifest.permission.ACCESS_BACKGROUND_LOCATION),
				BACKGROUND_LOCATION_PERMISSION_REQ_CODE)
	}

	private fun Context.hasPermissionInManifest(permission: String): Boolean {
		val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
		val permissions = packageInfo.requestedPermissions

		return permissions?.any { perm -> perm == permission } ?: false
	}

	private fun Context.isPermissionGranted(permission: String): Boolean {
		return ContextCompat.checkSelfPermission(this, permission) ==
				PackageManager.PERMISSION_GRANTED
	}

	private fun Context.setPrevPermissionStatus(permission: String, status: LocationPermission) {
		val prefs = getSharedPreferences(
				PREV_PERMISSION_STATUS_PREFS_NAME, Context.MODE_PRIVATE) ?: return

		with (prefs.edit()) {
			putString(permission, status.toString())
			commit()
		}
	}

	private fun Context.getPrevPermissionStatus(permission: String): LocationPermission? {
		val prefs = getSharedPreferences(
				PREV_PERMISSION_STATUS_PREFS_NAME, Context.MODE_PRIVATE) ?: return null

		val value = prefs.getString(permission, null) ?: return null
		return LocationPermission.valueOf(value)
	}

	private fun disposeResources() {
		this.activity = null
		this.callback = null
	}

	@SuppressLint("InlinedApi")
	override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
		if (grantResults.isEmpty()) {
			callback?.onError(ErrorCodes.LOCATION_PERMISSION_REQUEST_CANCELLED)
			disposeResources()
			return false
		}

		val permission: String
		val permissionIndex: Int
		var permissionStatus = LocationPermission.DENIED

		when (requestCode) {
			LOCATION_PERMISSION_REQ_CODE -> {
				permission = Manifest.permission.ACCESS_FINE_LOCATION
				permissionIndex = permissions.indexOf(permission)

				if (permissionIndex >= 0 &&
						grantResults[permissionIndex] == PackageManager.PERMISSION_GRANTED) {
					permissionStatus = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q)
						LocationPermission.ALWAYS
					else
						LocationPermission.WHILE_IN_USE
				} else {
					if (activity?.shouldShowRequestPermissionRationale(permission) == false)
						permissionStatus = LocationPermission.DENIED_FOREVER
				}
			}
			BACKGROUND_LOCATION_PERMISSION_REQ_CODE -> {
				permission = Manifest.permission.ACCESS_BACKGROUND_LOCATION
				permissionIndex = permissions.indexOf(permission)

				permissionStatus = if (permissionIndex >= 0 &&
						grantResults[permissionIndex] == PackageManager.PERMISSION_GRANTED)
					LocationPermission.ALWAYS
				else
					LocationPermission.WHILE_IN_USE
			}
			else -> return false
		}

		activity?.setPrevPermissionStatus(permission, permissionStatus)

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q &&
				activity != null &&
				activity!!.hasPermissionInManifest(Manifest.permission.ACCESS_BACKGROUND_LOCATION) &&
				permission == Manifest.permission.ACCESS_FINE_LOCATION &&
				permissionStatus == LocationPermission.WHILE_IN_USE) {
			requestBackgroundLocationPermission(activity!!)
		} else {
			callback?.onResult(permissionStatus)
			disposeResources()
		}

		return true
	}
}
