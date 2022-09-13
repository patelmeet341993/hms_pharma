import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharma/configs/constants.dart';
import 'package:pharma/controllers/visit_controller.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_item_model.dart';
import 'package:pharma/models/visit_model/pharma_billings/pharma_billing_model.dart';
import 'package:pharma/utils/date_presentation.dart';
import 'package:pharma/utils/parsing_helper.dart';
import 'package:pharma/views/common/components/loading_widget.dart';
import 'package:uuid/uuid.dart';

import '../../configs/app_strings.dart';
import '../../configs/styles.dart';
import '../../models/dashboard_prescription_model.dart';
import '../../models/visit_model/visit_model.dart';
import '../../utils/logger_service.dart';
import '../../utils/my_safe_state.dart';
import '../common/app_text_form_field.dart';
import '../common/components/primary_text.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with MySafeState {

  late ThemeData themeData;
  TextEditingController uniqueIdController = TextEditingController();
  TextEditingController UserNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileControlller = TextEditingController();
  bool isEnable = true;
  String selectedRadio = "Male";
  bool isLoading = false;

  Future? getFuture;
  VisitModel? visitModel;
  List<DashboardPrescriptionModel> dashBoardPrescriptionModels = [];
  double finalAmount = 0.0, discount = 0.0, withoutGst = 0.0,totalCGSTandSgst = 0.0;
  String paymentId = const Uuid().v4();



  void getTotalAmount(){
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
    finalAmount = (finalAmount + discountAmount.roundToDouble());

    setState(() {});
  }


  void selectDateOfBirth()async {
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
  String id = "1172aef02a8c11eda8eb59e4dfe6c8ee";

  Future<void> getData() async {
    isLoading = true;
    mySetState();

    visitModel = await VisitController().getVisitModel(id);
    if(visitModel != null) {
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

    isLoading = false;
    mySetState();

    // if(!isDataFeteched){
    //   MyToast.showError("Data is not fetched", context);
    // }
  }

  @override
  void initState() {
    super.initState();
    getFuture = getData();
    totalCGSTandSgst = ParsingHelper.parseDoubleMethod(ParsingHelper.parseDoubleMethod(AppConstants.cgstValue)+ParsingHelper.parseDoubleMethod(AppConstants.sgstValue));

  }

  @override
  Widget build(BuildContext context) {
  themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xfffbfbff),

      body: Column(
        children: [
          Expanded(child: getMainBody()),
        ],
      ),
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
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        customerDetailView(),
                        Expanded(child: Container(
                            child: getPrescriptionTable()))
                      ],
                    ),
                  ),
                  Expanded(child: getAmountView()),
                  Expanded(child: MaterialButton(
                    child: Text("hi"),
                    onPressed: (){
                      PharmaBillingModel pharamBillingModel = PharmaBillingModel();
                      pharamBillingModel.totalAmount = finalAmount;
                      pharamBillingModel.discount = discount;
                      pharamBillingModel.patientId = visitModel?.patientId ?? "";
                      pharamBillingModel.paymentId = "cash_$paymentId";
                      pharamBillingModel.paymentMode = "CASH";
                      pharamBillingModel.paymentStatus = "Paid";
                      pharamBillingModel.totalAmount = finalAmount;
                      pharamBillingModel.baseAmount = withoutGst;

                      pharamBillingModel.items = dashBoardPrescriptionModels.map((e) => e.pharmaBillingItemModel).toList();



                      Log().i("PharmaBillingModel data : ${pharamBillingModel.toMap()}");
                    },
                  ))
                ],
              );
        }
        else {
          return LoadingWidget();
        }
      }
    );
  }

  Widget customerDetailView(){
    // VisitModel? model = provider.getVisitModel();
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(text: AppStrings.customerDetail,size: 16),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 0.5,color: Colors.black54)
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(child: commonWidgetWithHeader(AppStrings.userName, visitModel!.currentDoctor)),
                    SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.userId,visitModel!.patientId)),
                    SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.age,visitModel!.description))
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Flexible(child: commonWidgetWithHeader(AppStrings.dob,"+91 7621855610")),
                    SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.mobile,"+91 7621855610")),
                    SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.gender,"Male"))
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
        Text(headerText, style: TextStyle(fontSize: 14.5),),
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
            child: Text(headerText, style: TextStyle(fontSize: 14),)),
        Container(
            child: Text(":")),
        SizedBox(width: 15,),
        Text(text,style: TextStyle(fontWeight: FontWeight.w600),)
      ],
    );
  }

  Widget dobTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Date of birth",style: TextStyle(fontSize: 14.5),),
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
              contentPadding: EdgeInsets.fromLTRB(10, 2, 5, 2)
          ),
        ),
      ],
    );
  }

  Widget genderWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender", style: TextStyle(fontSize: 14.5),),
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

  List<TextEditingController> amountTextEditingControllers = [];

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
        return getDataRow(pharmaBillingItemModel: dashBoardPrescriptionModels[index].pharmaBillingItemModel,mrpController: dashBoardPrescriptionModels[index].mrpController ?? TextEditingController(),amountController: dashBoardPrescriptionModels[index].amountController ?? TextEditingController());
      })


      // (visitProvider.getPharmaBillingModel ?? PharmaBillingModel()).items.map((e) {
      //   amountTextEditingControllers.add(TextEditingController());
      //   return getDataRow(name: e.medicineName,description: "3 nos", quantity: 3, time: "Afternoon,Evening", instruction: "take only when have fever",totalAmount: 26.4,controller: mobileControlller,amountController: amountTextEditingControllers);
      // }).toList()
    );
  }


  DataRow getDataRow({ required PharmaBillingItemModel pharmaBillingItemModel, required TextEditingController mrpController,required TextEditingController amountController }){
    // controller.text = quantity.toString();
    return DataRow(
        cells: [
          getDataCell(pharmaBillingItemModel.medicineName,),
          getDataCell(pharmaBillingItemModel.dose,),
          // getDataCell(pharmaBillingItemModel.dosePerUnit),
          getEditableContent(mrpController,(String? val){
            pharmaBillingItemModel.finalAmount = calculateTotalAmount(mrpController.text.isEmpty ? "0":mrpController.text,amountController.text.isEmpty?"0":amountController.text);
            setState(() {});
            getTotalAmount();
          }),
          // getDataCell(getEditableContent()),
          getDataCell(pharmaBillingItemModel.dosePerUnit,),
          getEditableContent(amountController,(String? val){
            pharmaBillingItemModel.finalAmount = calculateTotalAmount(mrpController.text.isEmpty ? "0":mrpController.text,amountController.text.isEmpty?"0":amountController.text);
            setState(() {});
            getTotalAmount();
          }),
          getDataCell(pharmaBillingItemModel.finalAmount.toString()),
        ]
    );
  }


  String totalAmount = "0";

  double calculateTotalAmount(String quantity, String mrp){
  return ParsingHelper.parseDoubleMethod((int.parse(quantity)*double.parse(mrp)).toStringAsFixed(2));
  }

  DataCell getEditableContent(TextEditingController controller,Function(String? val)? onChanged){
    return DataCell(Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextFormField(controller:controller,hintText: "",textAlign: TextAlign.end,
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
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          PrimaryText(text: AppStrings.paymentDetail,size: 16),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.5,color: Colors.black54)
            ),
            child: Column(
              children: [
                amountItemView("CGST", "${AppConstants.cgstValue}%"),
                amountItemView("SGST", "${AppConstants.sgstValue}%"),

                SizedBox(height: 10,),
                amountItemView("Amount", "₹ $withoutGst"),

                amountItemView("Gst:", "${totalCGSTandSgst}%"),
                SizedBox(height: 10,),
                amountItemView("Total Amount", "₹ $finalAmount"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget amountItemView(String title, String amount){
    return Row(children: [
      Expanded(child: Text(title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),)),
      Text(amount,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),)
    ],);
  }
}
