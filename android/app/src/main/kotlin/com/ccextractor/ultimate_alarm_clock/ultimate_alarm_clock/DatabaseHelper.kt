package com.ccextractor.ultimate_alarm_clock
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log

class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 2
        private const val DATABASE_NAME = "alarms.db"
        private const val TAG = "DatabaseHelper"
    }

    override fun onCreate(db: SQLiteDatabase) {
        // This will be called by the SQLite system
        // Implementation is in Dart code
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        if (oldVersion < 2) {
            try {
                // Add maxSnoozeCount column to alarms table
                db.execSQL("ALTER TABLE alarms ADD COLUMN maxSnoozeCount INTEGER DEFAULT 3")
                Log.d(TAG, "Successfully added maxSnoozeCount column to alarms table")
            } catch (e: Exception) {
                Log.e(TAG, "Error adding maxSnoozeCount column: ${e.message}")
            }
        }
    }
}
