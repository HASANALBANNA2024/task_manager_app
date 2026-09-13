# 📝 Task Manager App

A feature-rich, dynamic, and clean-architecture **Task Management Application** built with **Flutter** and powered by a **RESTful API**. This app allows users to create, categorize, track, update, and manage daily tasks efficiently with real-time status counts, secure JWT authentication, state persistence, and customized UI design.

---

## 🛠️ Tech Stack & Dependencies

- **Framework & SDK:** Flutter (Dart SDK `>=3.0.0 <4.0.0`)
- **Networking & API:** `http: ^1.6.0`
- **Data Persistence:** `shared_preferences: ^2.5.5`
- **UI & Typography:** `google_fonts: ^8.2.1`, `cupertino_icons: ^1.0.8`
- **App Launcher & Splash:** `flutter_launcher_icons: ^0.13.1`, `flutter_native_splash: ^2.4.0`

---

## ✨ Core Features & API Mapping

| Feature | Screens & Widgets Involved | REST API Endpoint & Method | Description |
|---|---|---|---|
| **User Authentication** | `login_screen.dart`<br>`sign_up_screen.dart` | `POST` `/login`<br>`POST` `/registration` | Handles secure user sign-up and login. Stores bearer JWT tokens locally using `AuthController` via `SharedPreferences`. |
| **Password Recovery Flow** | `recover_verify_email_screen.dart`<br>`pin_verification_screen.dart`<br>`reset_password_screen.dart` | `GET` `/RecoverVerifyEmail/{email}`<br>`GET` `/RecoverVerifyOTP/{email}/{otp}`<br>`POST` `/RecoverResetPass` | Step-by-step account recovery process using 6-digit email OTP verification and password reset. |
| **Dashboard Overview** | `dashboard_screen.dart`<br>`dashboard_status_grid.dart`<br>`recent_task_list_section.dart` | `GET` `/taskStatusCount`<br>`GET` `/listTaskByStatus/New` | Shows status summary cards (New, In Progress, Completed, Cancelled) alongside recent task lists with loading skeletons. |
| **Task Management (CRUD)** | `add_new_task_bottom_sheet.dart`<br>`edit_task_bottom_sheet.dart`<br>`task_list_screen.dart`<br>`task_details_screen.dart` | `POST` `/createTask`<br>`GET` `/updateTaskStatus/{id}/{status}`<br>`GET` `/deleteTask/{id}` | Enables adding new tasks, filtering tasks by status, updating task progress, and deleting task items. |
| **Profile & Security** | `profile_screen.dart`<br>`edit_profile_screen.dart`<br>`change_password_bottom_sheet.dart` | `POST` `/profileUpdate` | Allows users to edit profile details (name, email, phone) and change login passwords dynamically. |

---

## 📸 Application Screenshots & Key Widgets Breakdown

> *Note: Make sure all screenshot assets are located inside the `screenshots/` directory at the root of your project repository.*

### 1. Splash & Authentication Screens
| Screenshot | Screen Reference | Key Widgets Used |
|---|---|---|
| `![Native Splash Screen](screenshots/native_splash_screen.png)` | `Native Splash` | System-native adaptive splash config |
| `![Splash Screen](screenshots/splash_screen.png)` | `splash_screen.dart` | `ScreenBackground`, `CircularProgressIndicator` |
| `![Login Screen](screenshots/login_screen.png)` | `login_screen.dart` | `Form`, `AppTextField`, `AppButton`, `AppTextButton` |
| `![Sign Up Screen](screenshots/sign_up_screen.png)` | `sign_up_screen.dart` | `Form`, Custom Validators, `SingleChildScrollView` |

---

### 2. Password Recovery Sequence
| Screenshot | Screen Reference | Key Widgets Used |
|---|---|---|
| `![Forgot Password](screenshots/forgot_password.png)` | `recover_verify_email_screen.dart` | `AppTextField`, Validation Logic, `AppButton` |
| `![OTP Verification Screen](screenshots/OTP_Screen.png)` | `pin_verification_screen.dart` | `PinCodeTextField`, Countdown Timer Widget |
| `![Set New Password Screen](screenshots/set_new_screen.png)` | `reset_password_screen.dart` | `AppTextField` (obscured), `AppButton` |

---

### 3. Task Dashboard & Task Lists
| Screenshot | Screen Reference | Key Widgets Used |
|---|---|---|
| `![Dashboard Screen](screenshots/dashboard_screen.png)` | `dashboard_screen.dart` | `DashboardStatusGrid`, `StatusCard`, `RecentTaskListSection` |
| `![Task List Screen](screenshots/task_list_screen.png)` | `task_list_screen.dart` | `TaskFilterChips`, `TaskItemCard`, `SkeletonLoaderCard` |
| `![Empty Task List](screenshots/empty_task_list.png)` | N/A | `TaskEmptyStateWidget`, `ErrorEmptyState` |

