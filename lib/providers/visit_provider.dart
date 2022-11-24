import 'package:flutter/foundation.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_model.dart';

import '../views/common/models/dashboard_prescription_model.dart';
import '../models/visit_model/visit_model.dart';
import '../utils/logger_service.dart';

class VisitProvider extends ChangeNotifier {
  VisitModel? _visitModel;

  PharmaBillingModel? _pharmaBillingModel;

  DashboardPrescriptionModel? _dashboardPrescriptionModel;

  //getters

  VisitModel? getVisitModel() {
    if(_visitModel != null) {
      return VisitModel.fromMap(_visitModel!.toMap());
    }
    else {
      return null;
    }
  }

  PharmaBillingModel? get getPharmaBillingModel {

    if(_pharmaBillingModel != null) {
      Log().i("getPharmaBillingModel method ${_pharmaBillingModel?.items}");

      return PharmaBillingModel.fromMap(_pharmaBillingModel!.toMap());
    }
    else {

      return null;
    }

  }

  DashboardPrescriptionModel? get getDashboardPrescriptionModel {

    if(_dashboardPrescriptionModel != null) {
      Log().i("getPharmaBillingModel method ${_dashboardPrescriptionModel?.pharmaBillingItemModel}");

      return _dashboardPrescriptionModel;
    }
    else {

      return null;
    }

  }


  //setters

  void setVisitModel(VisitModel? visitModel, {bool isNotify = true}) {
    if (visitModel != null) {
      if (_visitModel != null) {
        _visitModel!.updateFromMap(visitModel.toMap());
      }
      else {
        _visitModel = VisitModel.fromMap(visitModel.toMap());
      }
      // setpharmaBillingModel(_visitModel?.pharmaBilling);
    }
    else {
      _visitModel = null;
    }
    if (isNotify) {
      notifyListeners();
    }
  }

  void setpharmaBillingModel(PharmaBillingModel? pharmaBillingModel, {bool isNotify = true}) {
    Log().i("setpharmaBillingModel.paymentId ${pharmaBillingModel?.items}");

    if (pharmaBillingModel != null) {
      if (_pharmaBillingModel != null) {
        _pharmaBillingModel!.updateFromMap(pharmaBillingModel.toMap());
      }
      else {
        _pharmaBillingModel = PharmaBillingModel.fromMap(pharmaBillingModel.toMap());
      }
    }
    else {
      _pharmaBillingModel = null;
    }
    Log().i("setpharmaBillingModel.paymentId ${_pharmaBillingModel?.items}");

    if (isNotify) {
      Log().i("in notify lisetners");

      notifyListeners();
    }
    Log().i("getPharmaBillingModel.after setting ${getPharmaBillingModel?.items}");

  }

  void setDashboardPrescriptionModel(DashboardPrescriptionModel? dashboardPrescriptionModel, {bool isNotify = true}) {

    if (dashboardPrescriptionModel != null) {
      if (_dashboardPrescriptionModel != null) {
        _dashboardPrescriptionModel = dashboardPrescriptionModel;
      }
      else {
        _dashboardPrescriptionModel = dashboardPrescriptionModel;
      }
    }
    else {
      _dashboardPrescriptionModel = null;
    }
    if (isNotify) {
      Log().i("in notify lisetners");

      notifyListeners();
    }
  }
}