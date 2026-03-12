package com.ccextractor.ultimate_alarm_clock

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.UserManager
import android.util.Log
import java.time.Instant
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException

data class ScheduledAlarmPayload(
    val triggerAtMs: Long,
    val activityMonitor: Int,
    val locationMonitor: Int,
    val location: String,
    val isWeather: Int,
    val weatherTypes: String
)

object AlarmScheduleStore {
    private const val PREFS_NAME = "ultimate_alarm_clock_schedule"
    private const val KEY_TRIGGER_AT_MS = "trigger_at_ms"
    private const val KEY_ACTIVITY_MONITOR = "activity_monitor"
    private const val KEY_LOCATION_MONITOR = "location_monitor"
    private const val KEY_LOCATION = "location"
    private const val KEY_IS_WEATHER = "is_weather"
    private const val KEY_WEATHER_TYPES = "weather_types"

    private fun deviceProtectedContext(context: Context): Context {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            context.createDeviceProtectedStorageContext()
        } else {
            context
        }
    }

    fun canAccessCredentialEncryptedStorage(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            return true
        }

        val userManager = context.getSystemService(UserManager::class.java)
        return userManager?.isUserUnlocked != false
    }

    private fun writePreferences(context: Context, payload: ScheduledAlarmPayload) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putLong(KEY_TRIGGER_AT_MS, payload.triggerAtMs)
            .putInt(KEY_ACTIVITY_MONITOR, payload.activityMonitor)
            .putInt(KEY_LOCATION_MONITOR, payload.locationMonitor)
            .putString(KEY_LOCATION, payload.location)
            .putInt(KEY_IS_WEATHER, payload.isWeather)
            .putString(KEY_WEATHER_TYPES, payload.weatherTypes)
            .apply()
    }

    private fun readPreferences(context: Context): ScheduledAlarmPayload? {
        val preferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        if (!preferences.contains(KEY_TRIGGER_AT_MS)) {
            return null
        }

        return ScheduledAlarmPayload(
            triggerAtMs = preferences.getLong(KEY_TRIGGER_AT_MS, -1L),
            activityMonitor = preferences.getInt(KEY_ACTIVITY_MONITOR, 0),
            locationMonitor = preferences.getInt(KEY_LOCATION_MONITOR, 0),
            location = preferences.getString(KEY_LOCATION, "") ?: "",
            isWeather = preferences.getInt(KEY_IS_WEATHER, 0),
            weatherTypes = preferences.getString(KEY_WEATHER_TYPES, "[]") ?: "[]"
        )
    }

    fun save(context: Context, payload: ScheduledAlarmPayload) {
        val protectedContext = deviceProtectedContext(context)
        writePreferences(protectedContext, payload)
        if (protectedContext !== context && canAccessCredentialEncryptedStorage(context)) {
            writePreferences(context, payload)
        }
    }

    fun load(context: Context): ScheduledAlarmPayload? {
        val protectedContext = deviceProtectedContext(context)
        val protectedPayload = readPreferences(protectedContext)
        if (protectedPayload != null) {
            return protectedPayload
        }

        val legacyPayload = if (
            protectedContext !== context &&
            canAccessCredentialEncryptedStorage(context)
        ) {
            readPreferences(context)
        } else {
            null
        }

        if (legacyPayload != null) {
            writePreferences(protectedContext, legacyPayload)
        }

        return legacyPayload
    }

    fun clear(context: Context) {
        val protectedContext = deviceProtectedContext(context)
        protectedContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .clear()
            .apply()
        if (protectedContext !== context && canAccessCredentialEncryptedStorage(context)) {
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .edit()
                .clear()
                .apply()
        }
    }
}

object BootRestorePlanner {
    fun chooseAlarmToRestore(
        persistedAlarm: ScheduledAlarmPayload?,
        localAlarm: ScheduledAlarmPayload?,
        nowMs: Long,
        allowLocalFallback: Boolean,
    ): ScheduledAlarmPayload? {
        val validLocal = if (allowLocalFallback) {
            localAlarm?.takeIf { it.triggerAtMs > nowMs }
        } else {
            null
        }
        if (validLocal != null) {
            return validLocal
        }

        val validPersisted = persistedAlarm?.takeIf { it.triggerAtMs > nowMs }
        if (validPersisted != null) {
            return validPersisted
        }
        return null
    }
}

object LocalAlarmScheduleResolver {
    private val timeFormatter: DateTimeFormatter = DateTimeFormatter.ofPattern("H:mm")

    fun nextTriggerAtMs(
        alarm: AlarmModel,
        nowMs: Long,
        zoneId: ZoneId = ZoneId.systemDefault(),
    ): Long? {
        val referenceTime = Instant.ofEpochMilli(nowMs).atZone(zoneId).toLocalDateTime()
        val alarmTime = parseTime(alarm.alarmTime) ?: return null

        if (alarm.ringOn == 1) {
            val alarmDate = parseDate(alarm.alarmDate) ?: return null
            return toEpochMillis(LocalDateTime.of(alarmDate, alarmTime), zoneId)
                ?.takeIf { it > nowMs }
        }

        if (alarm.days.any { it == '1' }) {
            for (offset in 0..7) {
                val candidateDate = referenceTime.toLocalDate().plusDays(offset.toLong())
                val candidate = LocalDateTime.of(candidateDate, alarmTime)
                val dayIndex = candidate.dayOfWeek.value % 7
                if (alarm.days.getOrNull(dayIndex) == '1' && candidate.isAfter(referenceTime)) {
                    return toEpochMillis(candidate, zoneId)
                }
            }

            return null
        }

        val today = LocalDateTime.of(referenceTime.toLocalDate(), alarmTime)
        val nextCandidate = if (today.isAfter(referenceTime)) {
            today
        } else {
            today.plusDays(1)
        }
        return toEpochMillis(nextCandidate, zoneId)
    }

