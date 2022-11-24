import 'package:flutter/material.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_item_model.dart';


class DashboardPrescriptionModel {

   PharmaBillingItemModel pharmaBillingItemModel = PharmaBillingItemModel();
   TextEditingController? amountController;
   TextEditingController? mrpController;

   DashboardPrescriptionModel({ this.amountController, this.mrpController, required this.pharmaBillingItemModel});

  // DashboardPrescriptionModel.fromMap(Map<String, dynamic> map) {
  //   Map<String, dynamic> pharmaBillingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['pharmaBilling']);
  //   if(pharmaBillingsMap.isNotEmpty) {
  //     pharmaBillingItemModel = PharmaBillingItemModel.fromMap(pharmaBillingsMap);
  //   }
  //   medicineName = ParsingHelper.parseStringMethod(map['medicineName']);
  //   dose = ParsingHelper.parseStringMethod(map['dose']);
  //   dosePerUnit = ParsingHelper.parseStringMethod(map['dosePerUnit']);
  //   unitCount = ParsingHelper.parseDoubleMethod(map['unitCount']);
  //   price = ParsingHelper.parseDoubleMethod(map['price']);
  //   discount = ParsingHelper.parseDoubleMethod(map['discount']);
  //   finalAmount = ParsingHelper.parseDoubleMethod(map['finalAmount']);
  // }
  //
  // void updateFromMap(Map<String, dynamic> map) {
  //   medicineName = ParsingHelper.parseStringMethod(map['medicineName']);
  //   dose = ParsingHelper.parseStringMethod(map['dose']);
  //   dosePerUnit = ParsingHelper.parseStringMethod(map['dosePerUnit']);
  //   unitCount = ParsingHelper.parseDoubleMethod(map['unitCount']);
  //   price = ParsingHelper.parseDoubleMethod(map['price']);
  //   discount = ParsingHelper.parseDoubleMethod(map['discount']);
  //   finalAmount = ParsingHelper.parseDoubleMethod(map['finalAmount']);
  // }
  //
  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     "medicineName" : medicineName,
  //     "dose" : dose,
  //     "dosePerUnit" : dosePerUnit,
  //     "unitCount" : unitCount,
  //     "price" : price,
  //     "discount" : discount,
  //     "finalAmount" : finalAmount,
  //   };
  // }
  //
  // @override
  // String toString() {
  //   return toMap().toString();
  // }
}