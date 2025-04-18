import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/system_ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

class AudioUtils {
  static final audioPlayer = audioplayer.AudioPlayer();

  static MethodChannel alarmChannel = const MethodChannel('ulticlock');
  static MethodChannel timerChannel = const MethodChannel('timer');

  static AudioSession? audioSession;

  static bool isPreviewing = false;
  
  static List<SystemRingtone>? _cachedRingtones;

  static Future<void> initializeAudioSession() async {
    audioSession = await AudioSession.instance;

    await audioSession!.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions:
            AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.alarm,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
        androidWillPauseWhenDucked: true,
      ),
    );
  }

  static Future<void> playCustomSound(
    String customRingtonePath,
  ) async {
    try {
      var volume = await FlutterVolumeController.getVolume();
      await audioPlayer.setVolume(volume??1.0);
      await audioPlayer.setReleaseMode(audioplayer.ReleaseMode.loop);
      await audioPlayer.play(audioplayer.DeviceFileSource(customRingtonePath));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> playAssetSound(
    String customRingtonePath,
  ) async {
    try {
      var volume = await FlutterVolumeController.getVolume();
      await audioPlayer.setVolume(volume??1.0);
      await audioPlayer.setReleaseMode(audioplayer.ReleaseMode.loop);
      await audioPlayer.play(audioplayer.AssetSource(customRingtonePath));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void playAlarm({
    required AlarmModel alarmRecord,
  }) async {
    try {
      if (audioSession == null) {
        await initializeAudioSession();
      }
      var volume = await FlutterVolumeController.getVolume();
      await audioPlayer.setVolume(volume??1.0);
      await audioSession!.setActive(true);

      String ringtoneName = alarmRecord.ringtoneName;

      int customRingtoneId = fastHash(ringtoneName);
      RingtoneModel? customRingtone = await IsarDb.getCustomRingtone(
        customRingtoneId: customRingtoneId,
      );

      if (customRingtone != null) {
        String customRingtonePath = customRingtone.ringtonePath;
        
        if (defaultRingtones.contains(ringtoneName)) {
          await playAssetSound(customRingtonePath);
        } else if (customRingtonePath.startsWith("system_ringtone:")) {
          // Handle system ringtones with our special prefix
          String systemUri = customRingtonePath.substring("system_ringtone:".length);
          debugPrint("Playing system ringtone with URI: $systemUri");
          await alarmChannel.invokeMethod('playSystemRingtone', {'uri': systemUri});
        } else if (customRingtonePath.startsWith('content://') || 
                  customRingtonePath.startsWith('android.resource://')) {
          // Legacy handling of direct URIs
          await alarmChannel.invokeMethod('playSystemRingtone', {'uri': customRingtonePath});
        } else {
          await playCustomSound(customRingtonePath);
        }
      } else {
        await alarmChannel.invokeMethod('playDefaultAlarm');
        bool isSharedAlarmEnabled = alarmRecord.isSharedAlarmEnabled;

        alarmRecord.ringtoneName = 'Default';

        if (isSharedAlarmEnabled) {
          await FirestoreDb.updateAlarm(alarmRecord.ownerId, alarmRecord);
        } else {
          await IsarDb.updateAlarm(alarmRecord);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void playTimer({
    required TimerModel alarmRecord,
  }) async {
    try {
      if (audioSession == null) {
        await initializeAudioSession();
      }

      await audioSession!.setActive(true);

      String ringtoneName = alarmRecord.ringtoneName;

      if (ringtoneName == 'Default') {
        await alarmChannel.invokeMethod('playDefaultAlarm');
      } else {
        int customRingtoneId = fastHash(ringtoneName);
        RingtoneModel? customRingtone = await IsarDb.getCustomRingtone(
          customRingtoneId: customRingtoneId,
        );

        if (customRingtone != null) {
          String customRingtonePath = customRingtone.ringtonePath;
          await playCustomSound(customRingtonePath);
        } else {
          await timerChannel.invokeMethod('playDefaultAlarm');

          alarmRecord.ringtoneName = 'Default';
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> stopDefaultAlarm() async {
    try {
      if (audioSession != null) {
        await alarmChannel.invokeMethod('stopDefaultAlarm');
        await audioSession!.setActive(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> stopDefaultTimer() async {
    try {
      if (audioSession != null) {
        await timerChannel.invokeMethod('stopDefaultAlarm');
        await audioSession!.setActive(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> previewCustomSound(String ringtoneName) async {
    try {
      if (audioSession == null) {
        await initializeAudioSession();
      }

      await audioSession!.setActive(true);

      if (ringtoneName == 'Default') {
        await alarmChannel.invokeMethod('playDefaultAlarm');
        isPreviewing = true;
      } else if (defaultRingtones.contains(ringtoneName)) {
        int customRingtoneId = fastHash(ringtoneName);
        RingtoneModel? customRingtone = await IsarDb.getCustomRingtone(
          customRingtoneId: customRingtoneId,
        );

        if (customRingtone != null) {
          String customRingtonePath = customRingtone.ringtonePath;
          await alarmChannel.invokeMethod('stopDefaultAlarm');
          await audioSession!.setActive(false);
          await audioSession!.setActive(true);
          await playAssetSound(customRingtonePath);
          isPreviewing = true;
        }
      } else {
        int customRingtoneId = fastHash(ringtoneName);
        RingtoneModel? customRingtone = await IsarDb.getCustomRingtone(
          customRingtoneId: customRingtoneId,
        );

        if (customRingtone != null) {
          String customRingtonePath = customRingtone.ringtonePath;
          await alarmChannel.invokeMethod('stopDefaultAlarm');
          await audioSession!.setActive(false);
          await audioSession!.setActive(true);
          
          if (customRingtonePath.startsWith("system_ringtone:")) {
            // Handle system ringtones with our special prefix
            String systemUri = customRingtonePath.substring("system_ringtone:".length);
            debugPrint("Previewing system ringtone with URI: $systemUri");
            await alarmChannel.invokeMethod('playSystemRingtone', {'uri': systemUri});
            isPreviewing = true;
          } else if (customRingtonePath.startsWith('content://') || 
                    customRingtonePath.startsWith('android.resource://')) {
            // Legacy handling of direct URIs
            await alarmChannel.invokeMethod('playSystemRingtone', {'uri': customRingtonePath});
            isPreviewing = true;
          } else {
            await playCustomSound(customRingtonePath);
            isPreviewing = true;
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> stopPreviewCustomSound() async {
    try {
      if (audioSession == null) {
        await initializeAudioSession();
      }
      
      try {
        await audioPlayer.stop();
      } catch (e) {
        debugPrint('Error stopping audioPlayer: $e');
      }
    
      for (int i = 0; i < 3; i++) {
        try {
          await alarmChannel.invokeMethod('stopDefaultAlarm');
          break;
        } catch (e) {
          debugPrint('Failed to stop native sound (attempt ${i+1}): $e');
          if (i < 2) await Future.delayed(const Duration(milliseconds: 100));
        }
      }
      
      if (audioSession != null) {
        try {
          await audioSession!.setActive(false);
        } catch (e) {
          debugPrint('Error deactivating audio session: $e');
        }
      }
      
      isPreviewing = false;
    } catch (e) {
      debugPrint('Error stopping preview sound: $e');
      isPreviewing = false; 
    }
  }

  static void stopAlarm({
    required String ringtoneName,
  }) async {
    try {
      if (audioSession != null) {
        if (ringtoneName == 'Default') {
          await alarmChannel.invokeMethod('stopDefaultAlarm');
        } else {
          int customRingtoneId = fastHash(ringtoneName);
          RingtoneModel? customRingtone = await IsarDb.getCustomRingtone(
            customRingtoneId: customRingtoneId,
          );
          
          if (customRingtone != null && 
              (customRingtone.ringtonePath.startsWith('content://') || 
               customRingtone.ringtonePath.startsWith('android.resource://') ||
               customRingtone.ringtonePath.startsWith('system_ringtone:'))) {
            // This is a system ringtone
            await alarmChannel.invokeMethod('stopDefaultAlarm');
          } else {
            await audioPlayer.stop();
          }
        }

        await audioSession!.setActive(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void stopTimer({
    required String ringtoneName,
  }) async {
    try {
      if (audioSession != null) {
        if (ringtoneName == 'Default') {
          await timerChannel.invokeMethod('stopDefaultAlarm');
        } else {
          await audioPlayer.stop();
        }

        await audioSession!.setActive(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> updateRingtoneCounterOfUsage({
    required String customRingtoneName,
    required CounterUpdate counterUpdate,
  }) async {
    try {
      int customRingtoneId = fastHash(customRingtoneName);
      RingtoneModel? customRingtone =
          await IsarDb.getCustomRingtone(customRingtoneId: customRingtoneId);

      if (customRingtone != null) {
        if (counterUpdate == CounterUpdate.increment) {
          customRingtone.currentCounterOfUsage++;
        } else if (counterUpdate == CounterUpdate.decrement) {
          customRingtone.currentCounterOfUsage--;
        }
        await IsarDb.addCustomRingtone(customRingtone);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// FNV-1a 64bit hash algorithm optimized for Dart Strings
  static int fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  static Future<List<SystemRingtone>> getSystemRingtones() async {
    try {
      debugPrint('Fetching system ringtones...');
      if (_cachedRingtones != null) {
        debugPrint('Returning ${_cachedRingtones!.length} cached system ringtones');
        return _cachedRingtones!;
      }
      
      final List<dynamic> result = await alarmChannel.invokeMethod('getSystemRingtones');
      debugPrint('Received ${result.length} system ringtones from native side');
      
      final List<SystemRingtone> ringtones = result.map((dynamic item) {
        if (item is Map) {
          final ringtone = SystemRingtone.fromJson(item as Map<dynamic, dynamic>);
          return ringtone;
        } else {
          debugPrint('Invalid ringtone data format: $item');
          return SystemRingtone(
            title: 'Unknown',
            uri: '',
            category: 'alarm',
          );
        }
      }).toList();
      _cachedRingtones = ringtones.where((ringtone) => ringtone.uri.isNotEmpty).toList();
      return _cachedRingtones!;
    } catch (e) {
      debugPrint('Error getting system ringtones: $e');
      return [];
    }
  }

  static Future<void> playSystemRingtone(String uri) async {
    try {
      if (audioSession == null) {
        await initializeAudioSession();
      }
      
      // First, stop any currently playing sound - try multiple times if needed
      if (isPreviewing) {
        for (int i = 0; i < 2; i++) {
          try {
            await stopPreviewCustomSound();
            break; // Exit the retry loop if successful
          } catch (e) {
            // Small delay before retry
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
      }
      
      // Ensure audio session is active
      if (!await audioSession!.setActive(true)) {
        await Future.delayed(const Duration(milliseconds: 100));
        await audioSession!.setActive(true);
      }
      
      // Handle retries with a loop
      bool success = false;
      int retryCount = 0;
      Exception? lastError;
      
      while (!success && retryCount < 3) {
        try {
          // Use the native method channel to play the system ringtone
          await alarmChannel.invokeMethod('playSystemRingtone', {'uri': uri});
          success = true;
          isPreviewing = true;
        } catch (e) {
          lastError = e as Exception;
          retryCount++;
          
          if (retryCount < 3) {
            // Short delay before retry
            await Future.delayed(const Duration(milliseconds: 200));
          }
        }
      }
      
      if (!success) {
        throw lastError ?? Exception('Failed to play system ringtone after multiple attempts');
      }
    } catch (e) {
      // Try to fall back to the default alarm sound
      try {
        await alarmChannel.invokeMethod('playDefaultAlarm');
        isPreviewing = true;
      } catch (fallbackError) {
        // Ignore fallback errors
      }
    }
  }

  static Future<void> saveSystemRingtone({
    required String title,
    required String uri,
    required String category,
  }) async {
    try {
      debugPrint('Saving system ringtone: $title, URI: $uri');
      
      int ringtoneId = fastHash(title);
      RingtoneModel? existingRingtone = await IsarDb.getCustomRingtone(
        customRingtoneId: ringtoneId,
      );
      
      if (existingRingtone != null) {
        debugPrint('Ringtone with name $title already exists, updating instead of creating new');
        existingRingtone.ringtonePath = "system_ringtone:$uri";
        existingRingtone.currentCounterOfUsage += 1;
        await IsarDb.addCustomRingtone(existingRingtone);
        return;
      }
      
      final RingtoneModel systemRingtone = RingtoneModel(
        ringtoneName: title,
        ringtonePath: "system_ringtone:$uri",
        currentCounterOfUsage: 1,
      );
      await IsarDb.addCustomRingtone(systemRingtone);
      debugPrint('Successfully saved system ringtone: $title');
    } catch (e) {
      debugPrint('Error saving system ringtone: $e');
    }
  }
}
