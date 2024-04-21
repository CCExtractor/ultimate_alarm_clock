package com.example.ultimate_alarm_clock

import android.annotation.SuppressLint
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
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

data class AlarmModel(val id: Int, val minutesSinceMidnight: Int) {
    companion object {
        fun fromCursor(cursor: Cursor): AlarmModel {
            val id = cursor.getInt(cursor.getColumnIndex("id"))
            val minutesSinceMidnight = cursor.getInt(cursor.getColumnIndex("minutesSinceMidnight"))

            return AlarmModel(id, minutesSinceMidnight)
        }
    }
}
