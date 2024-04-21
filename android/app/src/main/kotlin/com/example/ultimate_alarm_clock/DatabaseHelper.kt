package com.example.ultimate_alarm_clock

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 1
        private const val DATABASE_NAME = "alarms.db"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val CREATE_ALARMS_TABLE = ("CREATE TABLE alarms (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                "firestoreId TEXT," +
                "alarmTime TEXT NOT NULL," +
                "alarmID TEXT NOT NULL UNIQUE," +
                "isEnabled INTEGER NOT NULL DEFAULT 1," +
                "isLocationEnabled INTEGER NOT NULL DEFAULT 0," +
                "isSharedAlarmEnabled INTEGER NOT NULL DEFAULT 0," +
                "isWeatherEnabled INTEGER NOT NULL DEFAULT 0," +
                "location TEXT," +
                "activityInterval INTEGER," +
                "minutesSinceMidnight INTEGER NOT NULL," +
                "days TEXT NOT NULL," +
                "weatherTypes TEXT NOT NULL," +
                "isMathsEnabled INTEGER NOT NULL DEFAULT 0," +
                "mathsDifficulty INTEGER," +
                "numMathsQuestions INTEGER," +
                "isShakeEnabled INTEGER NOT NULL DEFAULT 0," +
                "shakeTimes INTEGER," +
                "isQrEnabled INTEGER NOT NULL DEFAULT 0," +
                "qrValue TEXT," +
                "isPedometerEnabled INTEGER NOT NULL DEFAULT 0," +
                "numberOfSteps INTEGER," +
                "intervalToAlarm INTEGER," +
                "isActivityEnabled INTEGER NOT NULL DEFAULT 0," +
                "sharedUserIds TEXT," +
                "ownerId TEXT NOT NULL," +
                "ownerName TEXT NOT NULL," +
                "lastEditedUserId TEXT," +
                "mutexLock INTEGER NOT NULL DEFAULT 0," +
                "mainAlarmTime TEXT," +
                "label TEXT," +
                "isOneTime INTEGER NOT NULL DEFAULT 0," +
                "snoozeDuration INTEGER," +
                "gradient INTEGER," +
                "ringtoneName TEXT," +
                "note TEXT," +
                "deleteAfterGoesOff INTEGER NOT NULL DEFAULT 0," +
                "showMotivationalQuote INTEGER NOT NULL DEFAULT 0," +
                "volMin REAL," +
                "volMax REAL" +
                ")")
        db.execSQL(CREATE_ALARMS_TABLE)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS alarms")
        onCreate(db)
    }
}
