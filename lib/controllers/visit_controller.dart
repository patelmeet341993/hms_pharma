import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hms_models/configs/constants.dart';
import 'package:hms_models/models/visit_model/pharma_billings/pharma_billing_item_model.dart';
import 'package:hms_models/models/visit_model/pharma_billings/pharma_billing_model.dart';
import 'package:hms_models/models/visit_model/visit_model.dart';
import 'package:hms_models/utils/my_print.dart';
import 'package:hms_models/utils/parsing_helper.dart';
import 'package:pharma/providers/visit_provider.dart';
import 'package:provider/provider.dart';

import 'navigation_controller.dart';

class VisitController {

  static VisitController? _instance;

  factory VisitController() {
    _instance ??= VisitController._();
    return _instance!;
  }

  VisitController._();

  Future<void> getVisitList() async {
    // bool isLoading = false;
    List<VisitModel> visitList = [];
    VisitProvider visitProvider = Provider.of<VisitProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseNodes.visitsCollectionReference.get();
      List<QueryDocumentSnapshot<Map<String,dynamic>>> documentSnapshot = ParsingHelper.parseListMethod(querySnapshot.docs);
      for (var element in documentSnapshot) {
        visitList.add(VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data())));
      }

      if(visitList.isNotEmpty) {
        visitProvider.setListVisitModel(visitList);
      }
    }
    catch (e, s){
      MyPrint.printOnConsole("Error in VisitController.getVisitList():$e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<bool> getVisitDataFromId(String id)async{
    bool isLoading = false;
    if(id.isEmpty)return isLoading;
    try {
      VisitModel? visitModel;
      Query<Map<String, dynamic>> query = FirebaseNodes.visitsCollectionReference.where("id", isEqualTo: id);
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
        if ((docSnapshot.data() ?? {}).isNotEmpty) {
          VisitModel model = VisitModel.fromMap(docSnapshot.data()!);
          visitModel = model;
          isLoading = true;
        }
      }

      MyPrint.printOnConsole("in the visitModel!.patientId${visitModel!.patientId}");

      VisitProvider visitProvider = Provider.of<VisitProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      visitProvider.setVisitModel(visitModel);

      PharmaBillingModel pharmaBillingModel = PharmaBillingModel();
      MyPrint.printOnConsole("in the visitModel!.patientId${pharmaBillingModel.toMap()}");
      List<PharmaBillingItemModel> itemModel = [];

      pharmaBillingModel.patientId = visitModel.patientId;
      for (var visitModelElement in visitModel.diagnosis) {
        for (var element in visitModelElement.prescription) {
          itemModel.add(PharmaBillingItemModel(
            dose: element.totalDose,
            medicineName: element.medicineName,
          ));
        }
      }
      MyPrint.printOnConsole("in the visitModel! itemModel $itemModel");

      pharmaBillingModel.items = itemModel;
      MyPrint.printOnConsole("in the visitModel!.before setpharmaBillingModel ${pharmaBillingModel.items}");

      visitProvider.setpharmaBillingModel(pharmaBillingModel);
    }
    catch (e,s){
      MyPrint.printOnConsole("Error in VisitController.getVisitDataFromId():$e");
      MyPrint.printOnConsole(s);
    }
    return isLoading;
  }

  Future<VisitModel?> getVisitModel(String id)async {
    MyPrint.printOnConsole("Visit id: $id");
    try {
      VisitModel? visitModel;
      Query<Map<String, dynamic>> query = FirebaseNodes.visitsCollectionReference.where("id", isEqualTo: id);
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
        if ((docSnapshot.data() ?? {}).isNotEmpty) {
          VisitModel model = VisitModel.fromMap(ParsingHelper.parseMapMethod(docSnapshot.data()));
          visitModel = model;
        }
      }

      // MyPrint.printOnConsole("in the visitModel!.patientId${visitModel!.patientId}");
      //
      // VisitProvider visitProvider = Provider.of<VisitProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      // visitProvider.setVisitModel(visitModel);
      //
      // PharmaBillingModel pharmaBillingModel = PharmaBillingModel();
      // MyPrint.printOnConsole("in the visitModel!.patientId${pharmaBillingModel.toMap()}");
      // List<PharmaBillingItemModel> itemModel = [];
      //
      // pharmaBillingModel.patientId = visitModel.patientId;
      // visitModel.diagnosis.forEach((visitModelElement) {
      //   visitModelElement.prescription.forEach((element) {
      //     itemModel.add(PharmaBillingItemModel(
      //       dose: element.totalDose,
      //       medicineName: element.medicineName,
      //     ));
      //   });
      // });
      // MyPrint.printOnConsole("in the visitModel! itemModel ${itemModel}");
      //
      // pharmaBillingModel.items = itemModel;
      // MyPrint.printOnConsole("in the visitModel!.before setpharmaBillingModel ${pharmaBillingModel.items}");
      //
      // visitProvider.setpharmaBillingModel(pharmaBillingModel);
      return visitModel;
    }
    catch (e,s){
      MyPrint.printOnConsole("Error in VisitController.getVisitModel():$e");
      MyPrint.printOnConsole(s);
    }

    return VisitModel();
  }

  Future<VisitModel> getVisitModelFromPatientId(String id) async {
    MyPrint.printOnConsole("Patent id: $id");
    try {
      VisitModel? visitModel;
      MyPrint.printOnConsole("Patent id: $id");

      Query<Map<String, dynamic>> query = FirebaseNodes.visitsCollectionReference
          .where("patientId", isEqualTo: id.trim())
          .where("isPrescribed", isEqualTo: true)
          .where("isMedicine", isEqualTo: false);
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get().catchError((error){
        MyPrint.printOnConsole("error: $error");
      });
      MyPrint.printOnConsole("Patent id: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
        if ((docSnapshot.data() ?? {}).isNotEmpty) {
          VisitModel model = VisitModel.fromMap(ParsingHelper.parseMapMethod(docSnapshot.data()));
          visitModel = model;
          MyPrint.printOnConsole("Error in this ${model.id}");
        }
      }


      return visitModel ?? VisitModel();
    }
    catch (e,s){
      MyPrint.printOnConsole("Error in VisitController.getVisitModelFromPatientId():$e");
      MyPrint.printOnConsole(s);
      return VisitModel();
    }
  }

  Future<bool> updateVisitModelFirebase(VisitModel visitModel)async {
    bool isSuccess = false;
    try {
      MyPrint.printOnConsole("Patent id: ${visitModel.id}");
       await FirebaseNodes.visitDocumentReference(visitId: visitModel.id).update(visitModel.toMap()).then((value) {
             isSuccess = true;
           })
           .catchError((error){
        MyPrint.printOnConsole("error: $error");
      });
      return isSuccess;
    }
    catch (e,s){
      MyPrint.printOnConsole("Error in VisitController.updateVisitModelFirebase():$e");
      MyPrint.printOnConsole(s);
      return isSuccess;
    }
  }

}
