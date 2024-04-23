package com.example.ultimate_alarm_clock
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import java.time.Duration
import java.time.LocalTime
import java.util.*


fun getLatestAlarm(db: SQLiteDatabase, wantNextAlarm: Boolean): AlarmModel? {
    val now = Calendar.getInstance()
    var nowInMinutes = now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE)

    if (wantNextAlarm) {
        nowInMinutes++
    }

    val cursor = db.rawQuery(
        """
        SELECT * FROM alarms
        WHERE isEnabled = 1
        ORDER BY ABS(minutesSinceMidnight - ?) ASC
        LIMIT 1
        """, arrayOf(nowInMinutes.toString())
    )

    return if (cursor.moveToFirst()) {
        // Parse the cursor into an AlarmModel object
        val alarm = AlarmModel.fromCursor(cursor)
        cursor.close()

        alarm
    } else {
        cursor.close()
        null
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
    if (adjustedAlarmTime.isBefore(now)) {
        adjustedAlarmTime = adjustedAlarmTime.plusHours(24) // Add a day in hours
    }

    val duration = Duration.between(now, adjustedAlarmTime)
    return duration.toMillis()
}

data class AlarmModel(val id: Int, val minutesSinceMidnight: Int, val alarmTime: String) {
    companion object {
        fun fromCursor(cursor: Cursor): AlarmModel {
            val id = cursor.getInt(cursor.getColumnIndex("id"))
            val minutesSinceMidnight = cursor.getInt(cursor.getColumnIndex("minutesSinceMidnight"))
            val alarmTime = cursor.getString(cursor.getColumnIndex("alarmTime"))
            return AlarmModel(id, minutesSinceMidnight,alarmTime)
        }
    }
}
