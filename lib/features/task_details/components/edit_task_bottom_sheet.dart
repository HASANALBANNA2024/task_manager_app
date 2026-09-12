import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/features/task_dashboard/screens/task_list_screen.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/app_text_field.dart';

class EditTaskBottomSheet extends StatefulWidget{
  final Map<String, dynamic> taskData;
  final VoidCallback onTaskUpdated;

  const EditTaskBottomSheet({super.key, required this.taskData, required this.onTaskUpdated});

  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet>{
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _inProgress = false;
  late String _selectedStatus;


  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.taskData['title'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.taskData['description'] ?? '');
    _selectedStatus = widget.taskData['status'] ?? 'New';
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24,right: 24,top: 16,bottom: keyboardSpace + 24,),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,height: 4.5,
                    decoration: BoxDecoration(
                      color: AppTheme.line,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                const AppText("Edit Task", fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.ink,),
                const SizedBox(height: 18,),
                AppTextField(
                  controller: _titleController,
                  labelText: "Title",
                  hintText: "Task title",
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _descriptionController,
                  labelText: "Description",
                  hintText: "Task description",
                ),
                const SizedBox(height: 16),
                const AppText(
                  "Status",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.inkSoft,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: AppTheme.statusList.map((status) {
                    final bool isSelected = _selectedStatus == status['value'];
                    final Color statusColor = status['color'] as Color;
                    final Color statusBg = status['bg'] as Color;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStatus = status['value'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? statusBg : AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? statusColor : AppTheme.line,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: statusColor,
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              status['name'],
                              fontSize: 13,
                              fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? statusColor : AppTheme.inkSoft,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24,),
                AppButton(text: "Update Task",width: double.infinity, isLoading: _inProgress, onTap: _onTapTaskUpdate, isOutlined: true,)

              ],
        )),
      ),

    );




  }

  /// onTapTaskUpdate
  Future<void> _onTapTaskUpdate() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final taskId = widget.taskData['_id'] ?? widget.taskData['id']?? '';

    if(title.isEmpty || description.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: AppText("Please fill in all required fields")));
      return;
    }
    setState(() => _inProgress = true);
    final ApiResponse response = await ApiService.getRequest(
      AppUrls.updateTaskStatus(taskId, _selectedStatus),
    );
    setState(() => _inProgress = false);
    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: AppText("Task Updated Successfully!")),
        );
        widget.onTaskUpdated.call();
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(
              response.errorMessage.isNotEmpty
                  ? response.errorMessage
                  : "Task update failed!",
            ),
          ),
        );
      }
    }
  }
}