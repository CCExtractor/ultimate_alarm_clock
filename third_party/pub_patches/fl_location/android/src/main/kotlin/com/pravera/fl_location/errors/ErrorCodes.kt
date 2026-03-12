package com.pravera.fl_location.errors

enum class ErrorCodes {
	ACTIVITY_NOT_ATTACHED,
	LOCATION_PERMISSION_REQUEST_CANCELLED,
	LOCATION_SETTINGS_CHANGE_FAILED,
	LOCATION_SERVICES_NOT_AVAILABLE,
	LOCATION_DATA_ENCODING_FAILED;

	fun message(): String {
		return when (this) {
			ACTIVITY_NOT_ATTACHED ->
				"The function to use Activity is not available because Activity is not attached to FlutterEngine."
			LOCATION_PERMISSION_REQUEST_CANCELLED ->
				"The dialog was closed or the request was canceled during a runtime location permission request."
			LOCATION_SETTINGS_CHANGE_FAILED ->
				"The request to change location settings failed."
			LOCATION_SERVICES_NOT_AVAILABLE ->
				"Location services are not available."
			LOCATION_DATA_ENCODING_FAILED ->
				"Failed to encode location data in JSON format."
		}
	}
}
