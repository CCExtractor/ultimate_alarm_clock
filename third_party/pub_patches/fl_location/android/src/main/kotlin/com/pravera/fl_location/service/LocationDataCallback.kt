package com.pravera.fl_location.service

import com.pravera.fl_location.errors.ErrorCodes

interface LocationDataCallback {
	fun onUpdate(locationJson: String)
	fun onError(errorCode: ErrorCodes)
}
