package com.ccextractor.ultimate_alarm_clock

import android.annotation.SuppressLint
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import java.text.SimpleDateFormat
import java.time.Duration
import java.time.LocalTime
import java.util.*
import java.util.concurrent.TimeUnit


fun getLatestAlarm(db: SQLiteDatabase, wantNextAlarm: Boolean, profile: String,context: Context): Map<String, *>? {
    val now = Calendar.getInstance()
    var nowInMinutes = now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE)
    var nowInSeconds = nowInMinutes * 60 + now.get(Calendar.SECOND)

    if (wantNextAlarm) {
        nowInMinutes++
    }
    val currentDay = Calendar.getInstance().get(Calendar.DAY_OF_WEEK) - 1
    val currentTime = SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date())
    Log.d("d", "cd ${currentDay}")

    // Initialize DatabaseHelper
    val logdbHelper = LogDatabaseHelper(context)

    val cursor = db.rawQuery(
        """
        SELECT * FROM alarms
        WHERE isEnabled = 1 
        AND (profile = ? OR ringOn = 1)
        """, arrayOf(profile)
    )
    var selectedAlarm = null
    Log.d("Alarm", cursor.count.toString())

    return if (cursor.count > 0) {
        // Parse the cursor into an AlarmModel object
        cursor.moveToFirst()
        var alarm = AlarmModel.fromCursor(cursor)
        var intervaltoAlarm = Long.MAX_VALUE
        var setAlarm: AlarmModel? = null
        do {
            alarm = AlarmModel.fromCursor(cursor)
            if (alarm.ringOn == 0) {

                var dayfromToday = 0
                var timeDif = getTimeDifferenceInMillis(alarm.alarmTime)
                Log.d("d", "timeDiff ${timeDif}")

                if ((alarm.days[currentDay] == '1' || alarm.days == "0000000") && timeDif > -1L) {
                    if (timeDif < intervaltoAlarm) {
                        intervaltoAlarm = timeDif
                        setAlarm = alarm
                    }
                } else {
                    dayfromToday = getDaysUntilNextAlarm(alarm.days, currentDay)
                    if (dayfromToday == 0) {

                        if (alarm.days == "0000000") {

                            var timeDif =
                                getTimeDifferenceFromMidnight(alarm.alarmTime) + getMillisecondsUntilMidnight()
                            if (timeDif < intervaltoAlarm && timeDif > -1L) {
                                intervaltoAlarm = timeDif
                                setAlarm = alarm
                            }
                        } else {

                            var timeDif =
                                getTimeDifferenceFromMidnight(alarm.alarmTime) + getMillisecondsUntilMidnight() + 86400000 * 6
                            if (timeDif < intervaltoAlarm && timeDif > -1L) {
                                intervaltoAlarm = timeDif
                                setAlarm = alarm
                            }
                        }
                    } else if (dayfromToday == 1) {
                        var timeDif =
                            getTimeDifferenceFromMidnight(alarm.alarmTime) + getMillisecondsUntilMidnight()
                        Log.d("d", "timeDiff ${timeDif}")

                        if (timeDif < intervaltoAlarm && timeDif > -1L) {
                            intervaltoAlarm = timeDif
                            setAlarm = alarm
                        }
                    } else {
                        var timeDif =
                            getTimeDifferenceFromMidnight(alarm.alarmTime) + getMillisecondsUntilMidnight() + 86400000 * (dayfromToday - 1)
                        if (timeDif < intervaltoAlarm && timeDif > -1L) {
                            intervaltoAlarm = timeDif
                            setAlarm = alarm
                        }
                    }

                }
            } else {
                val dayfromToday = getDaysFromCurrentDate(alarm.alarmDate)
                if (dayfromToday == 0L) {
                    var timeDif = getTimeDifferenceInMillis(alarm.alarmTime)
                    if (alarm.days[currentDay] == '1' && timeDif > -1L) {
                        if (timeDif < intervaltoAlarm) {
                            intervaltoAlarm = timeDif
                            setAlarm = alarm
                        }
                    }
                } else if (dayfromToday == 1L) {
                    var timeDif =
                        getTimeDifferenceFromMidnight(alarm.alarmTime) + getMillisecondsUntilMidnight()
                    if (timeDif < intervaltoAlarm) {
                        intervaltoAlarm = timeDif
                        setAlarm = alarm
                    }
                } else {

                    var timeDif =
                        getTimeDifferenceFromMidnight(alarm.alarmTime) + getMillisecondsUntilMidnight() + 86400000 * (dayfromToday - 1)
                    if (timeDif < intervaltoAlarm && timeDif > -1L) {
                        intervaltoAlarm = timeDif
                        setAlarm = alarm
                    }
                }

            }

        } while (cursor.moveToNext())
        cursor.close()

        if (setAlarm != null) {
            Log.d("Alarm", intervaltoAlarm.toString())

            // Add the latest alarm details to the LOG table
            val logDetails = """
                Alarm Scheduled for ${setAlarm.alarmTime}
            """.trimIndent()
            logdbHelper.insertLog(
                "Alarm Scheduled for ${setAlarm.alarmTime}",
                LogDatabaseHelper.Status.SUCCESS,
                LogDatabaseHelper.LogType.DEV
            )

            // Return the latest alarm details
            val a = mapOf(
                "interval" to intervaltoAlarm,
                "isActivity" to setAlarm.activityMonitor,
                "isLocation" to setAlarm.isLocationEnabled,
                "location" to setAlarm.location,
                "isWeather" to setAlarm.isWeatherEnabled,
                "weatherTypes" to setAlarm.weatherTypes,
                "alarmID" to setAlarm.alarmId
            )
            Log.d("s", "sdsd ${a}")
            return a
        }
        null
    } else {
        null
    }
}

