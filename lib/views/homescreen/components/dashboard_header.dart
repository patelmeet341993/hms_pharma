import 'package:flutter/material.dart';
import 'package:pharma/controllers/authentication_controller.dart';
import 'package:pharma/controllers/navigation_controller.dart';
import 'package:pharma/views/homescreen/components/primary_text.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_strings.dart';
import '../../../providers/home_page_provider.dart';
import '../../../utils/logger_service.dart';

class DashboardHeader extends StatelessWidget {
   DashboardHeader({
     this.title = AppStrings.dashboard,
     this.actions,
     this.isActionVisible = false,
     this.isBackVisible = false,
    Key? key,
  }) : super(key: key);
   late ThemeData themeData;
   String title = AppStrings.dashboard;
   Widget? actions ;
   bool isActionVisible, isBackVisible;



  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    HomePageProvider provider = Provider.of(context);
    Log().i("is back visible: ${provider.homeTabIndex}");

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                  visible: provider.homeTabIndex == -1 ? true: false,
                  child: Padding(
                    padding: const EdgeInsets.only(right:10.0),
                    child: InkWell(
                      onTap: (){
                        // Log().i("is popable ? ${NavigationController.dashboardScreenNavigator.currentState!.canPop()}");
                        Navigator.pop(NavigationController.dashboardScreenNavigator.currentContext!);
                        provider.setHomeTabIndex(0);
                      },
                      child: Icon(Icons.arrow_back_ios_new_outlined,size: 24) ,
                    ),
                  ),
                ),
                PrimaryText(
                  text: title,
                  size: 30.0,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ),
            // PrimaryText(
            //   text: 'Payments Updates',
            //   size: 16,
            //   color: themeData.secondaryHeaderColor,
            // ),
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        Visibility(
          visible: isActionVisible,
          child:actions ?? Container()
        )
      ],
    );
  }

  Widget getSearchTextField(){
    return Expanded(
      flex: 1,
      child: TextField(
        decoration: InputDecoration(
          fillColor: themeData.backgroundColor,
          filled: true,
          contentPadding: const EdgeInsets.only(left: 40, right: 50),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(color: themeData.secondaryHeaderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(color: themeData.secondaryHeaderColor),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: themeData.secondaryHeaderColor,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}