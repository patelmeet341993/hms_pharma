import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharma/configs/constants.dart';
import 'package:pharma/controllers/visit_controller.dart';
import 'package:pharma/models/visit_model/patient_meta_model.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_item_model.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_model.dart';
import 'package:pharma/models/visit_model/treatment_activity_model.dart';
import 'package:pharma/utils/date_presentation.dart';
import 'package:pharma/utils/parsing_helper.dart';
import 'package:pharma/views/common/components/custom_button.dart';
import 'package:pharma/views/common/components/loading_widget.dart';
import 'package:uuid/uuid.dart';

import '../../configs/app_strings.dart';
import '../../configs/styles.dart';
import '../../models/dashboard_prescription_model.dart';
import '../../models/patient_model.dart';
import '../../models/visit_model/visit_model.dart';
import '../../utils/logger_service.dart';
import '../../utils/my_safe_state.dart';
import '../common/app_text_form_field.dart';
import '../common/components/primary_text.dart';

class VisitDetailsScreen extends StatefulWidget {
  static const String routeName = "/VisitDetailsScreen";

  String id = "";
  VisitModel? visitModel;
  bool isFromHistory;

  VisitDetailsScreen({Key? key, this.id = "", this.visitModel, this.isFromHistory = false}) : super(key: key);

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> with MySafeState {

  late ThemeData themeData;
  TextEditingController uniqueIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  List<TextEditingController> amountTextEditingControllers = [];
  late PharmaBillingModel pharmaBillingModel;

  bool isEnable = true;
  String selectedRadio = "Male";
  bool isLoading = false;

  Future? getFuture;
  VisitModel? visitModel;
  String id = "";
  List<DashboardPrescriptionModel> dashBoardPrescriptionModels = [];
  double finalAmount = 0.0, discount = 0.0, withoutGst = 0.0,totalCGSTandSgst = 0.0;
  String paymentId = const Uuid().v4();
  String totalAmount = "0";
  bool isSendPaymentLinkClicked = false;

  void getTotalAmount() {
    discount = 0.0;
    finalAmount = 0;
    finalAmount = dashBoardPrescriptionModels.fold(0, ( previousValue, DashboardPrescriptionModel? element) {
      Log().i(element?.amountController?.text);
      // previousValue + double.parse(element?.amountController?.text ?? "0.0");
      if(element!.amountController!.text.isEmpty){
        return previousValue + ParsingHelper.parseDoubleMethod("0.0");
      }
      return  previousValue + element.pharmaBillingItemModel.finalAmount;
    });
    withoutGst = finalAmount;
    Log().i("totalCGSTandSgst : $totalCGSTandSgst");

    double discountAmount = ParsingHelper.parseDoubleMethod((totalCGSTandSgst/100) * finalAmount);
    Log().i("discountAmount : $discountAmount");
    discount = discountAmount;
    finalAmount = (finalAmount + discountAmount.roundToDouble());
    setState(() {});
  }

  double individualDiscount(finalAmount){
    double discountAmount = ParsingHelper.parseDoubleMethod((totalCGSTandSgst/100) * finalAmount);
    return discountAmount;
  }

  void selectDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if(pickedDate != null) {
      dobController.text = DatePresentation.ddMMMMyyyy(pickedDate);
      isEnable = false;
    }
    setState(() {});
  }

  double calculateTotalAmount(String quantity, String mrp) {
    return ParsingHelper.parseDoubleMethod((int.parse(quantity)*double.parse(mrp)).toStringAsFixed(2));
  }

  Future<void> onSendButtonClick() async {

    if(visitModel != null) {
      isLoading = true;
      setState(() {});
      pharmaBillingModel.totalAmount = finalAmount;
      pharmaBillingModel.discount = discount;
      pharmaBillingModel.patientId = visitModel?.patientId ?? "";
      // pharamBillingModel?.paymentId = "cash_$paymentId";
      // pharamBillingModel?.paymentMode = "CASH";
      // pharamBillingModel?.paymentStatus = "Paid";
      pharmaBillingModel.totalAmount = finalAmount;
      pharmaBillingModel.baseAmount = withoutGst;
      pharmaBillingModel.createdTime = Timestamp.now();
      pharmaBillingModel.items =
          dashBoardPrescriptionModels.map((e) => e.pharmaBillingItemModel)
              .toList();

      visitModel?.pharmaBilling = pharmaBillingModel;
      visitModel?.treatmentActivity = [TreatmentActivityModel(createdTime: Timestamp.now(),activityMessage: TreatmentActivityStreamEnum.billPay)];

      await VisitController().updateVisitModelFirebase(
          visitModel ?? VisitModel()).then((value) {
        isSendPaymentLinkClicked = true;
      });
      isLoading = false;
      setState(() {});
      Log().i("PharmaBillingModel data : ${pharmaBillingModel.toMap()}");
    }
  }

