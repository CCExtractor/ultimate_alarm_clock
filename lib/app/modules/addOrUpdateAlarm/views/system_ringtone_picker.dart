import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/system_ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/system_ringtone_service.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';

class SystemRingtonePicker extends GetView<AddOrUpdateAlarmController> {
  final bool isFullScreen;
  final ThemeController themeController = Get.find<ThemeController>();

  SystemRingtonePicker({
    super.key,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.categorizedSystemRingtones.isEmpty) {
      _loadSystemRingtones();
    }

    if (isFullScreen) {
      return Column(
        children: [
          Expanded(
            child: Obx(() => controller.isSystemRingtonesLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: kprimaryColor,
                    ),
                  )
                : DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: kprimaryColor,
                          unselectedLabelColor: themeController.primaryTextColor.value,
                          indicatorColor: kprimaryColor,
                          tabs: const [
                            Tab(text: 'Alarms'),
                            Tab(text: 'Notifications'),
                            Tab(text: 'Ringtones'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildRingtoneList(controller.categorizedSystemRingtones['alarm'] ?? []),
                              _buildRingtoneList(controller.categorizedSystemRingtones['notification'] ?? []),
                              _buildRingtoneList(controller.categorizedSystemRingtones['ringtone'] ?? []),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        width: Get.width * 0.9,
        height: Get.height * 0.6,
        child: Column(
          children: [
            TabBar(
              labelColor: kprimaryColor,
              unselectedLabelColor: themeController.primaryTextColor.value,
              indicatorColor: kprimaryColor,
              tabs: const [
                Tab(text: 'Alarms'),
                Tab(text: 'Notifications'),
                Tab(text: 'Ringtones'),
              ],
            ),
            Expanded(
              child: Obx(() => controller.isSystemRingtonesLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: kprimaryColor,
                      ),
                    )
                  : TabBarView(
                      children: [
                        _buildRingtoneList(controller.categorizedSystemRingtones['alarm'] ?? []),
                        _buildRingtoneList(controller.categorizedSystemRingtones['notification'] ?? []),
                        _buildRingtoneList(controller.categorizedSystemRingtones['ringtone'] ?? []),
                      ],
                    ),
              ),
            ),
            if (!isFullScreen)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        await SystemRingtoneService.testAudio();
                      },
                      child: Text(
                        'Test Audio System',
                        style: TextStyle(color: kprimaryColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        Utils.hapticFeedback();
                        await SystemRingtoneService.stopSystemRingtone();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                      ),
                      child: Text(
                        'Done'.tr,
                        style: TextStyle(
                          color: themeController.secondaryTextColor.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }

  Future<void> _loadSystemRingtones() async {
    try {
      controller.isSystemRingtonesLoading.value = true;
      final ringtones = await SystemRingtoneService.getSystemRingtonesByCategory();
      controller.categorizedSystemRingtones.value = ringtones;
      controller.isSystemRingtonesLoading.value = false;
    } catch (e) {
      controller.isSystemRingtonesLoading.value = false;
      debugPrint('Error loading system ringtones: $e');
    }
  }

  Future<void> _playPreview(SystemRingtoneModel ringtone) async {
    Utils.hapticFeedback();
    
    if (controller.playingSystemRingtoneUri.value == ringtone.uri) {
      await SystemRingtoneService.stopSystemRingtone();
      controller.playingSystemRingtoneUri.value = '';
    } else {
      await SystemRingtoneService.stopSystemRingtone();
      await SystemRingtoneService.playSystemRingtone(ringtone.uri);
      controller.playingSystemRingtoneUri.value = ringtone.uri;
      
      Future.delayed(const Duration(seconds: 10), () async {
        if (controller.playingSystemRingtoneUri.value == ringtone.uri) {
          await SystemRingtoneService.stopSystemRingtone();
          controller.playingSystemRingtoneUri.value = '';
        }
      });
    }
  }

  Widget _buildRingtoneList(List<SystemRingtoneModel> ringtones) {
    if (ringtones.isEmpty) {
      return Center(
        child: Text(
          'No ringtones found',
          style: TextStyle(
            color: themeController.primaryTextColor.value,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: isFullScreen 
          ? const EdgeInsets.all(16) 
          : const EdgeInsets.symmetric(horizontal: 8),
      itemCount: ringtones.length,
      itemBuilder: (context, index) {
        final ringtone = ringtones[index];
        return Obx(() {
          final isSelected = controller.customRingtoneName.value == ringtone.title;
          final isPlaying = controller.playingSystemRingtoneUri.value == ringtone.uri;

          return Container(
            margin: isFullScreen 
                ? const EdgeInsets.only(bottom: 8)
                : const EdgeInsets.only(bottom: 4),
            decoration: isFullScreen ? BoxDecoration(
              color: isSelected
                  ? kprimaryColor.withOpacity(0.1)
                  : themeController.primaryBackgroundColor.value,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? kprimaryColor
                    : themeController.primaryTextColor.value.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ) : null,
            child: ListTile(
              contentPadding: isFullScreen 
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              leading: isFullScreen ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? kprimaryColor : themeController.primaryTextColor.value.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.phone_android,
                  color: isSelected ? Colors.white : themeController.primaryTextColor.value,
                  size: 20,
                ),
              ) : null,
              title: Text(
                ringtone.title,
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: isFullScreen ? 16 : 14,
                ),
              ),
              tileColor: !isFullScreen && isSelected
                  ? themeController.primaryBackgroundColor.value
                  : themeController.secondaryBackgroundColor.value,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _playPreview(ringtone),
                    icon: Icon(
                      isPlaying ? Icons.stop_circle : Icons.play_circle,
                      color: isPlaying ? Colors.red : kprimaryColor,
                      size: isFullScreen ? 28 : 24,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                Utils.hapticFeedback();
                await SystemRingtoneService.stopSystemRingtone();
                controller.playingSystemRingtoneUri.value = '';
                
                final previousRingtone = controller.customRingtoneName.value;
                
                controller.customRingtoneName.value = ringtone.title;
         
                await _saveSystemRingtone(ringtone, previousRingtone);
              },
            ),
          );
        });
      },
    );
  }

  Future<void> _saveSystemRingtone(SystemRingtoneModel ringtone, String previousRingtone) async {
    try {
      if (ringtone.title != previousRingtone) {
        if (previousRingtone.isNotEmpty && previousRingtone != 'Default') {
          await AudioUtils.updateRingtoneCounterOfUsage(
            customRingtoneName: previousRingtone,
            counterUpdate: CounterUpdate.decrement,
          );
        }
        
        final ringtoneId = AudioUtils.fastHash(ringtone.title);
        final existingRingtone = await IsarDb.getCustomRingtone(customRingtoneId: ringtoneId);
        
        if (existingRingtone != null) {
          await AudioUtils.updateRingtoneCounterOfUsage(
            customRingtoneName: ringtone.title,
            counterUpdate: CounterUpdate.increment,
          );
        } else {
          final ringtoneModel = RingtoneModel(
            ringtoneName: ringtone.title,
            ringtonePath: '', 
            currentCounterOfUsage: 1,
            isSystemRingtone: true,
            ringtoneUri: ringtone.uri,
            category: ringtone.category,
          );
          
          await IsarDb.addCustomRingtone(ringtoneModel);
        }
      }
    } catch (e) {
      debugPrint('Error saving system ringtone: $e');
    }
  }
} 