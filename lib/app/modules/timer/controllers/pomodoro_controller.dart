import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/views/pomodoro_completion_view.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum TimerType { work, Break }

class PomodoroController extends GetxController {
  RxInt selectedWorkTime = 45.obs; // Default work time in minutes
  RxInt selectedBreakTime = 15.obs; // Default break time in minutes
  RxString selectedLabel = "Work".obs;
  RxBool isRunning = false.obs;
  RxBool isBreakTime = false.obs;
  RxInt remainingSeconds = 0.obs;
  Timer? timer;
  
  // Added number of intervals feature
  RxInt selectedIntervals = 4.obs; // Default intervals
  RxInt currentInterval = 0.obs; // Current interval tracker

  final AudioPlayer audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();
  
  // For custom labels
  RxList<String> labelOptions = ["Work", "Study", "Sleep", "Focus", "Create"].obs;
  TextEditingController newLabelController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    remainingSeconds.value = selectedWorkTime.value * 60;
    _initAudioPlayer();
    _initNotifications();
  }

  @override
  void onClose() {
    timer?.cancel();
    newLabelController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }
  
  // Initialize the audio player
  void _initAudioPlayer() async {
    // Pre-load sounds for faster playback when needed
    await audioPlayer.setSource(AssetSource('ringtones/work_complete.mp3'));
  }
  
  // Play notification sound
  void playNotificationSound(bool isBreakFinished) async {
    try {
      // Different sounds for work end and break end
      if (isBreakFinished) {
        await audioPlayer.setSource(AssetSource('ringtones/break_complete.mp3'));
      } else {
        await audioPlayer.setSource(AssetSource('ringtones/work_complete.mp3'));
      }
      
      await audioPlayer.resume();
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }
  
  // Initialize notifications
  Future<void> _initNotifications() async {
    // Initialize settings
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      
    const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
      
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Method to show notification
  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'pomodoro_timer_channel',
        'Pomodoro Timer Notifications',
        channelDescription: 'Notifications for pomodoro timer events',
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      );
      
    const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void startTimer() {
    isRunning.value = true;
    if (currentInterval.value == 0) {
      // First start - reset interval counter
      currentInterval.value = 1;
    }
    
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        // Timer completed
        if (isBreakTime.value) {
          // Break time finished - play break end sound
          playNotificationSound(true);
          _showLocalNotification(
            'Break Time Complete', 
            'Time to focus for ${selectedWorkTime.value} minutes!'
          );
          
          // Break time finished
          currentInterval.value++;
          
          // Check if we've completed all intervals
          if (currentInterval.value > selectedIntervals.value) {
            // All intervals completed
            timer.cancel();
            isRunning.value = false;
            isBreakTime.value = false;
            currentInterval.value = 0;
            remainingSeconds.value = selectedWorkTime.value * 60;
            Get.off(() => CompletionScreen(type: 'all', duration: selectedWorkTime.value * selectedIntervals.value));
            return;
          }
          
          // Still have intervals to go, switch to work time
          isBreakTime.value = false;
          remainingSeconds.value = selectedWorkTime.value * 60;
          Get.off(() => CompletionScreen(type: 'break', duration: selectedBreakTime.value, currentInterval: currentInterval.value, totalIntervals: selectedIntervals.value));
        } else {
          // Work time finished - play work end sound
          playNotificationSound(false);
          _showLocalNotification(
            'Work Time Complete', 
            'Time for a ${selectedBreakTime.value} minute break!'
          );
          
          // Check if it's the last interval, if so, no break needed
          if (currentInterval.value >= selectedIntervals.value) {
            // All intervals completed
            timer.cancel();
            isRunning.value = false;
            isBreakTime.value = false;
            currentInterval.value = 0;
            remainingSeconds.value = selectedWorkTime.value * 60;
            Get.off(() => CompletionScreen(type: 'all', duration: selectedWorkTime.value * selectedIntervals.value));
            return;
          }
          
          // Not the last interval, switch to break time
          isBreakTime.value = true;
          remainingSeconds.value = selectedBreakTime.value * 60;
          Get.off(() => CompletionScreen(type: 'work', duration: selectedWorkTime.value, currentInterval: currentInterval.value, totalIntervals: selectedIntervals.value));
        }
      }
    });
  }

  void stopTimer() {
    Get.defaultDialog(
      title: "Give Up?",
      middleText: "Are you sure you want to give up this session?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: kprimaryColor,
      backgroundColor: Colors.white,
      titleStyle: TextStyle(color: Colors.black),
      middleTextStyle: TextStyle(color: Colors.black54),
      onConfirm: () {
        timer?.cancel();
        isRunning.value = false;
        isBreakTime.value = false;
        currentInterval.value = 0;
        remainingSeconds.value = selectedWorkTime.value * 60;
        Get.back(); // Close Dialog
      },
      onCancel: () {
        Get.back(); // Close Dialog
      },
    );
  }

  void setWorkTime(int minutes) {
    selectedWorkTime.value = minutes;
    if (!isRunning.value && !isBreakTime.value) {
      remainingSeconds.value = minutes * 60;
    }
  }

  void setBreakTime(int minutes) {
    selectedBreakTime.value = minutes;
  }
  
  void setIntervals(int intervals) {
    selectedIntervals.value = intervals;
  }

  void setLabel(String label) {
    selectedLabel.value = label;
  }
  
  void addCustomLabel(String label) {
    if (label.isNotEmpty && !labelOptions.contains(label)) {
      labelOptions.add(label);
      selectedLabel.value = label;
    }
    newLabelController.clear();
  }

  String get formattedTime {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
  
  String get progressText {
    return isBreakTime.value 
        ? "Break ${currentInterval.value}/${selectedIntervals.value}" 
        : "Session ${currentInterval.value}/${selectedIntervals.value}";
  }
}