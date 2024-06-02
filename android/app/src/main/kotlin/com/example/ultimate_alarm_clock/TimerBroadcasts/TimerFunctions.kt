package com.example.ultimate_alarm_clocks
import android.content.ContentValues
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteException
import java.text.SimpleDateFormat
import java.util.*


fun getLatestTimer(db: SQLiteDatabase): Triple<Int, Long, String>? {

    try {
        val cursor = db.rawQuery(
            """
        SELECT id, timerValue, timeElapsed, timerName, startedOn
        FROM timers
        WHERE isPaused = 0
        AND DATETIME(startedOn, '+' || CAST(timerValue / 1000 AS TEXT) || ' seconds') > DATETIME('now')
        ORDER BY (timerValue - timeElapsed) ASC
        LIMIT 1;
        """, null
        )
        return if (cursor.moveToFirst()) {
            val timer = TimerModel.fromCursor(cursor)
            cursor.close()
            val intervalToTimer = isFutureDatetimeWithMillis(timer.startedOn, timer.timerValue.toLong())
            Triple(timer.id, intervalToTimer.toLong(), timer.timerName)

        } else {
            cursor.close()
            null
        }

    } catch (e: SQLiteException) {
        db.rawQuery(""" create table timers ( 
            id integer primary key autoincrement, 
            startedOn text not null,
            timerValue integer not null,
            timeElapsed integer not null,
            ringtoneName text not null,
            timerName text not null,
            isPaused integer not null)""",null)
    }
  return null
}

fun pauseTimer(db: SQLiteDatabase, timerId: Int): Boolean {
    val contentValues = ContentValues()
    contentValues.put("isPaused", 1)

    val rowsAffected = db.update("timers", contentValues, "id = ?", arrayOf(timerId.toString()))

    return rowsAffected > 0
}

fun isFutureDatetimeWithMillis(datetimeString: String, milliseconds: Long): Long {
    try {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS")
        val providedDatetime = dateFormat.parse(datetimeString)
        val updatedDatetime = Date(providedDatetime.time + milliseconds)
        val currentDatetime = Date()

        return if (updatedDatetime.after(currentDatetime)) {
            updatedDatetime.time - currentDatetime.time
        } else {
            0
        }
    } catch (e: Exception) {
        // Handle invalid datetime format (e.g., parsing error)
        return 0
    }
}


private data class TimerModel(
    val id: Int,
    val timerValue: Int,
    val timeElapsed: Int,
    val timerName: String,
    val startedOn: String
) {
    companion object {
        fun fromCursor(cursor: Cursor): TimerModel {
            val id = cursor.getInt(cursor.getColumnIndex("id"))
            val timerValue = cursor.getInt(cursor.getColumnIndex("timerValue"))
            val timeElapsed = cursor.getInt(cursor.getColumnIndex("timeElapsed"))
            val timerName = cursor.getString(cursor.getColumnIndex("timerName"))
            val startedOn = cursor.getString(cursor.getColumnIndex("startedOn"))
            return TimerModel(id, timerValue, timeElapsed, timerName, startedOn)
        }
    }
}
