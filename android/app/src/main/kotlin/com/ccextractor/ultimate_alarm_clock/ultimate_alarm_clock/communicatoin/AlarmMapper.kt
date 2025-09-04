package com.ccextractor.ultimate_alarm_clock.communication

import com.ccextractor.ultimate_alarm_clock.AlarmModel
import java.text.SimpleDateFormat
import java.util.*

fun FullAlarmDTO.toAlarmModel(): AlarmModel {
    val formatter = SimpleDateFormat("HH:mm", Locale.getDefault())
    val date = formatter.parse(time) ?: Date(0)
    val calendar = Calendar.getInstance().apply { time = date }

    val minutesSinceMidnight =
        calendar.get(Calendar.HOUR_OF_DAY) * 60 + calendar.get(Calendar.MINUTE)

    return AlarmModel(
        id = id,
        minutesSinceMidnight = minutesSinceMidnight,
        alarmTime = time,
        days = days.joinToString(","),
        isOneTime = isOneTime,
        isEnabled = isEnabled,
        ringOn = isEnabled,
        alarmId = uniqueSyncId, 
        isLocationEnabled = if (isLocationEnabled) 1 else 0,
        locationConditionType = locationConditionType,
        location = location,
        isWeatherEnabled = if (isWeatherEnabled) 1 else 0,
        weatherConditionType = weatherConditionType,
        weatherTypes = weatherTypes.joinToString(","),
        activityMonitor = if (isActivityEnabled) 1 else 0,
        activityInterval = activityInterval,
        activityConditionType = activityConditionType,
        isGuardian = if (isGuardian) 1 else 0,
        guardian = guardian.toIntOrNull() ?: 0,
        guardianTimer = guardianTimer,
        isCall = if (isCall) 1 else 0,

        alarmDate = ""
    )
}