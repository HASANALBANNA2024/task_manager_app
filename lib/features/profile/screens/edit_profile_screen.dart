import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_helper.dart';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';
import 'package:task_manager_app/core/widgets/app_button.dart';
import 'package:task_manager_app/core/widgets/app_icon_button.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/app_text_field.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/auth/controllers/auth_controller.dart';

import '../../../app/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget{
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}
class _EditProfileScreenState extends State<EditProfileScreen>{
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isUpdating = false;

  @override
  void initState()
  {
    super.initState();
    _setData();
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();

   return ScreenBackground(
       isGradient: false,
       backgroundColor: AppTheme.paper,
       child: SafeArea(child: Column(
         children: [
           Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 AppIconButton(icon: Icons.chevron_left, onTap: (){Navigator.pop(context);}),
                 const AppText("Edit Profile", fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.ink,),
                 const SizedBox(width: 40,),
               ],
             ),
           ),
           ///Form Area
           Expanded(child: SingleChildScrollView(
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
             child: Form(
                 key: _formKey,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const SizedBox(height: 12,),
                     Center(
                       child: Container(
                         width: 80,
                         height: 80,
                         decoration: BoxDecoration(
                           color: AppTheme.moss.withValues(alpha:0.12),
                           borderRadius: BorderRadius.circular(24),
                         ),
                         alignment: Alignment.center,
                         child: AppText(UserInitials.getInitials(firstName, lastName)),
                       ),
                     ),
                     const SizedBox(height: 32,),
                     AppTextField(controller: _firstNameController, hintText: "Enter first name", labelText: "First name",
                     validator: (value){
                       if(value == null || value.trim().isEmpty){
                         return "Enter first name";
                       }
                       return null;
                     },
                     ),
                     const SizedBox(height: 18,),
                     AppTextField(controller: _lastNameController, hintText: "Enter last name", labelText: "Last name",
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return "Enter last name";
                         }
                         return null;
                       },
                     ),
                     const SizedBox(height: 18,),
                     AppTextField(controller: _emailController, hintText: "Enter email", labelText: "Email",
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return "Enter email";
                         }
                         return null;
                       },
                     ),
                     const SizedBox(height: 18,),
                     AppTextField(controller: _mobileController, hintText: "Enter mobile number", labelText: "Mobile number",
                       validator: (value){
                         if(value == null || value.trim().isEmpty){
                           return "Enter mobile number";
                         }
                         return null;
                       },
                     ),
                     const SizedBox(height: 32,),
                     AppButton(text: "Save Changes", color: AppTheme.moss,textColor: AppTheme.paper,isLoading: _isUpdating,onTap: _onTapUpdateProfile)

                   ],
             )),
           ))
         ],
       ))
   );
  }
  /// _setData
  void _setData () async{
    final userData = AuthController.userData;
    if(userData !=null){
      _firstNameController.text = userData['firstName'];
      _lastNameController.text = userData['lastName'];
      _emailController.text = userData['email'];
      _mobileController.text = userData['mobile'];
    }
  }
  /// onTap update profile
  Future<void> _onTapUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUpdating = true;
    });

    final Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
    };

    final ApiResponse response = await ApiService.postRequest(
      AppUrls.profileUpdate,
      body: requestBody,
    );

    setState(() {
      _isUpdating = false;
    });

    if (response.isSuccess) {
      await AuthController.saveUserData(requestBody);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: AppText("Profile updated successfully")),
      );
      Navigator.pop(context, true);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : "Profile update failed! Try again.",
          ),
        ),
      );
    }
  }
}