    private fun parseTime(rawTime: String): LocalTime? {
        return try {
            LocalTime.parse(rawTime, timeFormatter)
        } catch (_: DateTimeParseException) {
            null
        }
    }

    private fun parseDate(rawDate: String): LocalDate? {
        return try {
            LocalDate.parse(rawDate.trim())
        } catch (_: DateTimeParseException) {
            null
        }
    }

    private fun toEpochMillis(dateTime: LocalDateTime, zoneId: ZoneId): Long? {
        return try {
            dateTime.atZone(zoneId).toInstant().toEpochMilli()
        } catch (_: DateTimeParseException) {
            null
        }
    }
}

object AlarmScheduler {
    private const val ALARM_REQUEST_CODE = 0
    private const val LEGACY_BOOT_ALARM_REQUEST_CODE = 1
    private const val ACTIVITY_REQUEST_CODE = 4
    private const val LOCATION_REQUEST_CODE = 5
    private const val WEATHER_REQUEST_CODE = 6

    @SuppressLint("ScheduleExactAlarm")
    fun schedule(
        context: Context,
        payload: ScheduledAlarmPayload,
        allowCredentialEncryptedAccess: Boolean = AlarmScheduleStore.canAccessCredentialEncryptedStorage(context),
    ) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val now = System.currentTimeMillis()
        val triggerAtMs = payload.triggerAtMs

        if (triggerAtMs <= now) {
            Log.d("AlarmScheduler", "Skipping stale alarm payload at $triggerAtMs")
            clear(context)
            return
        }

        val intent = Intent(context, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        val activityCheckIntent = Intent(context, ScreenMonitorService::class.java)
        val pendingActivityCheckIntent = PendingIntent.getService(
            context,
            ACTIVITY_REQUEST_CODE,
            activityCheckIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )

        val tenMinutesInMilliseconds = 600000L
        val preTriggerTime = maxOf(now, triggerAtMs - tenMinutesInMilliseconds)

        if (!allowCredentialEncryptedAccess) {
            val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerAtMs, pendingIntent)
            alarmManager.setAlarmClock(alarmClockInfo, pendingIntent)
            return
        }

        if (payload.activityMonitor == 1) {
            val alarmClockInfo = AlarmManager.AlarmClockInfo(preTriggerTime, pendingIntent)
            alarmManager.setAlarmClock(alarmClockInfo, pendingActivityCheckIntent)
        } else {
            val sharedPreferences =
                context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            sharedPreferences.edit()
                .putLong("flutter.is_screen_off", 0L)
                .putLong("flutter.is_screen_on", 0L)
                .apply()
        }

        if (payload.locationMonitor == 1) {
            val sharedPreferences =
                context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            sharedPreferences.edit()
                .putString("flutter.set_location", payload.location)
                .putInt("flutter.is_location_on", 1)
                .apply()
            Log.d("location", payload.location)

            val locationAlarmIntent = Intent(context, LocationFetcherService::class.java)
            val pendingLocationAlarmIntent = PendingIntent.getService(
                context,
                LOCATION_REQUEST_CODE,
                locationAlarmIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            val alarmClockInfo = AlarmManager.AlarmClockInfo(maxOf(now, triggerAtMs - 10000), pendingIntent)
            alarmManager.setAlarmClock(alarmClockInfo, pendingLocationAlarmIntent)
        } else if (payload.isWeather == 1) {
            val sharedPreferences =
                context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val weatherConditions = getWeatherConditions(payload.weatherTypes)
            sharedPreferences.edit()
                .putString("flutter.weatherTypes", weatherConditions)
                .apply()
            Log.d("we", weatherConditions)

            val weatherAlarmIntent = Intent(context, WeatherFetcherService::class.java)
            val pendingWeatherAlarmIntent = PendingIntent.getService(
                context,
                WEATHER_REQUEST_CODE,
                weatherAlarmIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            val alarmClockInfo = AlarmManager.AlarmClockInfo(maxOf(now, triggerAtMs - 10000), pendingIntent)
            alarmManager.setAlarmClock(alarmClockInfo, pendingWeatherAlarmIntent)
        } else {
            val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerAtMs, pendingIntent)
            alarmManager.setAlarmClock(alarmClockInfo, pendingIntent)
        }
    }

    fun clear(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val alarmIntent = Intent(context, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_REQUEST_CODE,
            alarmIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        alarmManager.cancel(pendingIntent)
        pendingIntent.cancel()

        val legacyBootPendingIntent = PendingIntent.getBroadcast(
            context,
            LEGACY_BOOT_ALARM_REQUEST_CODE,
            alarmIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        alarmManager.cancel(legacyBootPendingIntent)
        legacyBootPendingIntent.cancel()

        val activityIntent = Intent(context, ScreenMonitorService::class.java)
        val pendingActivityIntent = PendingIntent.getService(
            context,
            ACTIVITY_REQUEST_CODE,
            activityIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        alarmManager.cancel(pendingActivityIntent)
        pendingActivityIntent.cancel()

        val locationIntent = Intent(context, LocationFetcherService::class.java)
        val pendingLocationIntent = PendingIntent.getService(
            context,
            LOCATION_REQUEST_CODE,
            locationIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        alarmManager.cancel(pendingLocationIntent)
        pendingLocationIntent.cancel()

        val weatherIntent = Intent(context, WeatherFetcherService::class.java)
        val pendingWeatherIntent = PendingIntent.getService(
            context,
            WEATHER_REQUEST_CODE,
            weatherIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        alarmManager.cancel(pendingWeatherIntent)
        pendingWeatherIntent.cancel()

        AlarmScheduleStore.clear(context)
    }
}
