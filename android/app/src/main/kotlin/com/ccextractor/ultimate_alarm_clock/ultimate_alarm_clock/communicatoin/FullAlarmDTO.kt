package com.ccextractor.ultimate_alarm_clock.communication

data class FullAlarmDTO(
    val id: Int,
    val time: String,
    val days: List<Int>,
    val uniqueSyncId: String,
    val isEnabled: Int,
    val isOneTime: Int,
    val fromWatch: Boolean,
    val isLocationEnabled: Boolean,
    val locationConditionType: Int,
    val location: String,
    val isWeatherEnabled: Boolean,
    val weatherConditionType: Int,
    val weatherTypes: List<Int>,
    val isActivityEnabled: Boolean,
    val activityInterval: Int,
    val activityConditionType: Int,
    val isGuardian: Boolean,
    val guardian: String,
    val guardianTimer: Int,
    val isCall: Boolean
)