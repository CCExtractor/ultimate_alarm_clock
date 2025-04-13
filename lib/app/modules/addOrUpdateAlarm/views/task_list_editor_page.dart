import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/task_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:uuid/uuid.dart';

class TaskListEditorPage extends StatefulWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  const TaskListEditorPage({
    Key? key,
    required this.controller,
    required this.themeController,
  }) : super(key: key);

  @override
  State<TaskListEditorPage> createState() => _TaskListEditorPageState();
}

class _TaskListEditorPageState extends State<TaskListEditorPage> {
  final TextEditingController taskController = TextEditingController();
  final FocusNode taskFocusNode = FocusNode();
  
  @override
  void dispose() {
    taskController.dispose();
    taskFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: widget.themeController.primaryBackgroundColor.value,
      appBar: AppBar(
        backgroundColor: widget.themeController.secondaryBackgroundColor.value,
        title: Text(
          'Edit Tasks'.tr,
          style: TextStyle(
            color: widget.themeController.primaryTextColor.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.themeController.primaryTextColor.value,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: widget.themeController.primaryTextColor.value,
            ),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Task input field
          Container(
            padding: const EdgeInsets.all(16),
            color: widget.themeController.secondaryBackgroundColor.value,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    focusNode: taskFocusNode,
                    style: TextStyle(color: widget.themeController.primaryTextColor.value),
                    decoration: InputDecoration(
                      hintText: 'Add a task'.tr,
                      hintStyle: TextStyle(color: widget.themeController.primaryDisabledTextColor.value),
                      filled: true,
                      fillColor: widget.themeController.primaryBackgroundColor.value,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add_circle, color: kprimaryColor, size: 28),
                        onPressed: _addTask,
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
              ],
            ),
          ),
          
          // Information banner
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: widget.themeController.secondaryBackgroundColor.value.withOpacity(0.5),
            child: Text(
              'These tasks will be displayed when your alarm rings'.tr,
              style: TextStyle(
                color: widget.themeController.primaryDisabledTextColor.value,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          
          // Task list
          Expanded(
            child: Obx(() => widget.controller.taskList.isEmpty
                ? _buildEmptyState()
                : _buildTaskList()),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    if (taskController.text.isNotEmpty) {
      widget.controller.addTask(TaskModel(
        id: const Uuid().v4(),
        text: taskController.text,
      ));
      taskController.clear();
      taskFocusNode.requestFocus();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 70,
            color: widget.themeController.primaryDisabledTextColor.value.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet'.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: widget.themeController.primaryDisabledTextColor.value,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a task using the field above'.tr,
            style: TextStyle(
              fontSize: 14,
              color: widget.themeController.primaryDisabledTextColor.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Obx(() => ReorderableListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: widget.controller.taskList.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = widget.controller.taskList.removeAt(oldIndex);
        widget.controller.taskList.insert(newIndex, item);
        widget.controller.updateSerializedTaskList();
      },
      itemBuilder: (context, index) {
        final task = widget.controller.taskList[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            widget.controller.removeTask(index);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            decoration: BoxDecoration(
              color: widget.themeController.secondaryBackgroundColor.value,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(
                Icons.drag_indicator,
                color: widget.themeController.primaryDisabledTextColor.value,
              ),
              title: Text(
                task.text,
                style: TextStyle(
                  color: widget.themeController.primaryTextColor.value,
                  fontSize: 16,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  widget.controller.removeTask(index);
                },
              ),
            ),
          ),
        );
      },
    ));
  }
} 