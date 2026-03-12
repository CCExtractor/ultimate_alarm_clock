package com.pravera.fl_location.models

import com.google.android.gms.location.Priority

enum class LocationAccuracy {
	POWER_SAVE,
	LOW,
	BALANCED,
	HIGH,
	BEST,
	NAVIGATION;

	companion object {
		fun fromIndex(index: Int): LocationAccuracy {
			return when (index) {
				1 -> LOW
				2 -> BALANCED
				3 -> HIGH
				4 -> BEST
				5 -> NAVIGATION
				else -> POWER_SAVE
			}
		}
	}

	fun toPriority(): Int {
		return when (this) {
			POWER_SAVE -> Priority.PRIORITY_LOW_POWER
			LOW -> Priority.PRIORITY_LOW_POWER
			BALANCED -> Priority.PRIORITY_BALANCED_POWER_ACCURACY
			HIGH -> Priority.PRIORITY_HIGH_ACCURACY
			BEST -> Priority.PRIORITY_HIGH_ACCURACY
			NAVIGATION -> Priority.PRIORITY_HIGH_ACCURACY
		}
	}
}
