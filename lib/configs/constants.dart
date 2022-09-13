//App Version
import 'package:flutter/material.dart';

import '../views/common/models/home_screen_component_model.dart';

const String app_version = "1.0.0";

//Shared Preference Keys
class SharePrefrenceKeys {
  static const String appThemeMode = "themeMode";
  static const String loggedInUser = "loggedInUser";
}

class AppConstants {
  static const List<String> userTypesForLogin = [AdminUserType.pharmacy];
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
    const HomeScreenComponentModel(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, screen: DashboardScreen(), title: "Dashboard"),
    const HomeScreenComponentModel(icon: Icons.history, activeIcon: Icons.history, screen: Text("History"), title: "History"),
    const HomeScreenComponentModel(icon: Icons.file_copy_outlined, activeIcon: Icons.file_copy, screen: Text("Treatment"), title: "Treatment"),
    const HomeScreenComponentModel(icon: Icons.people_alt_outlined, activeIcon: Icons.people, screen: AdminUsersListScreen(title: "Admin Users"), title: "Admin Users"),
    const HomeScreenComponentModel(icon: Icons.person_outline, activeIcon: Icons.person, screen: AdminUserProfileScreen(), title: "Profile"),
  ];

  List<HomeScreenComponentModel> getHomeScreenComponentsRolewise(String role) {
    return _masterOptions;
  }
}