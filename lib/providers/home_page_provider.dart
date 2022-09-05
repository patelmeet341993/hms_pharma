import 'package:flutter/foundation.dart';


class HomePageProvider extends ChangeNotifier {

  int _homeTabIndex = 0;


  int get homeTabIndex  => _homeTabIndex;


  void setHomeTabIndex(int index) {
    _homeTabIndex = index;
    notifyListeners();
  }
}