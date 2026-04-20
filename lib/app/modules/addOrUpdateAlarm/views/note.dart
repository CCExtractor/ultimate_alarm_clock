import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
        final double width = MediaQuery.of(context).size.width;
        // ignore: unused_local_variable
        final double height = MediaQuery.of(context).size.height;
    return Obx(
      () => ListTile(

        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Note'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
            ),
          ),
        ),
        onTap: () {
          Utils.hapticFeedback();
          _openNotesEditor(context);
        },
        trailing: InkWell(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () => Container(
                  width: width*0.1,
                  alignment: Alignment.centerRight,
                  child: Text(
                    (controller.note.value.trim().isNotEmpty)
                        ? controller.note.value
                        : 'Off'.tr,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: (controller.note.value.trim().isEmpty)
                              ? themeController.primaryDisabledTextColor.value
                              : themeController.primaryTextColor.value,
                        ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: (controller.note.value.trim().isEmpty)
                    ? themeController.primaryDisabledTextColor.value
                    : themeController.primaryTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openNotesEditor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => _NotesEditorPage(
          controller: controller,
          themeController: themeController,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

class _NotesEditorPage extends StatefulWidget {
  const _NotesEditorPage({
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  State<_NotesEditorPage> createState() => _NotesEditorPageState();
}

class _NotesEditorPageState extends State<_NotesEditorPage> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  String _originalText = '';
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _originalText = widget.controller.noteController.text;
    _textController = TextEditingController(text: _originalText);
    _focusNode = FocusNode();
    
    _textController.addListener(_onTextChanged);
    
    // Auto-focus after a short delay to ensure smooth navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _focusNode.canRequestFocus) {
          _focusNode.requestFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasChanges = _textController.text != _originalText;
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  void _saveAndClose() {
    widget.controller.note.value = _textController.text.trim();
    widget.controller.noteController.text = _textController.text.trim();
    Navigator.of(context).pop();
  }

  void _discardAndClose() {
    Navigator.of(context).pop();
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) {
      return true;
    }

    final bool? shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: widget.themeController.secondaryBackgroundColor.value,
          title: Text(
            'Discard changes?'.tr,
            style: TextStyle(
              color: widget.themeController.primaryTextColor.value,
            ),
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to discard them?'.tr,
            style: TextStyle(
              color: widget.themeController.primaryDisabledTextColor.value,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Keep editing'.tr,
                style: TextStyle(
                  color: widget.themeController.primaryTextColor.value,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Discard'.tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    return shouldDiscard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(
        () => Scaffold(
          backgroundColor: widget.themeController.primaryBackgroundColor.value,
          appBar: AppBar(
            backgroundColor: widget.themeController.primaryBackgroundColor.value,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: widget.themeController.primaryTextColor.value,
              ),
              onPressed: () async {
                Utils.hapticFeedback();
                if (await _onWillPop()) {
                  _discardAndClose();
                }
              },
            ),
            title: Text(
              'Add a note'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: widget.themeController.primaryTextColor.value,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                onPressed: _hasChanges
                    ? () {
                        Utils.hapticFeedback();
                        _saveAndClose();
                      }
                    : null,
                child: Text(
                  'Save'.tr,
                  style: TextStyle(
                    color: _hasChanges
                        ? kprimaryColor
                        : widget.themeController.primaryDisabledTextColor.value,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Character counter and helper text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: widget.themeController.secondaryBackgroundColor.value,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.themeController.primaryDisabledTextColor.value
                          .withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add details about your alarm'.tr,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: widget.themeController.primaryTextColor.value,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${_textController.text.length}/500',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: widget.themeController.primaryDisabledTextColor.value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Reminders, context, or any additional information'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: widget.themeController.primaryDisabledTextColor.value,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Text input field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.themeController.secondaryBackgroundColor.value,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.themeController.primaryDisabledTextColor.value
                            .withOpacity(0.1),
                      ),
                    ),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      maxLines: null,
                      maxLength: 500,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: widget.themeController.primaryTextColor.value,
                        height: 1.5, // Better line spacing
                      ),
                      cursorColor: kprimaryColor,
                      decoration: InputDecoration(
                        hintText: 'Enter your note here...'.tr,
                        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.themeController.primaryDisabledTextColor.value,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                        counterText: '', // Hide the built-in counter
                      ),
                      onChanged: (text) {
                        // Remove leading whitespace from first line
                        if (text.isNotEmpty && text[0] == ' ') {
                          _textController.text = text.trimLeft();
                          _textController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _textController.text.length),
                          );
                        }
                      },
                    ),
                  ),
                ),
                
                // Bottom action bar (optional)
                if (_hasChanges)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Utils.hapticFeedback();
                        _saveAndClose();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save Note'.tr,
                        style: TextStyle(
                          color: widget.themeController.secondaryTextColor.value,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
