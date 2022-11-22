import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharma/models/visit_model/visit_model.dart';
import 'package:pharma/views/dashboard/dashboard_screen.dart';
import 'package:pharma/views/dashboard/dashboard_screen.dart';
import 'package:pharma/views/dashboard/visit_details.dart';
import 'package:pharma/views/history/history_screen.dart';

import '../utils/logger_service.dart';
import '../utils/parsing_helper.dart';
import '../views/authentication/login_screen.dart';
import '../views/homescreen/homescreen.dart';
import '../views/homescreen/homescreen3.dart';
import '../views/splashscreen.dart';

class NavigationController {
  static NavigationController? _instance;
  static String chatRoomId = "";
  static bool isNoInternetScreenShown = false;
  static bool isFirst = true;

  factory NavigationController() {
    _instance ??= NavigationController._();
    return _instance!;
  }

  NavigationController._();

  static final GlobalKey<NavigatorState> mainScreenNavigator = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> dashboardScreenNavigator = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> historyScreenNavigator = GlobalKey<NavigatorState>();

  static bool isUserProfileTabInitialized = false;


  static bool checkDataAndNavigateToSplashScreen() {
    Log().d("checkDataAndNavigateToSplashScreen called, isFirst:$isFirst");

    if(isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        isFirst = false;
        Navigator.pushNamedAndRemoveUntil(mainScreenNavigator.currentContext!, SplashScreen.routeName, (route) => false);
      });
    }

    return isFirst;
  }

  static Route? onMainGeneratedRoutes(RouteSettings settings) {
    Log().d("OnMainGeneratedRoutes called for ${settings.name}");

    // if(navigationCount == 2 && Uri.base.hasFragment && Uri.base.fragment != "/") {
    //   return null;
    // }

    if(kIsWeb) {
      if(!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    /*if(!["/", SplashScreen.routeName].contains(settings.name)) {
      if(NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    else {
      if(isFirst) {
        isFirst = false;
      }
    }*/

    Log().d("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/": {
        page = const SplashScreen();
        break;
      }
      case SplashScreen.routeName: {
        page = const SplashScreen();
        break;
      }
      case LoginScreen.routeName: {
        page = const LoginScreen();
        break;
      }
      case HomeScreen.routeName: {
        page = const HomeScreen();
        break;
      }
      case DashBoardMainScreen.routeName: {
        page = const DashBoardMainScreen();
        break;
      }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
  }

  static Route? onHomeGeneratdRoutes(RouteSettings settings) {
    Log().d("OnMainGeneratedRoutes called for ${settings.name}");

    // if(navigationCount == 2 && Uri.base.hasFragment && Uri.base.fragment != "/") {
    //   return null;
    // }

    if(kIsWeb) {
      if(!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    /*if(!["/", SplashScreen.routeName].contains(settings.name)) {
      if(NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    else {
      if(isFirst) {
        isFirst = false;
      }
    }*/

    Log().d("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/": {
        page = const SplashScreen();
        break;
      }
      case SplashScreen.routeName: {
        page = const SplashScreen();
        break;
      }
      case LoginScreen.routeName: {
        page = const LoginScreen();
        break;
      }
      case HomeScreen.routeName: {
        page = const HomeScreen();
        break;
      }
      case VisitDetailsScreen.routeName: {
        Map<String,dynamic> data = ParsingHelper.parseMapMethod(settings.arguments);
        String id = "";
        VisitModel? visitModel;
        bool isFromHistory = false;
        if(data.isNotEmpty){
          id = data["id"];
          visitModel = VisitModel.fromMap(data["visitModel"]);
          isFromHistory = data["isFromHistory"];
        }

        page =  VisitDetailsScreen(id: id,visitModel: visitModel, isFromHistory: isFromHistory);
        break;
      }
      case DashBoardScreen.routeName: {
        page = const DashBoardScreen();
        break;
      }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
  }

  static Route? onHistoryGeneratedRoutes(RouteSettings settings) {
    Log().d("OnMainGeneratedRoutes called for ${settings.name}");

    // if(navigationCount == 2 && Uri.base.hasFragment && Uri.base.fragment != "/") {
    //   return null;
    // }

    if(kIsWeb) {
      if(!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    /*if(!["/", SplashScreen.routeName].contains(settings.name)) {
      if(NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    else {
      if(isFirst) {
        isFirst = false;
      }
    }*/

    Log().d("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/": {
        page = const SplashScreen();
        break;
      }
      case SplashScreen.routeName: {
        page = const SplashScreen();
        break;
      }
      case LoginScreen.routeName: {
        page = const LoginScreen();
        break;
      }
      case HomeScreen.routeName: {
        page = const HomeScreen();
        break;
      }
      case HistoryScreen.routeName: {
        page = const HistoryScreen();
        break;
      } case HistoryMainScreen.routeName: {
        page = const HistoryMainScreen();
        break;
      }
      case VisitDetailsScreen.routeName: {
        Map<String,dynamic> data = ParsingHelper.parseMapMethod(settings.arguments);
        String id = "";
        VisitModel? visitModel;
        bool isFromHistory = false;
        if(data.isNotEmpty){
          id = data["id"];
          visitModel = VisitModel.fromMap(data["visitModel"]);
          isFromHistory = data["isFromHistory"];
        }

        page =  VisitDetailsScreen(id: id,visitModel: visitModel, isFromHistory: isFromHistory,);
        break;
      }
      case DashBoardScreen.routeName: {
        page = const DashBoardScreen();
        break;
      }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
  }


}
