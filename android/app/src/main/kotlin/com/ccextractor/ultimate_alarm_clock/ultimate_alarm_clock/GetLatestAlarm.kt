package com.ccextractor.ultimate_alarm_clock

import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.util.Log
import java.text.SimpleDateFormat
import java.time.Duration
import java.time.LocalTime
import java.util.*


fun getLatestAlarm(db: SQLiteDatabase, wantNextAlarm: Boolean): Map<String,*>? {
    val now = Calendar.getInstance()
    var nowInMinutes = now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE)

    if (wantNextAlarm) {
        nowInMinutes++
    }
    val currentDay = Calendar.getInstance().get(Calendar.DAY_OF_WEEK)
    val currentTime = SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date())

    val cursor = db.rawQuery(
        """
        SELECT * FROM alarms
        WHERE isEnabled = 1 
        AND alarmTime > ?
        AND ((isOneTime = 0 AND (days NOT LIKE '%1%' OR SUBSTR(days, ?, 1) = '1')) OR (isOneTime = 1 AND SUBSTR(days, ?, 4) = 'true'))
        ORDER BY ABS(minutesSinceMidnight - ?) ASC
        LIMIT 1
        """,
        arrayOf(currentTime, currentDay.toString(), currentDay.toString(), nowInMinutes.toString())
    )

    return if (cursor.moveToFirst()) {
        // Parse the cursor into an AlarmModel object
        val alarm = AlarmModel.fromCursor(cursor)
        cursor.close()
        Log.d("Alarm", alarm.alarmTime)
        val latestAlarmTimeOftheDay = stringToTimeOfDay(alarm.alarmTime)
        val intervaltoAlarm = getMillisecondsToAlarm(LocalTime.now(), latestAlarmTimeOftheDay)
        Log.d("a", "${alarm.weatherTypes} ")

        mapOf(
            "interval" to intervaltoAlarm,
            "isActivity" to alarm.activityMonitor,
            "isLocation" to alarm.isLocationEnabled,
            "location" to alarm.location,
            "isWeather" to alarm.isWeatherEnabled,
            "weatherTypes" to alarm.weatherTypes
        )
    } else {
        cursor.close()
        val selectAllQuery = """
            SELECT * FROM alarms
            WHERE isEnabled = 1
            AND alarmTime > ?
        """
        val allAlarmsCursor = db.rawQuery(selectAllQuery, arrayOf(currentTime))
        if (allAlarmsCursor.moveToFirst()) {
            val alarms = ArrayList<Long>()
            val alarmDetails = ArrayList<Map<String, Any>>()
            do {
                var k = 0
                for (i in 0..6) {
                    val dayIndex = ((currentDay - 1) + i) % 6
                    if (AlarmModel.fromCursor(allAlarmsCursor).days[dayIndex] == '1') {
                        k = i
                        break
                    }

                }
                val latestAlarmTimeOftheDay =
                    stringToTimeOfDay(AlarmModel.fromCursor(allAlarmsCursor).alarmTime)
                val intervaltoAlarm =
                    getMillisecondsToAlarm(LocalTime.now(), latestAlarmTimeOftheDay)
                if (k != 0) {
                    alarms.add(intervaltoAlarm + (86400000 * (k)).toLong())
                    alarmDetails.add(
                        mapOf(
                            "interval" to intervaltoAlarm,
                            "isActivity" to AlarmModel.fromCursor(allAlarmsCursor).activityMonitor,
                            "isLocation" to AlarmModel.fromCursor(allAlarmsCursor).isLocationEnabled,
                            "location" to AlarmModel.fromCursor(allAlarmsCursor).location,
                            "isWeather" to AlarmModel.fromCursor(allAlarmsCursor).isWeatherEnabled,
                            "weatherTypes" to AlarmModel.fromCursor(allAlarmsCursor).weatherTypes
                        )
                    )
                }
                else
                {
                    alarms.add(intervaltoAlarm + (86400000 * (7)).toLong())
                    alarmDetails.add(
                        mapOf(
                            "interval" to intervaltoAlarm,
                            "isActivity" to AlarmModel.fromCursor(allAlarmsCursor).activityMonitor,
                            "isLocation" to AlarmModel.fromCursor(allAlarmsCursor).isLocationEnabled,
                            "location" to AlarmModel.fromCursor(allAlarmsCursor).location,
                            "isWeather" to AlarmModel.fromCursor(allAlarmsCursor).isWeatherEnabled,
                            "weatherTypes" to AlarmModel.fromCursor(allAlarmsCursor).weatherTypes
                        )
                    )
                }

            } while (allAlarmsCursor.moveToNext())
            allAlarmsCursor.close()

            alarms.sortWith(Comparator { a, b ->
                a.compareTo(b)

            })
            val sortedList = alarmDetails.sortedBy { it["interval"] as? String }
            Log.d("Alarm", "${sortedList.first()["interval"]}")
            sortedList.first()


        } else {
            null
        }
    }
}

fun stringToTimeOfDay(time: String): LocalTime {
    val parts = time.split(":")
    val hour = parts[0].toInt()
    val minute = parts[1].toInt()
    return LocalTime.of(hour, minute)
}

fun getMillisecondsToAlarm(now: LocalTime, alarmTime: LocalTime): Long {
    var adjustedAlarmTime = alarmTime
    val duration = Duration.between(now, adjustedAlarmTime)
    return duration.toMillis()
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
    val location: String
) {
    companion object {
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
                location
            )
        }
    }
}
