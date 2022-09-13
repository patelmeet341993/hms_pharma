import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharma/providers/home_page_provider.dart';
import 'package:pharma/views/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:side_navigation/side_navigation.dart';

import '../../configs/app_strings.dart';
import 'components/dashboard_header.dart';
import 'components/side_menu.dart';

class HomeScreen2 extends StatefulWidget {
  static const String routeName = "/HomeScreen2";
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  late ThemeData themeData;
  List<HomeScreenModel> views = [
    HomeScreenModel(
      headerTitle: AppStrings.dashboard,
        bodyWidget:const DashBoardScreen()
    ),
    HomeScreenModel(
      headerTitle: AppStrings.history,
      bodyWidget: const Text(AppStrings.history),
    ),
    HomeScreenModel(
      headerTitle: AppStrings.scanner,
      bodyWidget: Container(
        child: const Text(AppStrings.scanner),
      ),
    ),
    HomeScreenModel(
      headerTitle: AppStrings.logout,
      bodyWidget: const Text(AppStrings.logout),
    )
  ];


  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: getMainBody()
    );
  }

  Widget getMainBody(){
    return Consumer<HomePageProvider>(
      builder: (context,HomePageProvider provider,__) {
        return SafeArea(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SideNavigationBar(
                  theme: SideNavigationBarTheme(
                      backgroundColor: themeData.drawerTheme.backgroundColor,
                      itemTheme: const SideNavigationBarItemTheme(),
                      togglerTheme: const SideNavigationBarTogglerTheme(),
                      dividerTheme: const SideNavigationBarDividerTheme(showHeaderDivider: true, showMainDivider: true, showFooterDivider: false)),
                  selectedIndex: provider.homeTabIndex,
                  header: const SideNavigationBarHeader(
                    image: Icon(Icons.medical_information),
                    title:  Text(AppStrings.HMSpharmacy),
                    subtitle: SizedBox()
                  ),

                  items: const [
                    SideNavigationBarItem(
                      icon: Icons.dashboard,
                      label: AppStrings.dashboard,
                    ),
                    SideNavigationBarItem(
                      icon: FontAwesomeIcons.rectangleList,
                      label: AppStrings.history,
                    ),
                    SideNavigationBarItem(
                      icon: FontAwesomeIcons.qrcode,
                      label: AppStrings.scanner,
                    ),
                    SideNavigationBarItem(
                      icon: Icons.logout,
                      label: AppStrings.logout,
                    ),
                  ],
                  onTap: (index) {
                    provider.setHomeTabIndex(index);
                  },
                ),
                const VerticalDivider(),
                Expanded(
                  child: views.elementAt(provider.homeTabIndex).bodyWidget
                ),
              ],
            )
        );
      }
    );
  }
}


class HomeScreenModel {
  String headerTitle = AppStrings.dashboard;
  Widget bodyWidget = Container();

  HomeScreenModel({required this.headerTitle, required this.bodyWidget});
}