import 'package:flutter/foundation.dart';
import 'package:hms_models/models/visit_model/pharma_billings/pharma_billing_model.dart';
import 'package:hms_models/models/visit_model/visit_model.dart';
import 'package:hms_models/utils/my_print.dart';

import '../views/common/models/dashboard_prescription_model.dart';

class VisitProvider extends ChangeNotifier {
  VisitModel? _visitModel;

  PharmaBillingModel? _pharmaBillingModel;

  DashboardPrescriptionModel? _dashboardPrescriptionModel;

  List<VisitModel> _visitList = [];


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
      MyPrint.printOnConsole("getPharmaBillingModel method ${_pharmaBillingModel?.items}");

      return PharmaBillingModel.fromMap(_pharmaBillingModel!.toMap());
    }
    else {

      return null;
    }

  }

  DashboardPrescriptionModel? get getDashboardPrescriptionModel {

    if(_dashboardPrescriptionModel != null) {
      MyPrint.printOnConsole("getPharmaBillingModel method ${_dashboardPrescriptionModel?.pharmaBillingItemModel}");

      return _dashboardPrescriptionModel;
    }
    else {

      return null;
    }

  }

  List<VisitModel> get visitList => _visitList;


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
    MyPrint.printOnConsole("setpharmaBillingModel.paymentId ${pharmaBillingModel?.items}");

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
    MyPrint.printOnConsole("setpharmaBillingModel.paymentId ${_pharmaBillingModel?.items}");

    if (isNotify) {
      MyPrint.printOnConsole("in notify lisetners");

      notifyListeners();
    }
    MyPrint.printOnConsole("getPharmaBillingModel.after setting ${getPharmaBillingModel?.items}");

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
      MyPrint.printOnConsole("in notify lisetners");

      notifyListeners();
    }
  }

  void setListVisitModel(List<VisitModel> visitModel, {bool isNotify = true}) {
    _visitList.clear();
    _visitList = visitModel;
    if(isNotify) {notifyListeners();}
  }

}