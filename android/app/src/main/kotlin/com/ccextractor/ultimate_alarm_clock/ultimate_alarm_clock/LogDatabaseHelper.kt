package com.ccextractor.ultimate_alarm_clock
import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import org.json.JSONObject

class LogDatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_NAME = "AlarmLogs.db"
        private const val DATABASE_VERSION = 1
        private const val TABLE_NAME = "LOG"
        private const val COLUMN_LOG_ID = "LogID"
        private const val COLUMN_LOG_TIME = "LogTime"
        private const val COLUMN_STATUS = "Status"
        private const val COLUMN_MSG = "logMsg"
        private const val COLUMN_DATA = "LogData"
    }

    override fun onCreate(db: SQLiteDatabase?) {
        // Create the LOG table
        val createTableQuery = """
            CREATE TABLE $TABLE_NAME (
                $COLUMN_LOG_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COLUMN_LOG_TIME DATETIME NOT NULL,
                $COLUMN_STATUS INTEGER NOT NULL DEFAULT 0,
                $COLUMN_MSG TEXT NOT NULL DEFAULT 'No message',
                $COLUMN_DATA TEXT
            )
        """.trimIndent()
        db?.execSQL(createTableQuery)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        // Drop the table if it exists and recreate it
        db?.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

    // Insert a log entry
    fun insertLog(msg: String): Long {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COLUMN_LOG_TIME, System.currentTimeMillis()) // Store current time as milliseconds
            put(COLUMN_MSG, msg)
        }
        return db.insert(TABLE_NAME, null, values)
    }

    //Insert a log entry with extra data
    fun insertLog(msg: String, logData: Map<String, Any>): Long {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COLUMN_LOG_TIME, System.currentTimeMillis()) // Store current time as milliseconds
            put(COLUMN_MSG, msg)
            put(COLUMN_DATA, JSONObject(logData).toString())
        }
        return db.insert(TABLE_NAME, null, values)
    }

    // Fetch all log entries
    fun getLogs(): Cursor {
        val db = readableDatabase
        return db.query(TABLE_NAME, null, null, null, null, null, null)
    }

    // Update a log entry
    fun updateLog(logId: Int, newStatus: String): Int {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COLUMN_STATUS, newStatus)
        }
        return db.update(TABLE_NAME, values, "$COLUMN_LOG_ID = ?", arrayOf(logId.toString()))
    }

    // Delete a log entry
    fun deleteLog(logId: Int): Int {
        val db = writableDatabase
        return db.delete(TABLE_NAME, "$COLUMN_LOG_ID = ?", arrayOf(logId.toString()))
    }
}