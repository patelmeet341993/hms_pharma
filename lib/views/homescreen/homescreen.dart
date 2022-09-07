
import 'package:pharma/views/homescreen/components/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/app_strings.dart';
import '../dashboard/dashboard_screen.dart';

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
    // return Container(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: const Text("Home Screen"),
    //       actions: [
    //         IconButton(
    //           onPressed: () {
    //             AuthenticationController().logout(context: context);
    //           },
    //           icon: const Icon(Icons.logout),
    //         )
    //       ],
    //     ),
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const Text("Home Body"),
    //           const SizedBox(height: 20,),
    //           Consumer<AdminUserProvider>(
    //             builder: (BuildContext context, AdminUserProvider adminUserProvider, Widget? child) {
    //               AdminUserModel? adminUserModel = adminUserProvider.getAdminUserModel();
    //               if(adminUserModel == null) {
    //                 return const Text("Not Logged in");
    //               }
    //               return Column(
    //                 children: [
    //                   Text("User Name:${adminUserProvider.getAdminUserModel()!.name}"),
    //                   Text("User Role:${adminUserProvider.getAdminUserModel()!.role}"),
    //                 ],
    //               );
    //             },
    //           ),
    //           const SizedBox(height: 20,),
    //           FlatButton(
    //             onPressed: () {
    //               VisitController().createDummyVisitDataInFirestore();
    //               // PatientController().createDummyPatientDataInFirestore();
    //             },
    //             child: const Text("Create Visit"),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget mainBody(){
    return CustomBottomNavigation(
      icons: const [
        Icons.dashboard_outlined,
        Icons.history,
        Icons.file_copy_outlined,
        Icons.logout_outlined
      ],
      activeIcons: const [
        Icons.dashboard,
        Icons.history,
        Icons.file_copy,
        Icons.logout

      ],
      screens: [
        DashBoardScreen(),
        Container(child: const  Text(AppStrings.history),),
        Container(child: const Text(AppStrings.scanner),),
        Container(child: const Text(AppStrings.logout),),
      ],
      titles: const [AppStrings.dashboard, AppStrings.history, AppStrings.scanner,AppStrings.logout],
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
