import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/timer_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/system_ringtone_service.dart';

class AudioUtils {
  static final audioPlayer = audioplayer.AudioPlayer();

  static MethodChannel alarmChannel = const MethodChannel('ulticlock');
  static MethodChannel timerChannel = const MethodChannel('timer');

  static AudioSession? audioSession;

  static bool isPreviewing = false;

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
        if (customRingtone.isSystemRingtone && customRingtone.ringtoneUri.isNotEmpty) {
          await SystemRingtoneService.playSystemRingtone(customRingtone.ringtoneUri);
        } else {
          String customRingtonePath = customRingtone.ringtonePath;
          if (defaultRingtones.contains(ringtoneName)) {
            await playAssetSound(customRingtonePath);
          } else {
            await playCustomSound(customRingtonePath);
          }
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
          if (customRingtone.isSystemRingtone && customRingtone.ringtoneUri.isNotEmpty) {
            await SystemRingtoneService.playSystemRingtone(customRingtone.ringtoneUri);
          } else {
            String customRingtonePath = customRingtone.ringtonePath;
            await playCustomSound(customRingtonePath);
          }
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
          if (customRingtone.isSystemRingtone && customRingtone.ringtoneUri.isNotEmpty) {
            await alarmChannel.invokeMethod('stopDefaultAlarm');
            await SystemRingtoneService.stopSystemRingtone();
            await audioSession!.setActive(false);
            await audioSession!.setActive(true);
            await SystemRingtoneService.playSystemRingtone(customRingtone.ringtoneUri);
            isPreviewing = true;
          } else {
            String customRingtonePath = customRingtone.ringtonePath;
            await alarmChannel.invokeMethod('stopDefaultAlarm');
            await audioSession!.setActive(false);
            await audioSession!.setActive(true);
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
      if (audioSession != null && isPreviewing) {
        await audioPlayer.stop();
        await alarmChannel.invokeMethod('stopDefaultAlarm');
        await SystemRingtoneService.stopSystemRingtone();
        await audioSession!.setActive(false);
        isPreviewing = false;
      }
    } catch (e) {
      debugPrint(e.toString());
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
          
          if (customRingtone != null && customRingtone.isSystemRingtone) {
            await SystemRingtoneService.stopSystemRingtone();
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
          int customRingtoneId = fastHash(ringtoneName);
          RingtoneModel? customRingtone = await IsarDb.getCustomRingtone(
            customRingtoneId: customRingtoneId,
          );
          
          if (customRingtone != null && customRingtone.isSystemRingtone) {
            await SystemRingtoneService.stopSystemRingtone();
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
}
