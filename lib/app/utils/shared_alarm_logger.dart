import 'package:flutter/foundation.dart';

/// Structured logger for the Shared Alarm pipeline.
///
/// Provides consistent, filterable log output for every stage of the
/// shared-alarm lifecycle:
///   Notification Sent → Received → Tapped → Accepted/Declined → Scheduled
///
/// All log lines are prefixed with `[SharedAlarm]` so they can be easily
/// grepped from `adb logcat` or the Flutter console.
class SharedAlarmLogger {
  SharedAlarmLogger._();

  static const String _tag = '[SharedAlarm]';

  // ── Event type constants ──────────────────────────────────────────────

  static const String eventNotificationSent = 'NOTIFICATION_SENT';
  static const String eventNotificationReceived = 'NOTIFICATION_RECEIVED';
  static const String eventNotificationTapped = 'NOTIFICATION_TAPPED';
  static const String eventAlarmAccepted = 'ALARM_ACCEPTED';
  static const String eventAlarmDeclined = 'ALARM_DECLINED';
  static const String eventAlarmScheduled = 'ALARM_SCHEDULED';
  static const String eventAlarmScheduleFailed = 'ALARM_SCHEDULE_FAILED';
  static const String eventPayloadParsed = 'PAYLOAD_PARSED';
  static const String eventPayloadParseFailed = 'PAYLOAD_PARSE_FAILED';
  static const String eventPendingAlarmStored = 'PENDING_ALARM_STORED';
  static const String eventPendingAlarmCleared = 'PENDING_ALARM_CLEARED';
  static const String eventDuplicateDetected = 'DUPLICATE_DETECTED';
  static const String eventColdStartHandled = 'COLD_START_HANDLED';

  // ── Core logging method ───────────────────────────────────────────────

  /// Logs a structured event with optional key-value details.
  ///
  /// Example output:
  /// ```
  /// [SharedAlarm] NOTIFICATION_RECEIVED | alarmId=abc123 | time=07:30 | from=John
  /// ```
  static void log(
    String event, {
    Map<String, dynamic>? details,
    String? error,
  }) {
    final buffer = StringBuffer('$_tag $event');

    if (details != null && details.isNotEmpty) {
      for (final entry in details.entries) {
        buffer.write(' | ${entry.key}=${entry.value}');
      }
    }

    if (error != null) {
      buffer.write(' | ERROR=$error');
    }

    debugPrint(buffer.toString());
  }

  // ── Convenience methods ───────────────────────────────────────────────

  /// Log when a shared alarm notification is sent to recipients.
  static void notificationSent({
    required String alarmId,
    required String alarmTime,
    required int recipientCount,
  }) {
    log(eventNotificationSent, details: {
      'alarmId': alarmId,
      'time': alarmTime,
      'recipients': recipientCount,
    });
  }

  /// Log when an FCM notification is received (foreground or background).
  static void notificationReceived({
    required String alarmId,
    required String alarmTime,
    required String appState, // 'foreground', 'background', 'terminated'
    int? payloadVersion,
  }) {
    log(eventNotificationReceived, details: {
      'alarmId': alarmId,
      'time': alarmTime,
      'appState': appState,
      'payloadVersion': payloadVersion ?? 'unknown',
    });
  }

  /// Log when a user taps on a shared alarm notification.
  static void notificationTapped({
    required String alarmId,
    required String source, // 'foreground_banner', 'system_notification', 'cold_start'
  }) {
    log(eventNotificationTapped, details: {
      'alarmId': alarmId,
      'source': source,
    });
  }

  /// Log when a shared alarm is accepted.
  static void alarmAccepted({
    required String alarmId,
    required String alarmTime,
    String? firestoreId,
  }) {
    log(eventAlarmAccepted, details: {
      'alarmId': alarmId,
      'time': alarmTime,
      'firestoreId': firestoreId ?? 'N/A',
    });
  }

  /// Log when a shared alarm is declined.
  static void alarmDeclined({
    required String alarmId,
    required String alarmTime,
  }) {
    log(eventAlarmDeclined, details: {
      'alarmId': alarmId,
      'time': alarmTime,
    });
  }

  /// Log when a shared alarm is successfully scheduled.
  static void alarmScheduled({
    required String alarmId,
    required String alarmTime,
    required int intervalMs,
  }) {
    log(eventAlarmScheduled, details: {
      'alarmId': alarmId,
      'time': alarmTime,
      'intervalMs': intervalMs,
    });
  }

  /// Log when scheduling a shared alarm fails.
  static void alarmScheduleFailed({
    required String alarmId,
    required String alarmTime,
    required String error,
  }) {
    log(eventAlarmScheduleFailed, details: {
      'alarmId': alarmId,
      'time': alarmTime,
    }, error: error);
  }

  /// Log when a pending shared alarm is persisted locally.
  static void pendingAlarmStored({
    required String alarmId,
    required int totalPending,
  }) {
    log(eventPendingAlarmStored, details: {
      'alarmId': alarmId,
      'totalPending': totalPending,
    });
  }

  /// Log when a duplicate shared alarm is detected and skipped.
  static void duplicateDetected({
    required String alarmId,
  }) {
    log(eventDuplicateDetected, details: {
      'alarmId': alarmId,
    });
  }

  /// Log payload parsing results.
  static void payloadParsed({
    required String alarmId,
    required int payloadVersion,
    required bool hasFullData,
  }) {
    log(eventPayloadParsed, details: {
      'alarmId': alarmId,
      'version': payloadVersion,
      'hasFullData': hasFullData,
    });
  }

  /// Log a cold-start event (app launched from terminated by tapping notification).
  static void coldStartHandled({
    required String alarmId,
    required String alarmTime,
  }) {
    log(eventColdStartHandled, details: {
      'alarmId': alarmId,
      'time': alarmTime,
    });
  }
}
