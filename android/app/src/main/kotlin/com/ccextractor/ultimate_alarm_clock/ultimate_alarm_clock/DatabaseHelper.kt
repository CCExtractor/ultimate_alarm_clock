package com.ccextractor.ultimate_alarm_clock
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_VERSION = 1
        private const val DATABASE_NAME = "alarms.db"
    }

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("""
            CREATE TABLE alarms (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                firestoreId TEXT,
                alarmTime TEXT NOT NULL,
                alarmID TEXT NOT NULL UNIQUE,
                isEnabled INTEGER NOT NULL DEFAULT 1,
                isLocationEnabled INTEGER NOT NULL DEFAULT 0,
                locationConditionType INTEGER NOT NULL DEFAULT 2,
                isSharedAlarmEnabled INTEGER NOT NULL DEFAULT 0,
                isWeatherEnabled INTEGER NOT NULL DEFAULT 0,
                weatherConditionType INTEGER NOT NULL DEFAULT 2,
                activityConditionType INTEGER NOT NULL DEFAULT 2,
                location TEXT,
                activityInterval INTEGER,
                minutesSinceMidnight INTEGER NOT NULL,
                days TEXT NOT NULL,
                weatherTypes TEXT NOT NULL,
                isMathsEnabled INTEGER NOT NULL DEFAULT 0,
                mathsDifficulty INTEGER,
                numMathsQuestions INTEGER,
                isShakeEnabled INTEGER NOT NULL DEFAULT 0,
                shakeTimes INTEGER,
                isQrEnabled INTEGER NOT NULL DEFAULT 0,
                qrValue TEXT,
                isPedometerEnabled INTEGER NOT NULL DEFAULT 0,
                numberOfSteps INTEGER,
                intervalToAlarm INTEGER,
                isActivityEnabled INTEGER NOT NULL DEFAULT 0,
                sharedUserIds TEXT,
                ownerId TEXT NOT NULL,
                ownerName TEXT NOT NULL,
                lastEditedUserId TEXT,
                mutexLock INTEGER NOT NULL DEFAULT 0,
                mutexLockTimestamp INTEGER NOT NULL DEFAULT 0,
                mainAlarmTime TEXT,
                label TEXT,
                isOneTime INTEGER NOT NULL DEFAULT 0,
                snoozeDuration INTEGER,
                maxSnoozeCount INTEGER DEFAULT 3,
                gradient INTEGER,
                ringtoneName TEXT,
                note TEXT,
                deleteAfterGoesOff INTEGER NOT NULL DEFAULT 0,
                showMotivationalQuote INTEGER NOT NULL DEFAULT 0,
                volMin REAL,
                volMax REAL,
                activityMonitor INTEGER,
                alarmDate TEXT NOT NULL,
                profile TEXT NOT NULL,
                isGuardian INTEGER,
                guardianTimer INTEGER,
                guardian TEXT,
                isCall INTEGER,
                ringOn INTEGER,
                isSunriseEnabled INTEGER NOT NULL DEFAULT 0,
                sunriseDuration INTEGER NOT NULL DEFAULT 30,
                sunriseIntensity REAL NOT NULL DEFAULT 1.0,
                sunriseColorScheme INTEGER NOT NULL DEFAULT 0
            )
        """)
        
        db.execSQL("""
            CREATE TABLE ringtones (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                ringtoneName TEXT NOT NULL,
                ringtonePath TEXT NOT NULL,
                currentCounterOfUsage INTEGER NOT NULL DEFAULT 0
            )
        """)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        // No migrations needed - all columns already exist
    }
}