import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_item_model.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_model.dart';
import 'package:pharma/models/visit_model/visit_model.dart';
import 'package:pharma/providers/visit_provider.dart';
import 'package:pharma/utils/parsing_helper.dart';
import 'package:provider/provider.dart';

import '../configs/constants.dart';
import '../utils/logger_service.dart';
import 'firestore_controller.dart';
import 'navigation_controller.dart';

class VisitController {

  static VisitController? _instance;

  factory VisitController() {
    _instance ??= VisitController._();
    return _instance!;
  }

  VisitController._();

  Future<void> getVisitList() async {
    bool isLoading = false;
    List<VisitModel> visitList = [];
    VisitProvider visitProvider = Provider.of<VisitProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.visitsCollection).get();
      List<QueryDocumentSnapshot<Map<String,dynamic>>> documentSnapshot = ParsingHelper.parseListMethod(querySnapshot.docs);
      documentSnapshot.forEach((element){
        visitList.add(VisitModel.fromMap(ParsingHelper.parseMapMethod(element.data())));
      });

      if(visitList.isNotEmpty) {
        visitProvider.setListVisitModel(visitList);
      }
    } catch (e,s){
      Log().e(e,s);
    }
  }

  Future<bool> getVisitDataFromId(String id)async{
    bool isLoading = false;
    if(id.isEmpty)return isLoading;
    try {
      VisitModel? visitModel;
      Query<Map<String, dynamic>> query = FirestoreController().firestore
          .collection(FirebaseNodes.visitsCollection)
          .where("id", isEqualTo: id);
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
        if ((docSnapshot.data() ?? {}).isNotEmpty) {
          VisitModel model = VisitModel.fromMap(docSnapshot.data()!);
          visitModel = model;
          isLoading = true;
        }
      }

      Log().i("in the visitModel!.patientId${visitModel!.patientId}");

      VisitProvider visitProvider = Provider.of<VisitProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      visitProvider.setVisitModel(visitModel);

      PharmaBillingModel pharmaBillingModel = PharmaBillingModel();
      Log().i("in the visitModel!.patientId${pharmaBillingModel.toMap()}");
      List<PharmaBillingItemModel> itemModel = [];

      pharmaBillingModel.patientId = visitModel.patientId;
      visitModel.diagnosis.forEach((visitModelElement) {
        visitModelElement.prescription.forEach((element) {
          itemModel.add(PharmaBillingItemModel(
            dose: element.totalDose,
            medicineName: element.medicineName,
          ));
        });
      });
      Log().i("in the visitModel! itemModel ${itemModel}");

      pharmaBillingModel.items = itemModel;
      Log().i("in the visitModel!.before setpharmaBillingModel ${pharmaBillingModel.items}");

      visitProvider.setpharmaBillingModel(pharmaBillingModel);
    } catch (e,s){
      Log().e(e,s);
    }
    return isLoading;
  }

  Future<VisitModel?> getVisitModel(String id)async {
    Log().i("Visit id: $id");
    try {
      VisitModel? visitModel;
      Query<Map<String, dynamic>> query = FirestoreController().firestore
          .collection(FirebaseNodes.visitsCollection)
          .where("id", isEqualTo: id);
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
        if ((docSnapshot.data() ?? {}).isNotEmpty) {
          VisitModel model = VisitModel.fromMap(ParsingHelper.parseMapMethod(docSnapshot.data()));
          visitModel = model;
        }
      }

      // Log().i("in the visitModel!.patientId${visitModel!.patientId}");
      //
      // VisitProvider visitProvider = Provider.of<VisitProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      // visitProvider.setVisitModel(visitModel);
      //
      // PharmaBillingModel pharmaBillingModel = PharmaBillingModel();
      // Log().i("in the visitModel!.patientId${pharmaBillingModel.toMap()}");
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
      // Log().i("in the visitModel! itemModel ${itemModel}");
      //
      // pharmaBillingModel.items = itemModel;
      // Log().i("in the visitModel!.before setpharmaBillingModel ${pharmaBillingModel.items}");
      //
      // visitProvider.setpharmaBillingModel(pharmaBillingModel);
      return visitModel;
    } catch (e,s){
      Log().e(e,s);
    }

    return VisitModel();
  }


  Future<VisitModel> getVisitModelFromPatientId(String id) async {
    Log().i("Patent id: $id");
    try {
      VisitModel? visitModel;
      Log().i("Patent id: $id");

      Query<Map<String, dynamic>> query = FirestoreController().firestore
          .collection(FirebaseNodes.visitsCollection)
          .where("patientId", isEqualTo: id.trim())
          .where("isPrescribed", isEqualTo: true)
          .where("isMedicine", isEqualTo: false);
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get().catchError((error){
        Log().e("error: $error");
      });
      Log().i("Patent id: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
        if ((docSnapshot.data() ?? {}).isNotEmpty) {
          VisitModel model = VisitModel.fromMap(ParsingHelper.parseMapMethod(docSnapshot.data()));
          visitModel = model;
          print("Error in this ${model.id}");

        }
      }


      return visitModel ?? VisitModel();
    } catch (e,s){
      Log().e(e,s);
      print("Error in this ${e}");
      print(s);
      return VisitModel();
    }
  }
}
