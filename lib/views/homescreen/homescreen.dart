import 'package:pharma/views/homescreen/components/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/constants.dart';
import '../common/models/home_screen_component_model.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeData themeData;

  List<HomeScreenComponentModel> components = [];

  @override
  void initState() {
    super.initState();
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(context, listen: false);
    components = HomeScreenComponentsList().getHomeScreenComponentsRolewise(adminUserProvider.getAdminUserModel()?.role ?? "");
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return mainBody();
  }

  Widget mainBody(){
    return CustomBottomNavigation(
      icons: components.map((e) => e.icon).toList(),
      activeIcons: components.map((e) => e.activeIcon).toList(),
      screens: components.map((e) => e.screen).toList(),
      titles: components.map((e) => e.title).toList(),
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