fun getTimeDifferenceInMillis(timeString: String): Long {
    // Define the time format
    val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())

    // Get the current time
    val currentTime = Calendar.getInstance()

    // Parse the received time string into a Date object
    val receivedTime: Date? = timeFormat.parse(timeString)

    // Create a Calendar object for the received time
    val receivedCalendar = Calendar.getInstance().apply {
        time = receivedTime!!
        set(Calendar.YEAR, currentTime.get(Calendar.YEAR))  // Set the same day as today
        set(Calendar.MONTH, currentTime.get(Calendar.MONTH))
        set(Calendar.DAY_OF_MONTH, currentTime.get(Calendar.DAY_OF_MONTH))
    }

    // Compare the received time with the current time
    return if (receivedCalendar.after(currentTime)) {
        receivedCalendar.timeInMillis - currentTime.timeInMillis
    } else {
        -1  // Return -1 if the received time is less than or equal to current time
    }
}


fun getDaysUntilNextAlarm(alarmDays: String, currentDay: Int): Int {
    // Validate that the alarmDays string has exactly 7 characters
    if (alarmDays.length != 7) {
        throw IllegalArgumentException("The alarmDays string must have exactly 7 characters")
    }

    // Convert the string into a list of integers (0 or 1) representing the alarm status for each day
    val alarms = alarmDays.map { it.toString().toInt() }

    // Loop through the days starting from the current day to find the next "on" (1)
    for (i in 0 until 7) {
        val dayToCheck = (currentDay + i) % 7  // Wrap around the week using modulo
        if (alarms[dayToCheck] == 1) {
            return i  // Return the number of days until the next alarm is on
        }
    }

    // If no alarms are on in the week, return -1
    return 0
}

