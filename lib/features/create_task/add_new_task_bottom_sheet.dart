import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_field.dart';

import '../../app/theme/app_theme.dart';
import '../../core/network/api_service.dart';

class AddNewTaskBottomSheet extends StatefulWidget {
  final VoidCallback? onTaskAdded;

  const AddNewTaskBottomSheet({super.key, this.onTaskAdded});

  @override
  State<AddNewTaskBottomSheet> createState() => _AddNewTaskBottomSheetState();
}

class _AddNewTaskBottomSheetState extends State<AddNewTaskBottomSheet> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _inProgress = false;
  String _selectedStatus = 'New';

  @override
  Widget build(BuildContext context) {
    /// keyboard height
    final double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: keyboardSpace + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Handle Indicator
              Center(
                child: Container(
                  width: 48,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: AppTheme.line,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sheet Title
              const AppText(
                "Add New Task",
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.ink,
              ),
              const SizedBox(height: 18),

              // Title Input
              AppTextField(
                controller: _titleTEController,
                labelText: "Title",
                hintText: "Prepare client presentation",
              ),
              const SizedBox(height: 16),

              // Description Input
              AppTextField(
                controller: _descriptionTEController,
                labelText: "Description",
                hintText: "Get the Q3 report slides ready",
              ),
              const SizedBox(height: 16),

              // Status Label
              const AppText(
                "Status",
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.inkSoft,
              ),
              const SizedBox(height: 10),

              // Status Chips
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
              const SizedBox(height: 24),

              // Save Action Button (AppButton isLoading )
              AppButton(
                text: "Save Task",
                width: double.infinity,
                isLoading: _inProgress,
                onTap: _onTapTaskCreate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTapTaskCreate() async {
    final title = _titleTEController.text.trim();
    final description = _descriptionTEController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields!")),
      );
      return;
    }

    setState(() => _inProgress = true);

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": _selectedStatus.trim(),
    };

    final ApiResponse response = await ApiService.postRequest(
      AppUrls.createTask,
      body: requestBody,
    );

    setState(() => _inProgress = false);

    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task Added Successfully!")),
        );

        if (widget.onTaskAdded != null) {
          widget.onTaskAdded!();
        }

        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.errorMessage.isNotEmpty
                  ? response.errorMessage
                  : "Task add failed! Please try again.",
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}