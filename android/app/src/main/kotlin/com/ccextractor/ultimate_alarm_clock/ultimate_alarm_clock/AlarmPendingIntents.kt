package com.ccextractor.ultimate_alarm_clock

import android.app.PendingIntent
import android.content.Context
import android.content.Intent

internal enum class AlarmPendingIntentKind(
    val requestCode: Int,
    val isBroadcast: Boolean,
) {
    MAIN_ALARM(0, true),
    LEGACY_BOOT_ALARM(1, true),
    ACTIVITY_CHECK(4, false),
    LOCATION_CHECK(5, false),
    WEATHER_CHECK(6, false),
}

internal object AlarmPendingIntents {
    private const val FLAGS = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE

    fun broadcast(
        context: Context,
        kind: AlarmPendingIntentKind,
        intent: Intent,
    ): PendingIntent {
        require(kind.isBroadcast) { "$kind must use a broadcast PendingIntent" }
        return PendingIntent.getBroadcast(
            context,
            kind.requestCode,
            intent,
            FLAGS
        )
    }

    fun service(
        context: Context,
        kind: AlarmPendingIntentKind,
        intent: Intent,
    ): PendingIntent {
        require(!kind.isBroadcast) { "$kind must use a service PendingIntent" }
        return PendingIntent.getService(
            context,
            kind.requestCode,
            intent,
            FLAGS
        )
    }
}
