import 'package:flutter/material.dart';
import 'package:pharma/controllers/authentication_controller.dart';
import 'package:pharma/views/homescreen/components/primary_text.dart';

import '../../../configs/app_strings.dart';

class DashboardHeader extends StatelessWidget {
   DashboardHeader({
     this.title = AppStrings.dashboard,
     this.actions,
     this.isActionVisible = false,
    Key? key,
  }) : super(key: key);
   late ThemeData themeData;
   String title = AppStrings.dashboard;
   Widget? actions ;
   bool isActionVisible;



  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              text: title,
              size: 30.0,
              fontWeight: FontWeight.w800,
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