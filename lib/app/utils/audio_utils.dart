import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'dart:math';

class AudioUtils {
  static final audioPlayer = audioplayer.AudioPlayer();

  static MethodChannel alarmChannel = const MethodChannel('ulticlock');

  static AudioSession? audioSession;

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
    int gradientDurationInSeconds,
  ) async {
    try {
      await FlutterVolumeController.setVolume(
        0.1,
        stream: AudioStream.alarm,
      );
      await Future.delayed(const Duration(milliseconds: 2000));

      await audioPlayer.setReleaseMode(audioplayer.ReleaseMode.loop);
      await audioPlayer.play(audioplayer.DeviceFileSource(customRingtonePath));
      double vol = 0.0;
      double diff = 1.0 - 0.0;
      int len = gradientDurationInSeconds * 1000;
      double steps = (diff / 0.01).abs();
      int stepLen = max(4, (steps > 0) ? len ~/ steps : len);
      int lastTick = DateTime.now().millisecondsSinceEpoch;

      // Update the volume value on each interval ticks
      Timer.periodic(Duration(milliseconds: stepLen), (Timer t) {
        var now = DateTime.now().millisecondsSinceEpoch;
        var tick = (now - lastTick) / len;
        lastTick = now;
        vol += diff * tick;

        vol = max(0, vol);
        vol = min(1, vol);
        vol = (vol * 100).round() / 100;

        FlutterVolumeController.setVolume(
          vol,
          stream: AudioStream.alarm,
        );
        if ((1.0 < 0.0 && vol <= 1.0) || (1.0 > 0.0 && vol >= 1.0)) {
          t.cancel();
          FlutterVolumeController.setVolume(
            vol,
            stream: AudioStream.alarm,
          );
        }
      });
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

      await audioSession!.setActive(true);

      String ringtoneName = alarmRecord.ringtoneName;

      if (ringtoneName == 'Default') {
        await alarmChannel.invokeMethod('playDefaultAlarm');
        await FlutterVolumeController.setVolume(
          0.1,
          stream: AudioStream.alarm,
        );
        await Future.delayed(const Duration(milliseconds: 2000));
        double vol = 0.0;
        double diff = 1.0 - 0.0;
        int len = alarmRecord.gradient * 1000;
        double steps = (diff / 0.01).abs();
        int stepLen = max(4, (steps > 0) ? len ~/ steps : len);
        int lastTick = DateTime.now().millisecondsSinceEpoch;

        Timer.periodic(Duration(milliseconds: stepLen), (Timer t) {
          var now = DateTime.now().millisecondsSinceEpoch;
          var tick = (now - lastTick) / len;
          lastTick = now;
          vol += diff * tick;

          vol = max(0, vol);
          vol = min(1, vol);
          vol = (vol * 100).round() / 100;

          FlutterVolumeController.setVolume(
            vol,
            stream: AudioStream.alarm,
          );
          if ((1.0 < 0.0 && vol <= 1.0) || (1.0 > 0.0 && vol >= 1.0)) {
            t.cancel();
            FlutterVolumeController.setVolume(
              vol,
              stream: AudioStream.alarm,
            );
          }
        });
      } else {
        int customRingtoneId = fastHash(ringtoneName);
        RingtoneModel? customRingtone = await IsarDb.getCustomRingtone(
          customRingtoneId: customRingtoneId,
        );

        if (customRingtone != null) {
          String customRingtonePath = customRingtone.ringtonePath;
          await playCustomSound(customRingtonePath, alarmRecord.gradient);
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
}
