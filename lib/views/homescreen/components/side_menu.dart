import 'package:flutter/material.dart';
import 'package:pharma/configs/app_strings.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Drawer(
      elevation: 2,
      child: Container(
        // height: SizeConfig.screenHeight,
        color: themeData.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
                  const SizedBox(
                height: 100,
              ),
              iconBuilder(text: AppStrings.dashboard),
              iconBuilder(text: AppStrings.history),
              iconBuilder(text: AppStrings.scanner),
              iconBuilder(text: AppStrings.logout),
            ],
          ),
        ),
      ),
    );
  }
  iconBuilder({required String text,}) =>
      ListTile(
        title: Text(text),
      );
}
