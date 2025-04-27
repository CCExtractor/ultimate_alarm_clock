import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/system_ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ChooseRingtoneTile extends StatelessWidget {
  const ChooseRingtoneTile({
    super.key,
    required this.controller,
    required this.themeController,
    required this.height,
    required this.width,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
        title: Text(
          'Choose Ringtone'.tr,
          style: TextStyle(
            color: themeController.primaryTextColor.value,
          ),
        ),
        onTap: () async {
          Utils.hapticFeedback();
          controller.customRingtoneNames.value = await controller.getAllCustomRingtoneNames();
          
          Get.to(
            () => RingtoneSelectorView(controller: controller),
            transition: Transition.rightToLeft,
          );
        },
        trailing: Container(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  controller.customRingtoneName.value,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: (controller.label.value.trim().isEmpty)
                        ? themeController.primaryDisabledTextColor.value
                        : themeController.primaryTextColor.value,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: (controller.label.value.trim().isEmpty)
                    ? themeController.primaryDisabledTextColor.value
                    : themeController.primaryTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RingtoneSelectorView extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  
  const RingtoneSelectorView({
    Key? key, 
    required this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Scaffold(
      backgroundColor: themeController.primaryBackgroundColor.value,
      appBar: AppBar(
        title: Text(
          'Choose Ringtone'.tr,
          style: TextStyle(
            color: themeController.primaryTextColor.value,
          ),
        ),
        backgroundColor: themeController.primaryBackgroundColor.value,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeController.primaryTextColor.value,
          ),
          onPressed: () {
            controller.stopAllRingtoneAudio();
            Get.back();
          },
        ),
        actions: [
          _UploadButton(controller: controller, themeController: themeController),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(108),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeController.secondaryBackgroundColor.value,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    onChanged: controller.updateRingtoneSearchQuery,
                    style: TextStyle(
                      color: themeController.primaryTextColor.value,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search ringtones'.tr,
                      hintStyle: TextStyle(
                        color: themeController.primaryTextColor.value.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: themeController.primaryTextColor.value.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              
              _TabBar(controller: controller, themeController: themeController),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.ringtoneTabController,
        children: [
          _CustomRingtonesTab(controller: controller, themeController: themeController),
          _SystemRingtonesTab(controller: controller, themeController: themeController),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  const _UploadButton({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.selectedRingtoneTabIndex.value == 0
      ? IconButton(
          icon: Icon(
            Icons.upload_file,
            color: themeController.primaryTextColor.value,
          ),
          onPressed: () => controller.saveCustomRingtone(),
          tooltip: 'Upload Ringtone'.tr,
        )
      : Container(),
    );
  }
}

class _TabBar extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  const _TabBar({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller.ringtoneTabController,
      indicatorColor: kprimaryColor,
      indicatorWeight: 3,
      labelColor: kprimaryColor,
      unselectedLabelColor: themeController.primaryTextColor.value.withOpacity(0.7),
      tabs: [
        _TabItem(
          controller: controller,
          themeController: themeController,
          tabIndex: 0,
          icon: Icons.music_note,
          label: 'My Ringtones'.tr,
        ),
        _TabItem(
          controller: controller,
          themeController: themeController,
          tabIndex: 1,
          icon: Icons.phone_android,
          label: 'System Sounds'.tr,
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final int tabIndex;
  final IconData icon;
  final String label;

  const _TabItem({
    Key? key,
    required this.controller,
    required this.themeController,
    required this.tabIndex,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Obx(() => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            size: 16, 
            color: controller.selectedRingtoneTabIndex.value == tabIndex 
                ? kprimaryColor 
                : themeController.primaryTextColor.value.withOpacity(0.7)
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: controller.selectedRingtoneTabIndex.value == tabIndex 
                  ? FontWeight.bold 
                  : FontWeight.normal,
            ),
          ),
        ],
      )),
    );
  }
}

class _CustomRingtonesTab extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  const _CustomRingtonesTab({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredRingtones = controller.getFilteredCustomRingtones();
      
      if (filteredRingtones.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note_outlined,
                size: 64,
                color: themeController.primaryTextColor.value.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                controller.searchQuery.isEmpty
                    ? 'No ringtones available'.tr
                    : 'No ringtones match your search'.tr,
                style: TextStyle(
                  color: themeController.primaryTextColor.value.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: filteredRingtones.length,
        itemBuilder: (context, index) {
          final ringtoneName = filteredRingtones[index];
          return _CustomRingtoneItem(
            controller: controller,
            themeController: themeController,
            ringtoneName: ringtoneName,
            index: index,
          );
        },
      );
    });
  }
}

class _CustomRingtoneItem extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final String ringtoneName;
  final int index;

  const _CustomRingtoneItem({
    Key? key,
    required this.controller,
    required this.themeController,
    required this.ringtoneName,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.customRingtoneName.value == ringtoneName;
      final isPlaying = controller.isRingtonePlaying.value && controller.currentlyPlayingCustomRingtone.value == ringtoneName;
      final isDefault = defaultRingtones.contains(ringtoneName);
      final isSystemRingtone = controller.isSystemRingtone(ringtoneName);
      final showDelete = !isDefault && (!isSystemRingtone || !isDefault);
      
      return Card(
        elevation: 0,
        color: themeController.secondaryBackgroundColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? BorderSide(color: kprimaryColor, width: 2)
              : BorderSide.none,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.selectCustomRingtone(ringtoneName),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isPlaying ? kprimaryColor : themeController.secondaryBackgroundColor.value,
                    shape: BoxShape.circle,
                    border: Border.all(color: kprimaryColor, width: 2),
                  ),
                  child: controller.isProcessingAudio.value && controller.currentlyPlayingCustomRingtone.value == ringtoneName
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isPlaying ? Colors.black : kprimaryColor
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            isPlaying ? Icons.stop : Icons.play_arrow,
                            color: isPlaying ? Colors.black : kprimaryColor,
                            size: 24,
                          ),
                          onPressed: () => controller.previewCustomRingtone(ringtoneName),
                        ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ringtoneName,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: themeController.primaryBackgroundColor.value,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: kprimaryColor),
                          ),
                          child: Text(
                            'Currently selected'.tr,
                            style: TextStyle(
                              color: kprimaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isSystemRingtone && !isSelected)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'System Sound'.tr,
                            style: TextStyle(
                              color: themeController.primaryTextColor.value.withOpacity(0.5),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                if (showDelete)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      controller.stopAllRingtoneAudio();
                      
                      bool confirm = await Get.dialog(
                        AlertDialog(
                          backgroundColor: themeController.secondaryBackgroundColor.value,
                          title: Text(
                            'Delete Ringtone'.tr,
                            style: TextStyle(color: themeController.primaryTextColor.value),
                          ),
                          content: Text(
                            isSystemRingtone
                                ? 'Are you sure you want to remove this system sound? This will only remove it from your list, not from your device.'.tr
                                : 'Are you sure you want to delete this ringtone?'.tr,
                            style: TextStyle(color: themeController.primaryTextColor.value),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: Text(
                                'Cancel'.tr,
                                style: const TextStyle(color: kprimaryColor),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Get.back(result: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'Delete'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ) ?? false;
                      
                      if (confirm) {
                        await controller.deleteCustomRingtone(
                          ringtoneName: ringtoneName,
                          ringtoneIndex: index,
                          forceDelete: isSystemRingtone,
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _SystemRingtonesTab extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  const _SystemRingtonesTab({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: themeController.secondaryBackgroundColor.value,
          child: TabBar(
            controller: controller.systemSoundsTabController,
            indicatorColor: kprimaryColor,
            labelColor: Colors.black,
            unselectedLabelColor: themeController.primaryTextColor.value,
            indicator: BoxDecoration(
              color: kprimaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tabs: [
              _SystemSoundTabItem(
                controller: controller,
                themeController: themeController,
                tabIndex: 0,
                label: 'Alarms'.tr,
              ),
              _SystemSoundTabItem(
                controller: controller,
                themeController: themeController,
                tabIndex: 1,
                label: 'Notifications'.tr,
                useFittedBox: true,
              ),
              _SystemSoundTabItem(
                controller: controller,
                themeController: themeController,
                tabIndex: 2,
                label: 'Ringtones'.tr,
              ),
            ],
          ),
        ),
        
        Expanded(
          child: _SystemRingtonesContent(
            controller: controller,
            themeController: themeController,
          ),
        ),
      ],
    );
  }
}

class _SystemSoundTabItem extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final int tabIndex;
  final String label;
  final bool useFittedBox;

  const _SystemSoundTabItem({
    Key? key,
    required this.controller,
    required this.themeController,
    required this.tabIndex,
    required this.label,
    this.useFittedBox = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Obx(() {
        final textWidget = Text(
          label,
          style: TextStyle(
            fontWeight: controller.selectedSystemSoundsTabIndex.value == tabIndex 
                ? FontWeight.bold 
                : FontWeight.normal,
          ),
        );
        
        return useFittedBox
            ? FittedBox(fit: BoxFit.scaleDown, child: textWidget)
            : textWidget;
      }),
    );
  }
}

class _SystemRingtonesContent extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  const _SystemRingtonesContent({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.systemRingtones.value == null) {
        return const Center(child: CircularProgressIndicator(color: kprimaryColor));
      }
      
      final categorizedRingtones = controller.getCategorizedSystemRingtones();
      
      return TabBarView(
        controller: controller.systemSoundsTabController,
        children: [
          _RingtonesList(
            controller: controller,
            themeController: themeController,
            ringtones: categorizedRingtones['alarm']!, 
            emptyMessage: 'No alarm sounds found'.tr,
          ),
          _RingtonesList(
            controller: controller,
            themeController: themeController,
            ringtones: categorizedRingtones['notification']!, 
            emptyMessage: 'No notification sounds found'.tr,
          ),
          _RingtonesList(
            controller: controller,
            themeController: themeController,
            ringtones: categorizedRingtones['ringtone']!, 
            emptyMessage: 'No ringtones found'.tr,
          ),
        ],
      );
    });
  }
}

class _RingtonesList extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final List<SystemRingtone> ringtones;
  final String emptyMessage;

  const _RingtonesList({
    Key? key,
    required this.controller,
    required this.themeController,
    required this.ringtones,
    required this.emptyMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ringtones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off,
              size: 64,
              color: themeController.primaryTextColor.value.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              controller.searchQuery.isEmpty ? emptyMessage : 'No sounds match your search'.tr,
              style: TextStyle(
                color: themeController.primaryTextColor.value.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: ringtones.length,
      itemBuilder: (context, index) {
        return _SystemRingtoneItem(
          controller: controller,
          themeController: themeController,
          ringtone: ringtones[index],
        );
      },
    );
  }
}

class _SystemRingtoneItem extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final SystemRingtone ringtone;

  const _SystemRingtoneItem({
    Key? key,
    required this.controller,
    required this.themeController,
    required this.ringtone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPlaying = controller.isRingtonePlaying.value && controller.currentlyPlayingSystemRingtone.value == ringtone;
      
      return Card(
        elevation: 0,
        color: themeController.secondaryBackgroundColor.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.selectSystemRingtone(ringtone),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isPlaying ? kprimaryColor : themeController.secondaryBackgroundColor.value,
                    shape: BoxShape.circle,
                    border: Border.all(color: kprimaryColor, width: 2),
                  ),
                  child: controller.isProcessingAudio.value && controller.currentlyPlayingSystemRingtone.value == ringtone
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isPlaying ? Colors.black : kprimaryColor
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            isPlaying ? Icons.stop : Icons.play_arrow,
                            color: isPlaying ? Colors.black : kprimaryColor,
                            size: 24,
                          ),
                          onPressed: () => controller.previewSystemRingtone(ringtone),
                        ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ringtone.title,
                        style: TextStyle(
                          color: themeController.primaryTextColor.value,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        formatCategory(ringtone.category),
                        style: TextStyle(
                          color: themeController.primaryTextColor.value.withOpacity(0.5),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                
                ElevatedButton(
                  onPressed: () => controller.selectSystemRingtone(ringtone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Select'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
} 