---

### 4. Task Actions & Modal Dialogs
| Screenshot | Screen Reference | Key Widgets Used |
|---|---|---|
| `![Add Task Bottom Sheet](screenshots/add_task_bottom_sheet.png)` | `add_new_task_bottom_sheet.dart` | `showModalBottomSheet`, `AppTextField`, `AppButton` |
| `![Task Details Screen](screenshots/task_details_screen.png)` | `task_details_screen.dart` | `AppText`, Status Indicator Badge, Dynamic Cards |
| `![Edit Task Bottom Sheet](screenshots/edit_task_bottom_sheet.png)` | `edit_task_bottom_sheet.dart` | `DropdownButtonFormField`, `showModalBottomSheet` |
| `![Delete Task Pop-up](screenshots/delete_task_popup.png)` | N/A | `AlertDialog`, Action Buttons (`AppButton`) |

---

### 5. Profile Management & Actions
| Screenshot | Screen Reference | Key Widgets Used |
|---|---|---|
| `![Profile Screen](screenshots/profile_screen.png)` | `profile_screen.dart` | `ProfileHeader`, `ProfileTileWidget`, `AppIconButton` |
| `![Edit Profile Screen](screenshots/edit_profile_screen.png)` | `edit_profile_screen.dart` | `CircleAvatar`, Image Picker/Input, `AppTextField` |
| `![Change Password Bottom Sheet](screenshots/only_change_password_from_profile_screen.png)` | `change_password_bottom_sheet.dart` | `showModalBottomSheet`, Form Validation |
| `![App Menu Bottom Sheet](screenshots/app_menu_bottom_sheet.png)` | N/A | Custom BottomSheet Menu |
| `![Logout Confirmation Pop-up](screenshots/logout_pop_from_profile_screen.png)` | `log_out_pop_up.dart` | `AlertDialog`, `AuthController.logout()` |

---

## 📁 Full Architecture & Directory Structure

```text
task_manager_app/
├── lib/
│   ├── app/
│   │   ├── app.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_helper.dart
│   │   │   └── app_urls.dart
│   │   ├── network/
│   │   │   └── api_service.dart
│   │   └── widgets/
│   │       ├── app_bottom_nav_bar.dart
│   │       ├── app_button.dart
│   │       ├── app_icon.dart
│   │       ├── app_icon_button.dart
│   │       ├── app_text.dart
│   │       ├── app_text_button.dart
│   │       ├── app_text_field.dart
│   │       ├── log_out_pop_up.dart
│   │       ├── profile_menu_helper.dart
│   │       └── screen_background.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── controllers/
│   │   │   │   └── auth_controller.dart
│   │   │   └── screen/
│   │   │       ├── login_screen.dart
│   │   │       ├── pin_verification_screen.dart
│   │   │       ├── recover_verify_email_screen.dart
│   │   │       ├── reset_password_screen.dart
│   │   │       ├── sign_up_screen.dart
│   │   │       └── splash_screen.dart
│   │   ├── create_task/
│   │   │   └── add_new_task_bottom_sheet.dart
│   │   ├── dashboard/
│   │   │   ├── controllers/
│   │   │   │   └── task_controller.dart
│   │   │   ├── screen/
│   │   │   │   └── dashboard_screen.dart
│   │   │   └── widgets/
│   │   │       ├── dashboard_status_grid.dart
│   │   │       ├── error_empty_state.dart
│   │   │       ├── profile_header.dart
│   │   │       ├── recent_task_list_section.dart
│   │   │       ├── skeleton_loader_card.dart
│   │   │       ├── status_card.dart
│   │   │       └── task_item_card.dart
│   │   ├── profile/
│   │   │   ├── screens/
│   │   │   │   ├── change_password_bottom_sheet.dart
│   │   │   │   ├── edit_profile_screen.dart
│   │   │   │   └── profile_screen.dart
│   │   │   └── widgets/
│   │   │       └── profile_tile_widget.dart
│   │   ├── task_dashboard/
│   │   │   ├── screens/
│   │   │   │   └── task_list_screen.dart
│   │   │   └── widgets/
│   │   │       ├── task_empty_state_widget.dart
│   │   │       └── task_filter_chips.dart
│   │   └── task_details/
│   │       ├── components/
│   │       │   └── edit_task_bottom_sheet.dart
│   │       └── task_details_screen.dart
├── └── main.dart

