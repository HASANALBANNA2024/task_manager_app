import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/task_details/task_details_screen.dart';

import '../../../app/theme/app_theme.dart';
import '../../dashboard/widgets/task_item_card.dart';
import '../widgets/task_empty_state_widget.dart';
import '../widgets/task_filter_chips.dart';
import '../widgets/task_scroll_indicator.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _selectedFilter = "New";
  bool _isLoading = false;
  List<dynamic> _taskList = [];
  Map<String, int> _statusCounts = {
    'New': 0,
    'Progress': 0,
    'Completed': 0,
    'Cancelled': 0
  };

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        isGradient: false,
        backgroundColor: AppTheme.paper,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            const AppText(
              "My Task",
              fontSize: 22,
              color: AppTheme.ink,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(
              height: 14,
            ),
            TaskFilterChips(
                selectedFilter: _selectedFilter,
                statusCounts: _statusCounts,
                onFilterSelected: (value) {
                  if (_selectedFilter != value) {
                    setState(() {
                      _selectedFilter = value;
                      _isLoading = true;
                    });
                    _fetchTasksByStatus(value).then((_) {
                      if (mounted) setState(() => _isLoading = false);
                    });
                  }
                }),
            const TaskScrollIndicator(),
            const SizedBox(
              height: 6,
            ),

            /// Task List Area
            Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: AppTheme.moss,
                      ))
                    : _taskList.isEmpty
                        ? TaskEmptyStateWidget(filterName: _selectedFilter)
                        : RefreshIndicator(
                            color: AppTheme.moss,
                            onRefresh: _loadInitialData,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _taskList.length,
                              itemBuilder: (context, index) {
                                final task = _taskList[index];
                                final String taskId =
                                    task['_id'] ?? task['_id'] ?? '';
                                final String title = task['title'] ?? '';
                                final String status = task['status'] ?? 'New';

                                return Dismissible(
                                  key: Key(taskId),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color: AppTheme.brick,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: TaskItemCard(
                                    title: title,
                                    description: task!['description'],
                                    date: task['createdDate'] ?? '',
                                    status: status,
                                    statusColor: _getStatusColor(status),
                                    onTap: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskDetailsScreen(
                                                    taskData: task,
                                                    onTaskUpdated: () {
                                                      _loadInitialData();
                                                    },
                                                  )));
                                      _loadInitialData();
                                    },
                                  ),
                                );
                              },
                            ),
                          )),
          ],
        ));
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchTasksByStatus(_selectedFilter),
      _fetchStatusCount(),
    ]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchTasksByStatus(String status) async {
    final response = await ApiService.getRequest(
      AppUrls.listTaskByStatus(status),
    );

    if (mounted) {
      if (response.isSuccess) {
        setState(() {
          _taskList = response.responseData?['data'] ?? [];
        });
      } else {
        _showSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : "Failed to fetch tasks!",
        );
      }
    }
  }

  Future<void> _fetchStatusCount() async {
    final response = await ApiService.getRequest(AppUrls.taskStatusCount);

    if (mounted && response.isSuccess) {
      Map<String, int> temp = {
        'New': 0,
        'Progress': 0,
        'Completed': 0,
        'Cancelled': 0,
      };

      final List dataList = response.responseData?['data'] ?? [];
      for (var item in dataList) {
        String statusKey = item['_id'] ?? '';
        if (temp.containsKey(statusKey)) {
          temp[statusKey] = item['sum'] ?? 0;
        }
      }

      setState(() => _statusCounts = temp);
    }
  }

  ///Color code
  Color _getStatusColor(String status) {
    final theme = Theme.of(context);

    switch (status) {
      case 'Progress':
      case 'In Progress':
        return theme.colorScheme.primary;
      case 'Cancelled':
        return theme.colorScheme.outline;
      case 'Completed':
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.tertiary;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
