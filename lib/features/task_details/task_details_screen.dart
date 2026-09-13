import 'package:flutter/material.dart';
import 'package:task_manager_app/core/widgets/app_icon.dart';
import 'package:task_manager_app/core/widgets/app_icon_button.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/task_details/components/edit_task_bottom_sheet.dart';

import '../../app/theme/app_theme.dart';
import '../../core/constants/app_urls.dart';
import '../../core/network/api_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/info_row_widget.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? taskData;
  final VoidCallback? onTaskUpdated;

  const TaskDetailsScreen({super.key, this.taskData, this.onTaskUpdated});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}
class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late String _selectedStatus;
  late String _title;
  late String _description;

  bool _isStatusUpdating = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskData?['status'] ?? 'New';
    _title = widget.taskData?['title'] ?? 'No Title';
    _description = widget.taskData?['description'] ?? 'No Description';
  }
  @override
  Widget build(BuildContext context) {
    final owner = widget.taskData?['email'] ??
        widget.taskData?['owner'] ??
        'hasan@gmail.com';
    final createdDate = widget.taskData?['createdDate'] ??
        widget.taskData?['createdAt'] ??
        '27 Jan, 2024';
    final taskId = widget.taskData?['_id'] ?? widget.taskData?['id'] ?? '';

    return ScreenBackground(
      isGradient: false,
      backgroundColor: AppTheme.paper,
      child: Column(
        children: [
          // AppBar Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIconButton(icon: Icons.chevron_left,onTap: () => Navigator.pop(context),
                ),
                const AppText("Task Details",fontSize: 16,fontWeight: FontWeight.w800,color: AppTheme.ink,),
                const AppIcon(icon: Icons.more_vert),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Status Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.amber.withValues(alpha:0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText(_selectedStatus == 'Progress'? 'In Progress': _selectedStatus,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slate,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Task Title
                  AppText(_title,fontSize: 22,fontWeight: FontWeight.w800,color: AppTheme.ink,),
                  const SizedBox(height: 12),
                  // Task Description
                  AppText(_description,fontSize: 13.5, fontWeight: FontWeight.w500,color: AppTheme.inkFaint,),
                  const SizedBox(height: 32),
                  // Owner
                  InfoRowWidget(label: "Owner",value: owner, ),
                  const Divider(color: AppTheme.line, height: 28, thickness: 1),


                  InfoRowWidget(
                    label: "Created",
                    value: createdDate,
                  ),
                  const Divider(color: AppTheme.line, height: 28, thickness: 1),


                  InfoRowWidget(
                    label: "Task ID",
                    value: taskId.length > 15
                        ? "${taskId.substring(0, 8)}...${taskId.substring(taskId.length - 4)}"
                        : taskId,
                  ),
                  const Divider(color: AppTheme.line, height: 28, thickness: 1),

                  const SizedBox(height: 28),

                  // Change Status Header
                  const AppText(
                    "Change status",
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ink,
                  ),
                  const SizedBox(height: 14),

                  // Status Selection Grid
                  _isStatusUpdating
                      ? const Center(
                          child:
                              CircularProgressIndicator(color: AppTheme.moss))
                      : GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 3.5,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: AppTheme.statusList.map((status) {
                            final bool isSelected =
                                _selectedStatus == status['value'];
                            final Color color = status['color'] as Color;
                            final Color bg = status['bg'] as Color;

                            return GestureDetector(
                              onTap: () => _onStatusChange(status['value']),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? bg : AppTheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? color : AppTheme.line,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 3.5,
                                      backgroundColor: color,
                                    ),
                                    const SizedBox(width: 8),
                                    AppText(
                                      status['name'],
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color:
                                          isSelected ? color : AppTheme.inkSoft,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 32),

                  // Action Buttons (Edit & Delete)
                  Row(
                    children: [
                      // Edit Button (Outlined Style)
                      Expanded(
                        child: AppButton(
                          text: "Edit",
                          isOutlined: true,
                          borderColor: AppTheme.moss,
                          onTap: (){
                            if(widget.taskData != null)
                              {
                                _showEditBottomSheet(widget.taskData!);
                              }

                          },

                        ),
                      ),
                      const SizedBox(width: 14),

                      // Delete Button (Filled Style)
                      Expanded(
                        child: AppButton(
                          text: "Delete",
                          color: AppTheme.brick,
                          textColor: Colors.white,
                          isLoading: _isDeleting,
                          onTap: () {
                            _showDeleteConfirmationDialog();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Status changes option
  Future<void> _onStatusChange(String newStatus) async {
    if (_selectedStatus == newStatus) return;

    setState(() {
      _selectedStatus = newStatus;
      _isStatusUpdating = true;
    });

    final String taskId =
        widget.taskData?['_id'] ?? widget.taskData?['id'] ?? '';

    final ApiResponse response = await ApiService.getRequest(
      AppUrls.updateTaskStatus(taskId, newStatus),
    );

    setState(() => _isStatusUpdating = false);

    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Status updated successfully!")),
        );
        if (widget.onTaskUpdated != null) {
          widget.onTaskUpdated!();
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.errorMessage.isNotEmpty
                  ? response.errorMessage
                  : "Failed to update status",
            ),
          ),
        );
      }
    }
  }

  /// Delete confirmation dialog
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const AppText(
            "Delete Task",
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.ink,
          ),
          content: const AppText(
            "Are you sure you want to delete this task?",
            fontSize: 14,
            color: AppTheme.inkFaint,
          ),
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          actions: [
            Row(
              children: [
                // Cancel Button (Outlined)
                Expanded(
                  child: AppButton(
                    text: "Cancel",
                    isOutlined: true,
                    borderColor: AppTheme.inkFaint,
                    height: 42,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                // Delete Button (Filled Solid)
                Expanded(
                  child: AppButton(
                    text: "Delete",
                    color: AppTheme.brick,
                    textColor: Colors.white,
                    height: 42,
                    isLoading: _isDeleting,
                    onTap: () {
                      Navigator.pop(context);
                      _onTapDeleteTask();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Delete task API call
  Future<void> _onTapDeleteTask() async {
    final String taskId =
        widget.taskData?['_id'] ?? widget.taskData?['id'] ?? '';

    setState(() => _isDeleting = true);
    final ApiResponse response = await ApiService.getRequest(
      AppUrls.deleteTask(taskId),
    );
    setState(() => _isDeleting = false);

    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task Deleted Successfully!")),
        );
        if (widget.onTaskUpdated != null) widget.onTaskUpdated!();
        Navigator.pop(context);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : "Delete failed! Try again.",
          ),
        ),
      );
    }
  }

  /// bottom show on edit bottom sheet
  void _showEditBottomSheet(Map<String, dynamic> taskData){
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) => EditTaskBottomSheet(taskData: taskData, onTaskUpdated: (){
          if(widget.onTaskUpdated != null )
            {
              widget.onTaskUpdated!();
            }
        }));
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
