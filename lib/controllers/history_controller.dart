import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hms_models/configs/constants.dart';
import 'package:hms_models/models/visit_model/visit_model.dart';
import 'package:hms_models/utils/my_print.dart';
import 'package:hms_models/utils/parsing_helper.dart';
import 'package:pharma/providers/history_provider.dart';
import 'package:provider/provider.dart';

import 'navigation_controller.dart';

class HistoryController {

  static HistoryController? _instance;

  factory HistoryController() {
    _instance ??= HistoryController._();
    return _instance!;
  }

  HistoryController._();

  Future<void> getHistoryData() async {
    try {
      // bool isLoading = false;
      List<VisitModel> visitList = [];
      HistoryProvider historyProvider = Provider.of<HistoryProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseNodes.visitsCollectionReference.get();
        List<QueryDocumentSnapshot<Map<String,dynamic>>> documentSnapshot = ParsingHelper.parseListMethod(querySnapshot.docs);
        documentSnapshot.forEach((element){
          visitList.add(VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data())));
        });
        if(visitList.isNotEmpty) {
          historyProvider.setListVisitModel(visitList);
        }
    }
    catch (e, s){
      MyPrint.printOnConsole("Error in HistoryController.getHistoryData():$e");
      MyPrint.printOnConsole(s);
    }
  }
}