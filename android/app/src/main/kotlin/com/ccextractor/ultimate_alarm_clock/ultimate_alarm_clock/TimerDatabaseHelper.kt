package com.ccextractor.ultimate_alarm_clock
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log

class TimerDatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 2
        private const val DATABASE_NAME = "timer.db"
        private const val TAG = "TimerDatabaseHelper"
    }

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("""
          CREATE TABLE timers ( 
            id integer primary key autoincrement, 
            startedOn text not null,
            timerValue integer not null,
            timeElapsed integer not null,
            ringtoneName text not null,
            timerName text not null,
            isPaused integer not null)
        """)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        // No schema changes needed from v1 to v2, just update the version number
        Log.d(TAG, "Upgrading timer database from version $oldVersion to $newVersion")
    }
}