  Future<void> onOnlineOrCashButtonClick(String paymentMode) async {
    if(visitModel != null){
      isLoading = true;
      setState(() {});
      pharmaBillingModel.paymentId = "${paymentMode.toLowerCase()}_$paymentId";
      pharmaBillingModel.paymentMode = paymentMode.toUpperCase();
      pharmaBillingModel.paymentStatus = "Paid";

      visitModel?.treatmentActivity.add(TreatmentActivityModel(createdTime: Timestamp.now(),activityMessage: TreatmentActivityStreamEnum.completed));
      visitModel?.weight = 85;

      await VisitController().updateVisitModelFirebase(
          visitModel ?? VisitModel()).then((value) {
        // isSendPaymentLinkClicked = false;
        setState(() {});
      });
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> getData() async {
    if (visitModel != null) {
      if(!widget.isFromHistory) {
        visitModel?.diagnosis.forEach((visitModelElement) {
          visitModelElement.prescription.forEach((element) {
            dashBoardPrescriptionModels.add(DashboardPrescriptionModel(
                pharmaBillingItemModel: PharmaBillingItemModel(
                  dose: element.totalDose,
                  medicineName: element.medicineName,
                ),
                amountController: TextEditingController(),
                mrpController: TextEditingController()
            ),
            );
          });
        });
      } else {
        pharmaBillingModel = visitModel?.pharmaBilling ?? PharmaBillingModel();
        visitModel?.pharmaBilling?.items.forEach((element) {
          dashBoardPrescriptionModels.add(DashboardPrescriptionModel(
              pharmaBillingItemModel: PharmaBillingItemModel(
                dose: element.dose,
                medicineName: element.medicineName,
                discount: element.discount,
                finalAmount: element.finalAmount,
                price: element.price,
              ),
              amountController: TextEditingController(text: element.price.toString() ),
              mrpController: TextEditingController(text:   element.unitCount.toString())
          ));
        });
        withoutGst = visitModel?.pharmaBilling?.baseAmount ?? 0.0;
        finalAmount = visitModel?.pharmaBilling?.totalAmount ?? 0.0;
      }
    }
    else {
      visitModel = await VisitController().getVisitModel(widget.id);
      if (visitModel != null) {
        visitModel?.diagnosis.forEach((visitModelElement) {
          visitModelElement.prescription.forEach((element) {
            dashBoardPrescriptionModels.add(DashboardPrescriptionModel(
                pharmaBillingItemModel: PharmaBillingItemModel(
                  dose: element.totalDose,
                  medicineName: element.medicineName,
                ),
                amountController: TextEditingController(),
                mrpController: TextEditingController()
            ),
            );
          });
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    pharmaBillingModel = PharmaBillingModel();
    visitModel = widget.visitModel;
    getFuture = getData();

    totalCGSTandSgst = ParsingHelper.parseDoubleMethod(ParsingHelper.parseDoubleMethod(AppConstants.cgstValue)+ParsingHelper.parseDoubleMethod(AppConstants.sgstValue));

  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xfffbfbff),
      body: Center(child: getMainBody()),
    );
  }

  Widget getMainBody(){
    return FutureBuilder(
        future: getFuture,
        builder: (BuildContext context,AsyncSnapshot asyncSnapshot) {
          if(asyncSnapshot.connectionState == ConnectionState.done){
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      customerDetailView(),
                      Expanded(child: Container(
                          child: getPrescriptionTable()))
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: getAmountView()),
                // Expanded(child:
                // MaterialButton(
                //   child: Text("hi"),
                //   onPressed: (){
                //     PharmaBillingModel pharamBillingModel = PharmaBillingModel();
                //     pharamBillingModel.totalAmount = finalAmount;
                //     // pharamBillingModel.discount = discount;
                //     pharamBillingModel.patientId = visitModel?.patientId ?? "";
                //     pharamBillingModel.paymentId = "cash_$paymentId";
                //     pharamBillingModel.paymentMode = "CASH";
                //     pharamBillingModel.paymentStatus = "Paid";
                //     pharamBillingModel.totalAmount = finalAmount;
                //     pharamBillingModel.baseAmount = withoutGst;
                //
                //     pharamBillingModel.items = dashBoardPrescriptionModels.map((e) => e.pharmaBillingItemModel).toList();
                //
                //
                //
                //     Log().i("PharmaBillingModel data : ${pharamBillingModel.toMap()}");
                //    },
                //   ),
                // )
              ],
            );
          }
          else {
            return const LoadingWidget();
          }
        }
    );
  }

  Widget customerDetailView(){
    // VisitModel? model = provider.getVisitModel();
    PatientMetaModel patientMetaModel = visitModel?.patientMetaModel ?? PatientMetaModel();
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PrimaryText(text: AppStrings.customerDetail,size: 18,fontWeight: FontWeight.w600),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5,color: Colors.black54)
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(child: commonWidgetWithHeader(AppStrings.patientName, patientMetaModel.name)),
                    const SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.userId,visitModel?.patientId ?? "")),
                    const SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.dob,DatePresentation.ddMMMMyyyyTimeStamp((patientMetaModel.dateOfBirth ?? Timestamp.now()))))
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Flexible(child: commonWidgetWithHeader(AppStrings.weight,"${visitModel?.weight??""}")),
                    const SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.mobile,patientMetaModel.userMobile)),
                    const SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.gender, patientMetaModel.gender)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget commonWidgetWithHeaderWithTextField(String headerText,TextEditingController textEditingController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headerText, style: const TextStyle(fontSize: 14.5),),
        AppTextFormField(
          controller: textEditingController,
          hintText: "Enter ${headerText}",
        )
      ],
    );
  }

  Widget commonWidgetWithHeader(String headerText,String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            child: Text(headerText, style: const TextStyle(fontSize: 14),)),
        Container(
            child: const Text(":")),
        const SizedBox(width: 15,),
        Flexible(child: Text(text,style: const TextStyle(fontWeight: FontWeight.w600),))
      ],
    );
  }

  Widget dobTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Date of birth",style: TextStyle(fontSize: 14.5),),
        TextFormField(
          controller: dobController,
          onTap: (){
            selectDateOfBirth();
          },
          decoration: InputDecoration(
              enabled: isEnable,
              filled: true,
              hintText: "Date of birth",
              fillColor: Styles.lightTextFiledFillColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Styles.lightFocusedTextFormFieldColor.withOpacity(0.5),width: 0.5)
              ),
              enabledBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Styles.lightFocusedTextFormFieldColor.withOpacity(0.5),width: 0.5)
              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Styles.lightFocusedTextFormFieldColor.withOpacity(0.5),width: 0.5)
              ),
              hoverColor: Styles.lightHoverColor,
              focusedBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Styles.lightFocusedTextFormFieldColor.withOpacity(0.5),width: 0.5)
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 2, 5, 2)
          ),
        ),
      ],
    );
  }

  Widget genderWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender", style: TextStyle(fontSize: 14.5),),
        Row(
          children: [
            radioWidget("Male","Male"),
            const SizedBox(width: 10,),
            radioWidget("Female","Female"),
            const SizedBox(width: 10,),
            radioWidget("Other","Other")
          ],
        )
      ],
    );
  }

  Widget radioWidget(String title,String value){
    return Row(
      children: [
        Text(title),
        const SizedBox(width: 2,),
        Radio(value: value, groupValue: selectedRadio, onChanged: (String? val){
          selectedRadio = val!;
          setState(() {});
        })
      ],
    );
  }

  Widget getPrescriptionTable(){
    // Log().e("Dasshboard screen ${visitProvider.getPharmaBillingModel!.items}");

    return DataTable(
        headingRowHeight: 30,
        headingRowColor: MaterialStateProperty.resolveWith(
              (states) => themeData.primaryColor.withOpacity(0.3),),
        columns: [
          DataColumn(label:getColumnItem("Medicine")),
          DataColumn(label:getColumnItem("Size")),
          // DataColumn(label:getColumnItem("Time")),
          DataColumn(label:getColumnItem("Quantity")),
          DataColumn(label:getColumnItem("Instruction")),
          DataColumn(label:getColumnItem("Mrp")),
          DataColumn(label:getColumnItem("Total amount")),
          // DataColumn(label:Center(child:Text("Quantity",style: themeData.textTheme.bodyText1,))),
          // DataColumn(label:Center(child:Text("Instruction",style: themeData.textTheme.bodyText1,))),
          // DataColumn(label:Center(child:Text("Amount",style: themeData.textTheme.bodyText1,))),
          // DataColumn(label:Center(child:Text("Total amount",style: themeData.textTheme.bodyText1,))),
        ],
        rows: List.generate(dashBoardPrescriptionModels.length, (index) {
          amountTextEditingControllers.add(TextEditingController());
          return getDataRow(pharmaBillingItemModel: dashBoardPrescriptionModels[index].pharmaBillingItemModel,quantityController: dashBoardPrescriptionModels[index].mrpController ?? TextEditingController(),amountController: dashBoardPrescriptionModels[index].amountController ?? TextEditingController());
        })


      // (visitProvider.getPharmaBillingModel ?? PharmaBillingModel()).items.map((e) {
      //   amountTextEditingControllers.add(TextEditingController());
      //   return getDataRow(name: e.medicineName,description: "3 nos", quantity: 3, time: "Afternoon,Evening", instruction: "take only when have fever",totalAmount: 26.4,controller: mobileControlller,amountController: amountTextEditingControllers);
      // }).toList()
    );
  }

  DataRow getDataRow({ required PharmaBillingItemModel pharmaBillingItemModel, required TextEditingController quantityController,required TextEditingController amountController }){
    // controller.text = quantity.toString();
    return DataRow(
        cells: [
          getDataCell(pharmaBillingItemModel.medicineName,),
          getDataCell(pharmaBillingItemModel.dose,),
          // getDataCell(pharmaBillingItemModel.dosePerUnit),
          getEditableContent(quantityController,(String? val){
            // pharmaBillingItemModel.price = calculateTotalAmount(quantityController.text.isEmpty ? "0":quantityController.text,amountController.text.isEmpty?"0":amountController.text);
            pharmaBillingItemModel.unitCount = ParsingHelper.parseDoubleMethod(val);
            setState(() {});
            getTotalAmount();
          }),
          // getDataCell(getEditableContent()),
          getDataCell(pharmaBillingItemModel.dosePerUnit,),
          getEditableContent(amountController,(String? val){
            pharmaBillingItemModel.finalAmount = calculateTotalAmount(quantityController.text.isEmpty ? "0":quantityController.text,amountController.text.isEmpty?"0":amountController.text);
            pharmaBillingItemModel.price = ParsingHelper.parseDoubleMethod(amountController.text.trim());
            pharmaBillingItemModel.discount = individualDiscount(pharmaBillingItemModel.finalAmount);
            setState(() {});
            getTotalAmount();
          }),
          getDataCell(pharmaBillingItemModel.finalAmount.toString()),
        ]
    );
  }

  DataCell getEditableContent(TextEditingController controller,Function(String? val)? onChanged){
    return DataCell(Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextFormField(
          enabled: !widget.isFromHistory,

          controller:controller,
          hintText: "",
          textAlign: TextAlign.end,
          onChanged: onChanged
      ),
    ));
  }

  Widget getColumnItem(String text){
    return Expanded(child:Container(
        child: Center(child: Text(text,style: themeData.textTheme.bodyText1,))));
  }

  DataCell getDataCell(String text){
    return  DataCell(Center(
      child: Text(text,
        style: themeData.textTheme.bodySmall,
        overflow: TextOverflow.visible,
        softWrap: true,),
    ),);
  }

  Widget getAmountView(){
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.fromLTRB(10,5,5,5),
      child: Column(
        children: [
          const PrimaryText(text: AppStrings.paymentDetail,size: 18,fontWeight: FontWeight.w600),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5,color: Colors.black54)
            ),
            child: Column(
              children: [
                amountItemView("CGST", "${AppConstants.cgstValue}%"),
                amountItemView("SGST", "${AppConstants.sgstValue}%"),

                const SizedBox(height: 10,),
                amountItemView("Amount", "₹ $withoutGst"),

                amountItemView("Gst", "${totalCGSTandSgst}%"),
                const SizedBox(height: 10,),
                amountItemView("Total Amount", "₹ $finalAmount"),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Visibility(
            visible: !widget.isFromHistory,
            child: CustomButton(text: "Send Payment Link",
              onTap: finalAmount == 0  || isSendPaymentLinkClicked ?  null : () async {
                await onSendButtonClick();
              },
              circularRadius: 5,
              horizontalPadding: 10,
              verticalPadding: 10,
              minWidth: MediaQuery.of(context).size.width *.9 ,
            ),
          ),
          const SizedBox(height: 10,),
          paymentsButton(visitModel ?? VisitModel()),
          const SizedBox(height: 10,),
          Visibility(
              visible: pharmaBillingModel.paymentStatus == "Paid",
              child: Text("Payment status: ${pharmaBillingModel.paymentStatus}"))
        ],
      ),
    );
  }

  Widget amountItemView(String title, String amount){
    return Row(children: [
      Expanded(child: Text(title,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 17),)),
      Text(amount,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)
    ],);
  }


  Widget paymentsButton(VisitModel visitModel){
    return Visibility(
      visible: isSendPaymentLinkClicked,
      child: Row(
        children: [
            Expanded(
              child: CustomButton(
              onTap: pharmaBillingModel.paymentStatus == "Paid" ? null :  () async {
                onOnlineOrCashButtonClick("Online");
              },
              text: AppStrings.onlinePayment,
              circularRadius: 5,
              backgroundColor: Styles.lightPrimaryColor,
            ),
          ),
          SizedBox(width:10),
          Expanded(
              child: CustomButton(
              onTap:pharmaBillingModel.paymentStatus == "Paid" ? null :  () async {
                onOnlineOrCashButtonClick("Cash");
              },
              text: AppStrings.cash,
              circularRadius: 5,
              backgroundColor: Styles.lightPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
