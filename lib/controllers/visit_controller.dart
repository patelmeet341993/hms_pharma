import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_item_model.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_model.dart';
import 'package:pharma/models/visit_model/visit_model.dart';
import 'package:pharma/providers/visit_provider.dart';
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

}
