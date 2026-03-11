import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:ultimate_alarm_clock/app/data/models/world_clock_model.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/settings_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/worldClock/controllers/world_clock_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/end_drawer.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

// ignore: must_be_immutable
class WorldClockView extends GetView<WorldClockController> {
  WorldClockView({Key? key}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height / 7.9),
        child: AppBar(
          toolbarHeight: height / 7.9,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'World Clock'.tr,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          actions: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Obx(
                  () => IconButton(
                    onPressed: () {
                      Utils.hapticFeedback();
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(Icons.menu),
                    color: themeController.primaryTextColor.value
                        .withOpacity(0.75),
                    iconSize: 27,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        // Subscribing to tick forces per-second rebuilds for all clocks.
        final _ = controller.tick.value;
        final is24Hour = settingsController.is24HrsEnabled.value;

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
          // index 0 = permanent local card; 1..N = user-added clocks
          itemCount: controller.clocks.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: _LocalClockCard(
                  themeController: themeController,
                  is24Hour: is24Hour,
                ),
              );
            }

            final userIndex = index - 1;
            final clock = controller.clocks[userIndex];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Dismissible(
                key: Key('${clock.ianaTimezone}_$userIndex'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmRemove(context, clock.cityName),
                onDismissed: (_) => controller.removeClock(userIndex),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
                child: _ClockCard(
                  clock: clock,
                  controller: controller,
                  themeController: themeController,
                  is24Hour: is24Hour,
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClockSheet(context),
        backgroundColor: kprimaryColor,
        foregroundColor: Colors.black,
        tooltip: 'Add a world clock'.tr,
        child: const Icon(Icons.add),
      ),
      endDrawer: buildEndDrawer(context),
    );
  }

  Future<bool> _confirmRemove(BuildContext context, String cityName) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: themeController.secondaryBackgroundColor.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Remove Clock'.tr,
              style: TextStyle(
                color: themeController.primaryTextColor.value,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              '${'Remove'.tr} $cityName?',
              style: TextStyle(
                color: themeController.primaryDisabledTextColor.value,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel'.tr,
                  style: TextStyle(
                    color: themeController.primaryDisabledTextColor.value,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Remove',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showAddClockSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: themeController.secondaryBackgroundColor.value,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddClockSheet(
        themeController: themeController,
        onAdd: controller.addClock,
      ),
    );
  }
}

// ─── Permanent local timezone card ───────────────────────────────────────────

class _LocalClockCard extends StatelessWidget {
  final ThemeController themeController;
  final bool is24Hour;

  const _LocalClockCard({
    required this.themeController,
    required this.is24Hour,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final time = is24Hour
        ? DateFormat('HH:mm').format(now)
        : DateFormat('h:mm').format(now);
    final period = DateFormat('a').format(now);
    final date = DateFormat('EEE, MMM d').format(now);
    final offset = now.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hh = offset.inHours.abs();
    final mm = offset.inMinutes.abs() % 60;
    final utcStr = mm == 0
        ? 'UTC$sign$hh'
        : 'UTC$sign$hh:${mm.toString().padLeft(2, '0')}';
    final tzName = now.timeZoneName;

    return Card(
      color: themeController.secondaryBackgroundColor.value,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: kprimaryColor.withOpacity(0.45), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "My Location" badge
            Row(
              children: [
                const Icon(Icons.my_location, size: 12, color: kprimaryColor),
                const SizedBox(width: 5),
                Text(
                  'My Location'.tr,
                  style: const TextStyle(
                    fontSize: 11,
                    color: kprimaryColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: timezone abbreviation + date + UTC chip
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tzName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeController.primaryTextColor.value,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                          color: themeController.primaryDisabledTextColor.value,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _Chip(
                        label: utcStr,
                        textColor:
                            themeController.primaryDisabledTextColor.value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Right: time + period (no overflow — "HH:mm" only, period on next line)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: kprimaryColor,
                        height: 1,
                      ),
                    ),
                    if (!is24Hour)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          period,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                themeController.primaryDisabledTextColor.value,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── User-added clock card ────────────────────────────────────────────────────

class _ClockCard extends StatelessWidget {
  final WorldClockModel clock;
  final WorldClockController controller;
  final ThemeController themeController;
  final bool is24Hour;

  const _ClockCard({
    required this.clock,
    required this.controller,
    required this.themeController,
    required this.is24Hour,
  });

  @override
  Widget build(BuildContext context) {
    final time = controller.getCityTime(clock, is24Hour);
    final period = controller.getCityTimePeriod(clock);
    final date = controller.getCityDate(clock);
    final utcOffset = controller.getUtcOffset(clock);
    final timeDiff = controller.getTimeDiff(clock);

    return Card(
      color: themeController.secondaryBackgroundColor.value,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: city name + date + chips
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clock.cityName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeController.primaryTextColor.value,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: themeController.primaryDisabledTextColor.value,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Wrap allows chips to wrap on narrower screens
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _Chip(
                        label: utcOffset,
                        textColor:
                            themeController.primaryDisabledTextColor.value,
                      ),
                      _Chip(
                        label: timeDiff,
                        textColor:
                            themeController.primaryDisabledTextColor.value,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right: time + period on separate lines — no overflow risk
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: kprimaryColor,
                    height: 1,
                  ),
                ),
                if (!is24Hour)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      period,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Small chip label ─────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color textColor;

  const _Chip({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: textColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: textColor),
      ),
    );
  }
}

// ─── Add clock bottom sheet ───────────────────────────────────────────────────

class _AddClockSheet extends StatefulWidget {
  final ThemeController themeController;
  final void Function(WorldClockModel) onAdd;

  const _AddClockSheet({
    required this.themeController,
    required this.onAdd,
  });

  @override
  State<_AddClockSheet> createState() => _AddClockSheetState();
}

class _AddClockSheetState extends State<_AddClockSheet> {
  final TextEditingController _search = TextEditingController();
  late List<String> _allTimezones;
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _allTimezones = tz.timeZoneDatabase.locations.keys.toList()..sort();
    _filtered = List.from(_allTimezones);
    _search.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _search.text.toLowerCase();
    setState(() {
      _filtered = _allTimezones
          .where((id) => id.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _search.removeListener(_onSearch);
    _search.dispose();
    super.dispose();
  }

  String _cityName(String ianaId) =>
      ianaId.split('/').last.replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textColor = widget.themeController.primaryTextColor.value;
    final disabledColor = widget.themeController.primaryDisabledTextColor.value;
    final bgColor = widget.themeController.primaryBackgroundColor.value;

    return SizedBox(
      height: height * 0.75,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: disabledColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _search,
              autofocus: true,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search timezones'.tr,
                hintStyle: TextStyle(color: disabledColor),
                prefixIcon: Icon(Icons.search, color: disabledColor),
                filled: true,
                fillColor: bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final id = _filtered[index];
                final city = _cityName(id);
                return ListTile(
                  title: Text(city, style: TextStyle(color: textColor)),
                  subtitle: Text(
                    id,
                    style: TextStyle(fontSize: 12, color: disabledColor),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onAdd(
                      WorldClockModel(ianaTimezone: id, cityName: city),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
