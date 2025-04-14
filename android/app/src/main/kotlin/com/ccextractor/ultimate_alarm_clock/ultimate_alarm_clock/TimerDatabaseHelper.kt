package com.ccextractor.ultimate_alarm_clock
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class TimerDatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 1
        private const val DATABASE_NAME = "timer.db"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createTableQuery = """
            CREATE TABLE timers (
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                startedOn TEXT NOT NULL,
                timerValue INTEGER NOT NULL,
                timeElapsed INTEGER NOT NULL,
                ringtoneName TEXT NOT NULL,
                timerName TEXT NOT NULL,
                isPaused INTEGER NOT NULL
            );
        """.trimIndent()

        db.execSQL(createTableQuery)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
    }
}
