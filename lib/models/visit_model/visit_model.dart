import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharma/models/visit_model/patient_meta_model.dart';

import '../../utils/parsing_helper.dart';
import 'diagnosis and prescription/diagnosis_model.dart';
import 'diagnosis and prescription/vitals_model.dart';
import 'pharma_billings/pharma_billing_model.dart';
import 'visit_billings/visit_billing_model.dart';

class VisitModel {
  String id = "", patientId = "", currentDoctor = "", previousVisitId = "";
  Map<String, String> doctors = {};
  Timestamp? createdTime, updatedTime;
  double weight = 0;
  VitalsModel? vitals;
  bool active = false,isPrescribed = false;
  List<DiagnosisModel> diagnosis = <DiagnosisModel>[];
  Map<String, VisitBillingModel> visitBillings = {};
  PharmaBillingModel? pharmaBilling;
  PatientMetaModel? patientMetaModel;

  VisitModel({
    this.id = "",
    this.patientId = "",
    this.currentDoctor = "",
    this.previousVisitId = "",
    this.doctors = const <String, String>{},
    this.createdTime,
    this.updatedTime,
    this.weight = 0,
    this.active = false,
    this.isPrescribed = false,
    this.vitals,
    this.diagnosis = const <DiagnosisModel>[],
    this.visitBillings = const <String, VisitBillingModel>{},
    this.pharmaBilling,
    this.patientMetaModel,
  });

  VisitModel.fromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    patientId = ParsingHelper.parseStringMethod(map['patientId']);
    currentDoctor = ParsingHelper.parseStringMethod(map['currentDoctor']);
    previousVisitId = ParsingHelper.parseStringMethod(map['previousVisitId']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    updatedTime = ParsingHelper.parseTimestampMethod(map['updatedTime']);
    weight = ParsingHelper.parseDoubleMethod(map['weight']);
    active = ParsingHelper.parseBoolMethod(map['active']);
    isPrescribed = ParsingHelper.parseBoolMethod(map['isPrescribed']);

    List<DiagnosisModel> diagnosisList = <DiagnosisModel>[];
    List<Map> diagnosisMapList = ParsingHelper.parseListMethod<dynamic, Map>(map['diagnosis']);
    for (Map diagnosisMap in diagnosisMapList) {
      Map<String, dynamic> newDiagnosisMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(diagnosisMap);
      if(newDiagnosisMap.isNotEmpty) {
        DiagnosisModel visitDiagnosisModel = DiagnosisModel.fromMap(newDiagnosisMap);
        diagnosisList.add(visitDiagnosisModel);
      }
    }
    diagnosis = diagnosisList;

    Map<String, VisitBillingModel> finalVisitBillingsMap = <String, VisitBillingModel>{};
    Map<String, dynamic> visitBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['visitBillings']);
    if(visitBillingsMap.isNotEmpty) {
      visitBillingsMap.forEach((String doctorId, dynamic value) {
        Map<String, dynamic> visitBillingMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(value);
        if(visitBillingMap.isNotEmpty) {
          VisitBillingModel visitBillingModel = VisitBillingModel.fromMap(visitBillingMap);
          finalVisitBillingsMap[doctorId] = visitBillingModel;
        }
      });
    }
    visitBillings = finalVisitBillingsMap;

    Map<String, dynamic> pharmaBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['pharmaBilling']);
    if(pharmaBillingsMap.isNotEmpty) {
      pharmaBilling = PharmaBillingModel.fromMap(pharmaBillingsMap);
    }

    Map<String, dynamic> vitalsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['vitals']);
    if(pharmaBillingsMap.isNotEmpty) {
      vitals = VitalsModel.fromMap(vitalsMap);
    }

    Map<String, dynamic> patientmetaMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['patientMetaModel']);
    if(pharmaBillingsMap.isNotEmpty) {
      patientMetaModel = PatientMetaModel.fromMap(patientmetaMap);
    }
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    patientId = ParsingHelper.parseStringMethod(map['patientId']);
    currentDoctor = ParsingHelper.parseStringMethod(map['currentDoctor']);
    previousVisitId = ParsingHelper.parseStringMethod(map['previousVisitId']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    updatedTime = ParsingHelper.parseTimestampMethod(map['updatedTime']);
    weight = ParsingHelper.parseDoubleMethod(map['weight']);
    active = ParsingHelper.parseBoolMethod(map['active']);
    isPrescribed = ParsingHelper.parseBoolMethod(map['isPrescribed']);


    List<DiagnosisModel> diagnosisList = <DiagnosisModel>[];
    List<Map> diagnosisMapList = ParsingHelper.parseListMethod<dynamic, Map>(map['diagnosis']);
    for (Map diagnosisMap in diagnosisMapList) {
      Map<String, dynamic> newDiagnosisMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(diagnosisMap);
      if(newDiagnosisMap.isNotEmpty) {
        DiagnosisModel visitDiagnosisModel = DiagnosisModel.fromMap(newDiagnosisMap);
        diagnosisList.add(visitDiagnosisModel);
      }
    }
    diagnosis = diagnosisList;

    Map<String, VisitBillingModel> finalVisitBillingsMap = <String, VisitBillingModel>{};
    Map<String, dynamic> visitBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['visitBillings']);
    if(visitBillingsMap.isNotEmpty) {
      visitBillingsMap.forEach((String doctorId, dynamic value) {
        Map<String, dynamic> visitBillingMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(value);
        if(visitBillingMap.isNotEmpty) {
          VisitBillingModel visitBillingModel = VisitBillingModel.fromMap(visitBillingMap);
          finalVisitBillingsMap[doctorId] = visitBillingModel;
        }
      });
    }
    visitBillings = finalVisitBillingsMap;

    Map<String, dynamic> pharmaBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['pharmaBilling']);
    if(pharmaBillingsMap.isNotEmpty) {
      pharmaBilling = PharmaBillingModel.fromMap(pharmaBillingsMap);
    }

    Map<String, dynamic> vitalsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['vitals']);
    if(pharmaBillingsMap.isNotEmpty) {
      vitals = VitalsModel.fromMap(vitalsMap);
    }

    Map<String, dynamic> patientmetaMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['patientMetaModel']);
    if(pharmaBillingsMap.isNotEmpty) {
      patientMetaModel = PatientMetaModel.fromMap(patientmetaMap);
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id" : id,
      "patientId" : patientId,
      "currentDoctor" : currentDoctor,
      "previousVisitId" : previousVisitId,
      "createdTime" : createdTime,
      "updatedTime" : updatedTime,
      "weight" : weight,
      "active" : active,
      "isPrescribed" : isPrescribed,
      "diagnosis" : diagnosis.map((e) => e.toMap()).toList(),
      "visitBillings" : visitBillings.map((key, value) => MapEntry(key, value.toMap())),
      "pharmaBilling" : pharmaBilling?.toMap(),
      "patientMetaModel" : patientMetaModel?.toMap(),
      "vitals" : vitals?.toMap(),
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}