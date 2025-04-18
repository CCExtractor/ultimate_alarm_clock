import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/system_ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:ultimate_alarm_clock/app/data/models/ringtone_model.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:flutter/foundation.dart';

String formatCategory(String category) {
  if (category.isEmpty) return category;
  return category.tr.capitalizeFirst ?? category;
}

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
          
          // Navigate to the ringtone selector page
          Get.to(
            () => RingtoneSelectorPage(
              controller: controller,
              themeController: themeController,
            ),
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

class RingtoneSelectorPage extends StatefulWidget {
  const RingtoneSelectorPage({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  State<RingtoneSelectorPage> createState() => _RingtoneSelectorPageState();
}

class _RingtoneSelectorPageState extends State<RingtoneSelectorPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _systemSoundsTabController;
  String _searchQuery = '';
  bool _isPlaying = false;
  SystemRingtone? _currentlyPlayingSystemRingtone;
  String? _currentlyPlayingCustomRingtone;
  int _selectedTabIndex = 0;
  
  // Add variables to track audio playback state
  bool _isProcessingAudio = false;
  DateTime _lastAudioRequest = DateTime.now();
  Future<List<SystemRingtone>>? _systemRingtonesFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _systemSoundsTabController = TabController(length: 3, vsync: this);
    
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
      _stopAllAudio();
    });
    
    _systemSoundsTabController.addListener(() {
      _stopAllAudio();
    });
    
    // Set initial values
    _isPlaying = widget.controller.isPlaying.value;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _systemSoundsTabController.dispose();
    _stopAllAudio();
    super.dispose();
  }

  // Improved audio control with await and debouncing
  Future<void> _stopAllAudio() async {
    if (_isProcessingAudio) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    setState(() => _isProcessingAudio = true);
    
    for (int i = 0; i < 3; i++) {
      await AudioUtils.stopPreviewCustomSound();
      const platform = MethodChannel('ulticlock');
      await platform.invokeMethod('stopDefaultAlarm');
      break;
    }
    
    widget.controller.isPlaying.value = false;
    setState(() {
      _isPlaying = false;
      _currentlyPlayingSystemRingtone = null;
      _currentlyPlayingCustomRingtone = null;
    });
    
    setState(() => _isProcessingAudio = false);
  }

  // Improved custom ringtone playback with debounce and async handling
  Future<void> _onTapPreviewCustom(String ringtoneName) async {
    Utils.hapticFeedback();
    
    // Ignore rapid taps
    final now = DateTime.now();
    if (now.difference(_lastAudioRequest).inMilliseconds < 300) {
      return;
    }
    _lastAudioRequest = now;
    
    // If we're currently processing an audio request, ignore
    if (_isProcessingAudio) {
      return;
    }
    
    setState(() => _isProcessingAudio = true);
    
    if (_isPlaying && _currentlyPlayingCustomRingtone == ringtoneName) {
      await _stopAllAudio();
    } else {
      if (_isPlaying) {
        await AudioUtils.stopPreviewCustomSound();
      }
      await AudioUtils.previewCustomSound(ringtoneName);
      setState(() {
        _isPlaying = true;
        _currentlyPlayingCustomRingtone = ringtoneName;
        _currentlyPlayingSystemRingtone = null;
        widget.controller.isPlaying.value = true;
      });
    }
    
    setState(() => _isProcessingAudio = false);
  }

  // Improved system ringtone playback with debounce and async handling
  Future<void> _onTapPreviewSystem(SystemRingtone ringtone) async {
    Utils.hapticFeedback();
    
    // If already playing this ringtone, stop it and exit early
    if (_isPlaying && _currentlyPlayingSystemRingtone == ringtone) {
      setState(() => _isProcessingAudio = true);
      await _stopAllAudio();
      setState(() {
        _isPlaying = false;
        _currentlyPlayingSystemRingtone = null;
        _isProcessingAudio = false;
      });
      return;
    }
    
    // If another ringtone is playing, stop it first
    // This is critical - we need to fully stop any playing audio before starting a new one
    if (_isPlaying) {
      await _stopAllAudio();
      // Small but important delay to ensure audio resources are freed
      await Future.delayed(const Duration(milliseconds: 200));
    }
    
    // Ignore rapid taps
    final now = DateTime.now();
    if (now.difference(_lastAudioRequest).inMilliseconds < 500) {
      return;
    }
    _lastAudioRequest = now;
    
    // If we're currently processing an audio request, ignore
    if (_isProcessingAudio) {
      return;
    }
    
    setState(() {
      _isProcessingAudio = true;
      // Show loading state immediately
      _currentlyPlayingSystemRingtone = ringtone;
    });
    
    await _playSystemRingtone(ringtone);
    
    setState(() {
      _isPlaying = true;
      _currentlyPlayingCustomRingtone = null;
      _isProcessingAudio = false;
    });
  }

  Future<void> _playSystemRingtone(SystemRingtone ringtone) async {
    await _ensureAudioStopped();
    const platform = MethodChannel('ulticlock');
    await platform.invokeMethod('playSystemRingtone', {'uri': ringtone.uri});
  }
  
  // New method to ensure audio is fully stopped before playing
  Future<void> _ensureAudioStopped() async {
    await AudioUtils.stopPreviewCustomSound();
    const platform = MethodChannel('ulticlock');
    await platform.invokeMethod('stopDefaultAlarm');
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeController.primaryBackgroundColor.value,
      appBar: AppBar(
        title: Text(
          'Choose Ringtone'.tr,
          style: TextStyle(
            color: widget.themeController.primaryTextColor.value,
          ),
        ),
        backgroundColor: widget.themeController.primaryBackgroundColor.value,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.themeController.primaryTextColor.value,
          ),
          onPressed: () {
            _stopAllAudio();
            Get.back();
          },
        ),
        actions: [
          if (_selectedTabIndex == 0)
            IconButton(
              icon: Icon(
                Icons.upload_file,
                color: widget.themeController.primaryTextColor.value,
              ),
              onPressed: () async {
                _stopAllAudio();
                widget.controller.previousRingtone = widget.controller.customRingtoneName.value;
                await widget.controller.saveCustomRingtone();
                // Refresh the list after upload
                widget.controller.customRingtoneNames.value = 
                    await widget.controller.getAllCustomRingtoneNames();
                setState(() {});
              },
              tooltip: 'Upload Ringtone'.tr,
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(108),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.themeController.secondaryBackgroundColor.value,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    onChanged: _onSearch,
                    style: TextStyle(
                      color: widget.themeController.primaryTextColor.value,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search ringtones'.tr,
                      hintStyle: TextStyle(
                        color: widget.themeController.primaryTextColor.value.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: widget.themeController.primaryTextColor.value.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              
              // Tab bar with improved contrast
              TabBar(
                controller: _tabController,
                indicatorColor: kprimaryColor,
                indicatorWeight: 3,
                labelColor: kprimaryColor,
                unselectedLabelColor: widget.themeController.primaryTextColor.value.withOpacity(0.7),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.music_note, size: 16, color: _tabController.index == 0 ? kprimaryColor : widget.themeController.primaryTextColor.value.withOpacity(0.7)),
                        const SizedBox(width: 8),
                        Text(
                          'My Ringtones'.tr,
                          style: TextStyle(
                            fontWeight: _tabController.index == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_android, size: 16, color: _tabController.index == 1 ? kprimaryColor : widget.themeController.primaryTextColor.value.withOpacity(0.7)),
                        const SizedBox(width: 8),
                        Text(
                          'System Sounds'.tr,
                          style: TextStyle(
                            fontWeight: _tabController.index == 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Custom ringtones tab
          _buildCustomRingtonesTab(),
          
          // System ringtones tab
          _buildSystemRingtonesTab(),
        ],
      ),
    );
  }

  Widget _buildCustomRingtonesTab() {
    // Filter ringtones based on search query
    final filteredRingtones = _searchQuery.isEmpty
        ? widget.controller.customRingtoneNames
        : widget.controller.customRingtoneNames
            .where((name) => name.toLowerCase().contains(_searchQuery))
            .toList();

    return Obx(
      () => filteredRingtones.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note_outlined,
                    size: 64,
                    color: widget.themeController.primaryTextColor.value.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No ringtones available'.tr
                        : 'No ringtones match your search'.tr,
                    style: TextStyle(
                      color: widget.themeController.primaryTextColor.value.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: filteredRingtones.length,
              itemBuilder: (context, index) {
                final ringtoneName = filteredRingtones[index];
                final isSelected = widget.controller.customRingtoneName.value == ringtoneName;
                final isPlaying = _isPlaying && _currentlyPlayingCustomRingtone == ringtoneName;
                final isDefault = defaultRingtones.contains(ringtoneName);
                
                // Check if it's a system ringtone (non-default)
                final isSystemRingtone = _isSystemRingtone(ringtoneName);
                
                // Only show delete for custom ringtones or non-default system ringtones
                final showDelete = !isDefault && (!isSystemRingtone || !isDefault);
                
                return Card(
                  elevation: 0,
                  color: widget.themeController.secondaryBackgroundColor.value,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isSelected
                        ? BorderSide(color: kprimaryColor, width: 2)
                        : BorderSide.none,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      Utils.hapticFeedback();
                      await _stopAllAudio();
                      
                      // Update controller
                      widget.controller.previousRingtone = widget.controller.customRingtoneName.value;
                      widget.controller.customRingtoneName.value = ringtoneName;

                      // Update usage counters if changed
                      if (widget.controller.customRingtoneName.value != widget.controller.previousRingtone) {
                        await AudioUtils.updateRingtoneCounterOfUsage(
                          customRingtoneName: widget.controller.customRingtoneName.value,
                          counterUpdate: CounterUpdate.increment,
                        );

                        await AudioUtils.updateRingtoneCounterOfUsage(
                          customRingtoneName: widget.controller.previousRingtone,
                          counterUpdate: CounterUpdate.decrement,
                        );
                      }
                      
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Play/pause button with improved contrast
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isPlaying ? kprimaryColor : widget.themeController.secondaryBackgroundColor.value,
                              shape: BoxShape.circle,
                              border: Border.all(color: kprimaryColor, width: 2),
                            ),
                            child: _isProcessingAudio && _currentlyPlayingCustomRingtone == ringtoneName
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
                                    onPressed: () => _onTapPreviewCustom(ringtoneName),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Ringtone name with improved contrast
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ringtoneName,
                                  style: TextStyle(
                                    color: widget.themeController.primaryTextColor.value,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: widget.themeController.primaryBackgroundColor.value,
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
                                        color: widget.themeController.primaryTextColor.value.withOpacity(0.5),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          // Delete button for custom ringtones
                          if (showDelete)
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                // Stop any playing audio first
                                _stopAllAudio();
                                
                                // Show confirmation dialog
                                bool confirm = await Get.dialog(
                                  AlertDialog(
                                    backgroundColor: widget.themeController.secondaryBackgroundColor.value,
                                    title: Text(
                                      'Delete Ringtone'.tr,
                                      style: TextStyle(color: widget.themeController.primaryTextColor.value),
                                    ),
                                    content: Text(
                                      isSystemRingtone
                                          ? 'Are you sure you want to remove this system sound? This will only remove it from your list, not from your device.'.tr
                                          : 'Are you sure you want to delete this ringtone?'.tr,
                                      style: TextStyle(color: widget.themeController.primaryTextColor.value),
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
                                  // Directly use forceDelete=true for system ringtones to avoid the second dialog
                                  await widget.controller.deleteCustomRingtone(
                                    ringtoneName: ringtoneName,
                                    ringtoneIndex: index,
                                    forceDelete: isSystemRingtone,
                                  );
                                  
                                  setState(() {});
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Helper function to check if a ringtone is a system ringtone
  bool _isSystemRingtone(String ringtoneName) {
    // We're only checking if it's not in default ringtones
    // No need to compute the hash if we're not using it
    return !(defaultRingtones.contains(ringtoneName));
  }

  Widget _buildSystemRingtonesTab() {
    return Column(
      children: [
        // Category tabs with improved contrast
        Container(
          color: widget.themeController.secondaryBackgroundColor.value,
          child: TabBar(
            controller: _systemSoundsTabController,
            indicatorColor: kprimaryColor,
            labelColor: Colors.black,
            unselectedLabelColor: widget.themeController.primaryTextColor.value,
            indicator: BoxDecoration(
              color: kprimaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tabs: [
              Tab(
                child: Text(
                  'Alarms'.tr,
                  style: TextStyle(
                    fontWeight: _systemSoundsTabController.index == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Notifications'.tr,
                  style: TextStyle(
                    fontWeight: _systemSoundsTabController.index == 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Ringtones'.tr,
                  style: TextStyle(
                    fontWeight: _systemSoundsTabController.index == 2 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // System sounds by category
        Expanded(
          child: FutureBuilder<List<SystemRingtone>>(
            future: _systemRingtonesFuture ??= AudioUtils.getSystemRingtones(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: kprimaryColor));
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading ringtones'.tr,
                        style: TextStyle(color: widget.themeController.primaryTextColor.value, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
              
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.music_off,
                        size: 64,
                        color: widget.themeController.primaryTextColor.value.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No system ringtones found'.tr,
                        style: TextStyle(
                          color: widget.themeController.primaryTextColor.value.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Group ringtones by category
              final Map<String, List<SystemRingtone>> categorizedRingtones = {
                'alarm': snapshot.data!.where((r) => r.category == 'alarm').toList(),
                'notification': snapshot.data!.where((r) => r.category == 'notification').toList(),
                'ringtone': snapshot.data!.where((r) => r.category == 'ringtone').toList(),
              };
              
              // Apply search filter to all categories
              if (_searchQuery.isNotEmpty) {
                categorizedRingtones.forEach((category, ringtones) {
                  categorizedRingtones[category] = ringtones
                      .where((r) => r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                });
              }
              
              return TabBarView(
                controller: _systemSoundsTabController,
                children: [
                  _buildRingtonesList(
                    categorizedRingtones['alarm']!, 
                    'No alarm sounds found'.tr,
                  ),
                  _buildRingtonesList(
                    categorizedRingtones['notification']!, 
                    'No notification sounds found'.tr,
                  ),
                  _buildRingtonesList(
                    categorizedRingtones['ringtone']!, 
                    'No ringtones found'.tr,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildRingtonesList(List<SystemRingtone> ringtones, String emptyMessage) {
    if (ringtones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off,
              size: 64,
              color: widget.themeController.primaryTextColor.value.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? emptyMessage : 'No sounds match your search'.tr,
              style: TextStyle(
                color: widget.themeController.primaryTextColor.value.withOpacity(0.7),
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
        final ringtone = ringtones[index];
        final isPlaying = _isPlaying && _currentlyPlayingSystemRingtone == ringtone;
        
        return Card(
          elevation: 0,
          color: widget.themeController.secondaryBackgroundColor.value,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              Utils.hapticFeedback();
              await _stopAllAudio();
              
              // Save the selected ringtone
              await AudioUtils.saveSystemRingtone(
                title: ringtone.title,
                uri: ringtone.uri,
                category: ringtone.category,
              );
              
              // Update the controller
              widget.controller.previousRingtone = widget.controller.customRingtoneName.value;
              widget.controller.customRingtoneName.value = ringtone.title;
              
              // Update usage counters
              await AudioUtils.updateRingtoneCounterOfUsage(
                customRingtoneName: widget.controller.customRingtoneName.value,
                counterUpdate: CounterUpdate.increment,
              );
              
              await AudioUtils.updateRingtoneCounterOfUsage(
                customRingtoneName: widget.controller.previousRingtone,
                counterUpdate: CounterUpdate.decrement,
              );
              
              // Refresh the ringtone list
              widget.controller.customRingtoneNames.value = 
                  await widget.controller.getAllCustomRingtoneNames();
              
              // Go back to the alarm screen
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Improved play button with better contrast
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isPlaying ? kprimaryColor : widget.themeController.secondaryBackgroundColor.value,
                      shape: BoxShape.circle,
                      border: Border.all(color: kprimaryColor, width: 2),
                    ),
                    child: _isProcessingAudio && _currentlyPlayingSystemRingtone == ringtone
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
                            onPressed: () => _onTapPreviewSystem(ringtone),
                          ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Ringtone name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ringtone.title,
                          style: TextStyle(
                            color: widget.themeController.primaryTextColor.value,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          formatCategory(ringtone.category),
                          style: TextStyle(
                            color: widget.themeController.primaryTextColor.value.withOpacity(0.5),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Select button with improved contrast
                  ElevatedButton(
                    onPressed: () async {
                      _stopAllAudio();
                      
                      // Save the selected ringtone
                      await AudioUtils.saveSystemRingtone(
                        title: ringtone.title,
                        uri: ringtone.uri,
                        category: ringtone.category,
                      );
                      
                      // Update the controller
                      widget.controller.previousRingtone = widget.controller.customRingtoneName.value;
                      widget.controller.customRingtoneName.value = ringtone.title;
                      
                      // Update usage counters
                      await AudioUtils.updateRingtoneCounterOfUsage(
                        customRingtoneName: widget.controller.customRingtoneName.value,
                        counterUpdate: CounterUpdate.increment,
                      );
                      
                      await AudioUtils.updateRingtoneCounterOfUsage(
                        customRingtoneName: widget.controller.previousRingtone,
                        counterUpdate: CounterUpdate.decrement,
                      );
                      
                      // Refresh the ringtone list
                      widget.controller.customRingtoneNames.value = 
                          await widget.controller.getAllCustomRingtoneNames();
                      
                      // Go back to the alarm screen
                      Get.back();
                    },
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
      },
    );
  }
}
