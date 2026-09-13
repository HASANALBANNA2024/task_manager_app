import 'package:flutter/material.dart';
import 'package:task_manager_app/app/theme/app_theme.dart';
import 'package:task_manager_app/core/constants/app_helper.dart';
import 'package:task_manager_app/core/constants/app_urls.dart';
import 'package:task_manager_app/core/network/api_service.dart';
import 'package:task_manager_app/core/widgets/app_icon_button.dart';
import 'package:task_manager_app/core/widgets/app_text.dart';
import 'package:task_manager_app/core/widgets/log_out_pop_up.dart';
import 'package:task_manager_app/core/widgets/screen_background.dart';
import 'package:task_manager_app/features/auth/controllers/auth_controller.dart';
import 'package:task_manager_app/features/profile/screens/change_password_bottom_sheet.dart';
import 'package:task_manager_app/features/profile/screens/edit_profile_screen.dart';
import 'package:task_manager_app/features/profile/widgets/profile_tile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen>{
  bool _isLoading = false;
  Map<String, dynamic>? _userData;
  
  @override
  void initState(){
    super.initState();
    _onTapProfileDetails();
  }
  @override
  Widget build(BuildContext context) {
    ///dynamic user Data Extraction
    final String firstName = _userData?['firstName'] ?? AuthController.userData?['firstName'] ?? '';
    final String lastName = _userData?['lastName'] ?? AuthController.userData?['lastName']?? '';
    final String fullName = "$firstName $lastName".trim();
    final String mobileNumber = _userData?['mobile'] ?? AuthController.userData?['mobile']?? '';
    final String email = _userData?['email'] ?? AuthController.userData?['email'];
    /// name Initial
    final String displayInitials = UserInitials.getInitials(firstName, lastName);
    return ScreenBackground(
        isGradient: false,
        backgroundColor: AppTheme.paper,
        child: SafeArea(
            child: RefreshIndicator(
                color: AppTheme.moss,
                onRefresh: _onTapProfileDetails,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      AppBar(
                        leading: AppIconButton(icon: Icons.arrow_back_ios, onTap: (){
                          Navigator.pop(context);
                        }),
                        title: const AppText("Profile Details", fontSize: 16, fontWeight: FontWeight.w800),
                        backgroundColor: AppTheme.paper,
                        elevation: 0,
                        centerTitle: true,
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding:  const EdgeInsets.symmetric(vertical: 28),
                        child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,),) :
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// avater circle with initial
                                Container(
                                  width: 71, height: 72,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  alignment:  Alignment.center,
                                  child: AppText(
                                    displayInitials,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.moss,
                                  ),
                                ),
                                const SizedBox(height: 12,),
                                /// user name
                                AppText(fullName, fontSize: 20, fontWeight: FontWeight.w800,),
                                const SizedBox(height: 4,),
                                AppText(email, fontSize: 13, fontWeight: FontWeight.w500, ),
                                const SizedBox(height: 4,),
                                AppText(mobileNumber, fontSize: 13, fontWeight: FontWeight.w500,  ),
                                const SizedBox(height: 16,),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      ProfileTileWidget(icon: Icons.edit_note_rounded, title: "Edit Profile", onTap: ()async{
                                        /// profile edit screen call
                                      final bool? isUpdated = await Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfileScreen()));
                                      if(isUpdated == true)
                                        {
                                          setState(() {

                                          });
                                        }
                                      }),
                                      const SizedBox(height: 12,),
                                      ProfileTileWidget(icon: Icons.lock_outline_rounded, title: "Change password", onTap: (){
                                        showModalBottomSheet(context: context,isScrollControlled: true, builder: (context)=>  const ChangePasswordBottomSheet(
                                        ));
                                      }),
                                      const SizedBox(height:12,),
                                      ProfileTileWidget(icon: Icons.logo_dev_rounded, title: "Logout", onTap: (){
                                        showLogoutConfirmationDialog(context);
                                      })
                                    ],
                                  ),
                                ),


                              ],
                            )
                      )
                    ],
                  ),
                )
            )
        )

    );
    
  }
  Future<void> _onTapProfileDetails() async {
    setState(()=> _isLoading = true);
    
    final ApiResponse response = await ApiService.getRequest(AppUrls.profileDetails,);

    if(mounted){
      if(response.isSuccess && response.responseData != null){
        final data = response.responseData?['data'];
        if(data != null && data.isNotEmpty){
          final profile =data is List ? data.first : data;
          setState(() {
            _userData = profile;
          });
          /// local controller save
          await AuthController.saveUserData(profile);
        }
      }
      else {
        setState(() {
          _userData = AuthController.userData;
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}