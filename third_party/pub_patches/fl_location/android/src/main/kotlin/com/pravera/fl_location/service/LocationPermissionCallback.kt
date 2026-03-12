package com.pravera.fl_location.service

import com.pravera.fl_location.errors.ErrorCodes
import com.pravera.fl_location.models.LocationPermission

interface LocationPermissionCallback {
	fun onResult(locationPermission: LocationPermission)
	fun onError(errorCode: ErrorCodes)
}
