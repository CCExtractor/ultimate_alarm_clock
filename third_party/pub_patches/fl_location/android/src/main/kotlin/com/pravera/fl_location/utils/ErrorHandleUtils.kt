package com.pravera.fl_location.utils

import com.pravera.fl_location.errors.ErrorCodes
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class ErrorHandleUtils {
	companion object {
		fun handleMethodCallError(result: MethodChannel.Result, errorCode: ErrorCodes) {
			result.error(errorCode.toString(), errorCode.message(), null)
		}

		fun handleStreamError(events: EventChannel.EventSink, errorCode: ErrorCodes) {
			events.error(errorCode.toString(), errorCode.message(), null)
		}
	}
}
