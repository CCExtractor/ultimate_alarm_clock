package com.ccextractor.ultimate_alarm_clock

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class AlarmPendingIntentContractTest {
    @Test
    fun `main and legacy boot alarms keep different request codes`() {
        assertNotEquals(
            AlarmPendingIntentKind.MAIN_ALARM.requestCode,
            AlarmPendingIntentKind.LEGACY_BOOT_ALARM.requestCode
        )
        assertTrue(AlarmPendingIntentKind.MAIN_ALARM.isBroadcast)
        assertTrue(AlarmPendingIntentKind.LEGACY_BOOT_ALARM.isBroadcast)
    }

    @Test
    fun `service request codes stay stable`() {
        assertEquals(4, AlarmPendingIntentKind.ACTIVITY_CHECK.requestCode)
        assertEquals(5, AlarmPendingIntentKind.LOCATION_CHECK.requestCode)
        assertEquals(6, AlarmPendingIntentKind.WEATHER_CHECK.requestCode)
    }
}
