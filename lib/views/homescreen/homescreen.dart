
import 'package:pharma/views/homescreen/components/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pharma/views/profile.dart';
import 'package:provider/provider.dart';

import '../../configs/app_strings.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../../controllers/authentication_controller.dart';
import '../../models/admin_user_model.dart';
import '../../providers/admin_user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return mainBody();
  }

  Widget mainBody(){
    return CustomBottomNavigation(
      icons: const [
        Icons.dashboard_outlined,
        Icons.history,
        Icons.file_copy_outlined,
        Icons.person_outline
      ],
      activeIcons: const [
        Icons.dashboard,
        Icons.history,
        Icons.file_copy,
        Icons.person
      ],
      screens: [
        DashBoardScreen(),
        Container(child: const  Text(AppStrings.history),),
        Container(child: const Text(AppStrings.scanner),),
        ProfileScreen(),
      ],
      titles: const [AppStrings.dashboard, AppStrings.history, AppStrings.scanner,AppStrings.profile],
      color: themeData.colorScheme.onBackground,
      activeColor: themeData.colorScheme.primary,
      navigationBackground: themeData.backgroundColor,
      brandTextColor: themeData.colorScheme.onBackground,
      initialIndex: 0,
      splashColor: themeData.splashColor,
      highlightColor: themeData.highlightColor,
      backButton: Container(),
      floatingActionButton: Container(),
      iconSize: 20,
      activeIconSize: 20,
      verticalDividerColor: themeData.dividerColor,
      bottomNavigationElevation: 8,
    );
  }
}
