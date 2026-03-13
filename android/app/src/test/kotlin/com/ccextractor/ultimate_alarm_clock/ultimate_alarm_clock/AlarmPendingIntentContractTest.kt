package com.ccextractor.ultimate_alarm_clock

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class AlarmPendingIntentContractTest {
    @Test
    fun `main and legacy boot alarm identities stay distinct`() {
        val mainAlarm = AlarmPendingIntentKind.MAIN_ALARM
        val legacyBootAlarm = AlarmPendingIntentKind.LEGACY_BOOT_ALARM

        assertNotEquals(mainAlarm.requestCode, legacyBootAlarm.requestCode)
        assertTrue(mainAlarm.isBroadcast)
        assertTrue(legacyBootAlarm.isBroadcast)
    }

    @Test
    fun `service identities keep stable request codes`() {
        assertEquals(4, AlarmPendingIntentKind.ACTIVITY_CHECK.requestCode)
        assertEquals(5, AlarmPendingIntentKind.LOCATION_CHECK.requestCode)
        assertEquals(6, AlarmPendingIntentKind.WEATHER_CHECK.requestCode)
    }
}
