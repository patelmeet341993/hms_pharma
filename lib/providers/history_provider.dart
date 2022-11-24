import 'package:flutter/foundation.dart';
import 'package:hms_models/models/visit_model/visit_model.dart';

class HistoryProvider extends ChangeNotifier {
  VisitModel? _visitModel;

  List<VisitModel> _visitList = [];


  VisitModel? getVisitModel() {
    if(_visitModel != null) {
      return VisitModel.fromMap(_visitModel!.toMap());
    }
    else {
      return null;
    }
  }


  void setVisitModel(VisitModel? visitModel, {bool isNotify = true}) {
    if (visitModel != null) {
      if (_visitModel != null) {
        _visitModel!.updateFromMap(visitModel.toMap());
      }
      else {
        _visitModel = VisitModel.fromMap(visitModel.toMap());
      }
    }
    else {
      _visitModel = null;
    }
    if (isNotify) {
      notifyListeners();
    }
  }

  void setListVisitModel(List<VisitModel> visitModel, {bool isNotify = true}) {
    _visitList.clear();
    _visitList = visitModel;
    if(isNotify) {notifyListeners();}
  }

  List<VisitModel> get visitList => _visitList;
}