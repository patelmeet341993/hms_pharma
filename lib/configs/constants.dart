//App Version
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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


}

class PatientGender {
  static const String male = "Male";
  static const String female = "Female";
  static const String other = "Other";
}

class MedicineType {
  static const String tablet = "Tablet";
  static const String syrup = "Syrup";
  static const String other = "Other";
}

class AdminUserType {
  static const String admin = "Admin";
  static const String doctor = "Doctor";
  static const String pharmacy = "Pharmacy";
  static const String laboratory = "Laboratory";
  static const String reception = "Reception";
}

class FirebaseNodes {
  static const String adminUsersCollection = "admin_users";
  static const String patientCollection = "patient";
  static const String visitsCollection = "visits";
}

class PrescriptionMedicineDoseTime {
  static const String morning = "Morning";
  static const String afternoon = "Afternoon";
  static const String evening = "Evening";
  static const String night = "Night";
}

class PaymentModes {
  static const String cash = "Cash";
  static const String upi = "UPI";
  static const String creditCard = "Credit Card";
  static const String debitCard = "Debit Card";
}

class PaymentStatus {
  static const String pending = "Pending";
  static const String paid = "Paid";
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