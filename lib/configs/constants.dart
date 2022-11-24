//App Version
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hms_models/configs/constants.dart';
import 'package:pharma/configs/app_strings.dart';

import '../views/Scanner/scanner.dart';
import '../views/common/models/home_screen_component_model.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/history/history_screen.dart';
import '../views/profile.dart';

const String app_version = "1.0.0";

//Shared Preference Keys
class SharePrefrenceKeys {
  static const String appThemeMode = "themeMode";
  static const String loggedInUser = "loggedInUser";
}

class AppConstants {
  static const List<String> userTypesForLogin = [AdminUserType.pharmacy];
  static const sgstValue = "12";
  static const cgstValue = "12";



  static String hospitalId = "Hospital_1";
}

class HomeScreenComponentsList {
  final List<HomeScreenComponentModel> _masterOptions = [
    const HomeScreenComponentModel(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, screen: DashBoardMainScreen(), title: AppStrings.dashboard),
    const HomeScreenComponentModel(icon: FontAwesomeIcons.clockRotateLeft, activeIcon: FontAwesomeIcons.clockRotateLeft, screen: HistoryMainScreen(), title: AppStrings.history),
    const HomeScreenComponentModel(icon: FontAwesomeIcons.qrcode, activeIcon: FontAwesomeIcons.qrcode, screen: ScannerScreen(), title: AppStrings.scanner),
    const HomeScreenComponentModel(icon: FontAwesomeIcons.gear, activeIcon: FontAwesomeIcons.gear, screen: SettingScreen(), title: AppStrings.profile),
     HomeScreenComponentModel(icon: FontAwesomeIcons.powerOff, activeIcon: FontAwesomeIcons.powerOff, screen: Container(), title: AppStrings.logout),
  ];

  List<HomeScreenComponentModel> getHomeScreenComponentsRolewise(String role) {
    return _masterOptions;
  }
}