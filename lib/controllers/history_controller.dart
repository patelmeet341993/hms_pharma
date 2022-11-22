import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma/models/visit_model/visit_model.dart';
import 'package:pharma/providers/history_provider.dart';
import 'package:provider/provider.dart';

import '../configs/constants.dart';
import '../providers/visit_provider.dart';
import '../utils/logger_service.dart';
import '../utils/parsing_helper.dart';
import 'firestore_controller.dart';
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
      bool isLoading = false;
      List<VisitModel> visitList = [];
      HistoryProvider historyProvider = Provider.of<HistoryProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.visitsCollection).get();
        List<QueryDocumentSnapshot<Map<String,dynamic>>> documentSnapshot = ParsingHelper.parseListMethod(querySnapshot.docs);
        documentSnapshot.forEach((element){
          visitList.add(VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data())));
        });
        if(visitList.isNotEmpty) {
          historyProvider.setListVisitModel(visitList);
        }
    }
    catch (e,s){
        Log().e(e,s);
    }
  }
}