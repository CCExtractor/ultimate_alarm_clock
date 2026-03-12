package com.ccextractor.ultimate_alarm_clock

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import java.time.LocalDateTime
import java.time.ZoneId

class BootRestorePlannerTest {
    private fun payload(triggerAtMs: Long) = ScheduledAlarmPayload(
        triggerAtMs = triggerAtMs,
        activityMonitor = 0,
        locationMonitor = 0,
        location = "",
        isWeather = 0,
        weatherTypes = "[]"
    )

    @Test
    fun `prefers local fallback over persisted payload when both are valid`() {
        val now = 1_000L
        val persisted = payload(5_000L)
        val local = payload(10_000L)

        val reconciled = BootRestorePlanner.chooseAlarmToRestore(
            persistedAlarm = persisted,
            localAlarm = local,
            nowMs = now,
            allowLocalFallback = true
        )

        assertEquals(10_000L, reconciled?.triggerAtMs)
    }

    @Test
    fun `prefers recomputed local alarm when persisted trigger drifted`() {
        val now = 1_000L
        val persisted = payload(5_000L)
        val local = payload(7_200_000L)

        val reconciled = BootRestorePlanner.chooseAlarmToRestore(
            persistedAlarm = persisted,
            localAlarm = local,
            nowMs = now,
            allowLocalFallback = true
        )

        assertEquals(7_200_000L, reconciled?.triggerAtMs)
    }

    @Test
    fun `uses local fallback when persisted payload is missing`() {
        val reconciled = BootRestorePlanner.chooseAlarmToRestore(
            persistedAlarm = null,
            localAlarm = payload(5_000L),
            nowMs = 1_000L,
            allowLocalFallback = true
        )

        assertEquals(5_000L, reconciled?.triggerAtMs)
    }

    @Test
    fun `ignores stale persisted payload and falls back to local when allowed`() {
        val reconciled = BootRestorePlanner.chooseAlarmToRestore(
            persistedAlarm = payload(500L),
            localAlarm = payload(5_000L),
            nowMs = 1_000L,
            allowLocalFallback = true
        )

        assertEquals(5_000L, reconciled?.triggerAtMs)
    }

    @Test
    fun `does not use local fallback during locked boot recovery`() {
        val reconciled = BootRestorePlanner.chooseAlarmToRestore(
            persistedAlarm = null,
            localAlarm = payload(5_000L),
            nowMs = 1_000L,
            allowLocalFallback = false
        )

        assertNull(reconciled)
    }

    @Test
    fun `local resolver computes next repeating trigger using sunday first day string`() {
        val zone = ZoneId.systemDefault()
        val now = LocalDateTime.of(2026, 3, 12, 13, 38)
            .atZone(zone)
            .toInstant()
            .toEpochMilli()
        val alarm = AlarmModel(
            id = 1,
            minutesSinceMidnight = 13 * 60 + 37,
            alarmTime = "13:37",
            days = "1111111",
            isOneTime = 0,
            activityMonitor = 0,
            isWeatherEnabled = 0,
            weatherTypes = "[]",
            isLocationEnabled = 0,
            location = "",
            alarmDate = "",
            alarmId = "alarm-id",
            ringOn = 0
        )

        val triggerAtMs = LocalAlarmScheduleResolver.nextTriggerAtMs(alarm, now, zone)

        val expected = LocalDateTime.of(2026, 3, 13, 13, 37)
            .atZone(zone)
            .toInstant()
            .toEpochMilli()
        assertEquals(expected, triggerAtMs)
    }

    @Test
    fun `local resolver ignores stale one time alarms`() {
        val zone = ZoneId.systemDefault()
        val now = LocalDateTime.of(2026, 3, 12, 13, 38)
            .atZone(zone)
            .toInstant()
            .toEpochMilli()
        val alarm = AlarmModel(
            id = 2,
            minutesSinceMidnight = 13 * 60 + 37,
            alarmTime = "13:37",
            days = "0000000",
            isOneTime = 1,
            activityMonitor = 0,
            isWeatherEnabled = 0,
            weatherTypes = "[]",
            isLocationEnabled = 0,
            location = "",
            alarmDate = "2026-03-11",
            alarmId = "alarm-id",
            ringOn = 1
        )

        val triggerAtMs = LocalAlarmScheduleResolver.nextTriggerAtMs(alarm, now, zone)

        assertNull(triggerAtMs)
    }
}