fun getTimeDifferenceFromMidnight(timeString: String): Long {
    // Define the time format
    val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())

    // Parse the received time string into a Date object
    val receivedTime: Date? = timeFormat.parse(timeString)

    // Get the reference time for midnight ("00:00")
    val midnight = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, 0)
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)
    }

    // Create a Calendar object for the received time
    val receivedCalendar = Calendar.getInstance().apply {
        time = receivedTime!!
        set(Calendar.YEAR, midnight.get(Calendar.YEAR))  // Keep the same day (midnight)
        set(Calendar.MONTH, midnight.get(Calendar.MONTH))
        set(Calendar.DAY_OF_MONTH, midnight.get(Calendar.DAY_OF_MONTH))
    }

    // Return the difference between the received time and midnight in milliseconds
    return receivedCalendar.timeInMillis - midnight.timeInMillis
}

fun getMillisecondsUntilMidnight(): Long {
    // Get the current time
    val currentTime = Calendar.getInstance()

    // Create a Calendar object for the next midnight
    val nextMidnight = Calendar.getInstance().apply {
        add(Calendar.DAY_OF_MONTH, 1)  // Move to the next day
        set(Calendar.HOUR_OF_DAY, 0)   // Set the time to midnight
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)
    }

    // Calculate the difference in milliseconds
    return nextMidnight.timeInMillis - currentTime.timeInMillis
}

fun getDaysFromCurrentDate(dateString: String): Long {
    // Define the date format
    val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())

    // Parse the received date string into a Date object
    val receivedDate: Date? = dateFormat.parse(dateString)

    // Get the current date
    val currentDate = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, 0)
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)
    }.time

    // Ensure received date is not null
    if (receivedDate == null) {
        throw IllegalArgumentException("Invalid date format")
    }

    // Calculate the difference in milliseconds between the two dates
    val differenceInMillis = receivedDate.time - currentDate.time

    // If the received date is in the past, return -1
    if (differenceInMillis < 0) {
        return -1
    }

    // Convert the difference in milliseconds to days
    return TimeUnit.MILLISECONDS.toDays(differenceInMillis)
}


data class AlarmModel(
    val id: Int,
    val minutesSinceMidnight: Int,
    val alarmTime: String,
    val days: String,
    val isOneTime: Int,
    val activityMonitor: Int,
    val isWeatherEnabled: Int,
    val weatherTypes: String,
    val isLocationEnabled: Int,
    val location: String,
    val alarmDate: String,
    val alarmId: String,
    val ringOn: Int
) {
    companion object {
        @SuppressLint("Range")
        fun fromCursor(cursor: Cursor): AlarmModel {
            val id = cursor.getInt(cursor.getColumnIndex("id"))
            val minutesSinceMidnight = cursor.getInt(cursor.getColumnIndex("minutesSinceMidnight"))
            val alarmTime = cursor.getString(cursor.getColumnIndex("alarmTime"))
            val days = cursor.getString(cursor.getColumnIndex("days"))
            val isOneTime = cursor.getInt(cursor.getColumnIndex("isOneTime"))
            val activityMonitor = cursor.getInt(cursor.getColumnIndex("activityMonitor"))
            val isWeatherEnabled = cursor.getInt(cursor.getColumnIndex("isWeatherEnabled"))
            val weatherTypes = cursor.getString(cursor.getColumnIndex("weatherTypes"))
            val isLocationEnabled = cursor.getInt(cursor.getColumnIndex("isLocationEnabled"))
            val location = cursor.getString(cursor.getColumnIndex("location"))
            val alarmDate = cursor.getString(cursor.getColumnIndex("alarmDate"))
            val alarmId = cursor.getString(cursor.getColumnIndex("alarmID"))
            val ringOn = cursor.getInt(cursor.getColumnIndex("ringOn"))
            return AlarmModel(
                id,
                minutesSinceMidnight,
                alarmTime,
                days,
                isOneTime,
                activityMonitor,
                isWeatherEnabled,
                weatherTypes,
                isLocationEnabled,
                location,
                alarmDate,
                alarmId,
                ringOn
            )
        }
    }
}