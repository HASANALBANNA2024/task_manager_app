import 'package:flutter/material.dart';
import 'package:task_manager_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:task_manager_app/core/widgets/profile_menu_helper.dart';
import 'package:task_manager_app/features/auth/screen/login_screen.dart';
import 'package:task_manager_app/features/create_task/add_new_task_bottom_sheet.dart';
import 'package:task_manager_app/features/dashboard/widgets/error_empty_state.dart';
import 'package:task_manager_app/features/dashboard/widgets/profile_header.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/dashboard/widgets/skeleton_loader_card.dart';
import 'package:task_manager_app/features/auth/controllers/auth_controller.dart';
import 'package:task_manager_app/features/task_dashboard/screens/task_list_screen.dart';
import 'package:task_manager_app/features/task_details/task_details_screen.dart';
import '../widgets/dashboard_status_grid.dart';
import '../widgets/recent_task_list_section.dart';
import '../controllers/task_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;
  bool _isError = false;

  String _userName = "";
  int _totalTasks = 0;
  List<dynamic> _statusCountList = [];
  List<dynamic> _recentTaskList = [];

  @override
  void initState() {
    super.initState();
    _getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        isGradient: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                title: "Task Manager",
                userName: _userName.isEmpty ? null : _userName,
                taskCountText: "$_totalTasks tasks total",
                onProfileTap: () {
                  ProfileMenuHelper.showMenu(context, items: [
                    ///profile menu
                    ProfileMenuItem(title: "Profile", icon: Icons.person_off_rounded, onTap: (){}),
                    ///settings
                    ProfileMenuItem(title: "Settings", icon: Icons.settings_rounded, onTap: (){}),
                    ///logout
                    ProfileMenuItem(title: "Logout", icon: Icons.logo_dev_rounded, onTap: () async {
                     await AuthController.logout();
                     if(!context.mounted) return;
                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen() ), (route)=> false);
                    }),
                  ]);
                },
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildScreenBody()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: 0,
        items: [
          BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_filled,
              label: 'Home',
              onTap: () {}),
          BottomNavItem(
              icon: Icons.assignment_outlined,
              activeIcon: Icons.assignment,
              label: 'Tasks',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const TaskListScreen() ));
              }),
          BottomNavItem(
              icon: Icons.add,
              label: 'Add',
              isSpecialButton: true,
              onTap: () {
                showModalBottomSheet(context: context, isScrollControlled: true,builder: (context) =>  AddNewTaskBottomSheet(
                 onTaskAdded: (){
                   _getDashboardData();
                 },
                ));
              }),
          BottomNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildScreenBody() {
    if (_isLoading) return const SkeletonLoaderCard(height: 180);

    if (_isError) {
      return Center(
        child: ErrorEmptyState(
          icon: Icons.error_outline,
          title: "Couldn't load dashboard",
          subtitle: "Please check your network connection.",
          buttonText: "Retry",
          onRetryTap: _getDashboardData,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          DashboardStatusGrid(getCount: _getCount),
          const SizedBox(height: 24),
          RecentTaskListSection(taskList: _recentTaskList, onTaskTap: (taskData){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskDetailsScreen(
              taskData: taskData,
              onTaskUpdated: (){_getDashboardData();},
            )));
          }),
        ],
      ),
    );
  }

  void _getDashboardData() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      String token = AuthController.userToken ?? "";

      var statusResponse =
          await TaskController.getTaskStatusCount(token: token);
      var taskResponse =
          await TaskController.getTasksByStatus(status: 'New', token: token);

      if (!mounted) return;

      if (statusResponse.isSuccess && taskResponse.isSuccess) {
        _statusCountList = statusResponse.responseData['data'] ?? [];
        _recentTaskList = taskResponse.responseData['data'] ?? [];

        // AuthController safety check
        String firstName = AuthController.userData != null
            ? (AuthController.userData!['firstName'] ?? 'User')
            : 'User';
        String lastName = AuthController.userData != null
            ? (AuthController.userData!['lastName'] ?? '')
            : '';
        _userName = "$firstName $lastName".trim();

        _totalTasks = 0;
        for (var item in _statusCountList) {
          _totalTasks += (item['sum'] as int? ?? 0);
        }

        setState(() => _isLoading = false);
      } else {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  String _getCount(String statusName) {
    for (var item in _statusCountList) {
      if (item['_id']?.toString().toLowerCase() == statusName.toLowerCase()) {
        return item['sum']?.toString() ?? '0';
      }
    }
    return '0';
  }
}
