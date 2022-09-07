import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharma/utils/date_presentation.dart';

import '../../configs/app_strings.dart';
import '../../configs/styles.dart';
import '../common/app_text_form_field.dart';
import '../common/components/primary_text.dart';
import '../homescreen/components/dashboard_header.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  late ThemeData themeData;
  TextEditingController uniqueIdController = TextEditingController();
  TextEditingController UserNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileControlller = TextEditingController();
  bool isEnable = true;
  String selectedRadio = "Male";

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
        Expanded(child: getAmountView())
      ],
    );
  }

  Widget customerDetailView(){
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
                    Flexible(child: commonWidgetWithHeader(AppStrings.userName,UserNameController)),
                    SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.userId,uniqueIdController)),
                    SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.age,ageController))
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Flexible(child: dobTextFormField()),
                    SizedBox(width: 10,),
                    Flexible(child: commonWidgetWithHeader(AppStrings.mobile,mobileControlller)),
                    SizedBox(width: 10,),
                    Flexible(child: genderWidget())
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget commonWidgetWithHeader(String headerText,TextEditingController textEditingController) {
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

  Widget tableView(){
    return Container(
      child: DataTable(columns: [
        dataTableColumn(),
        dataTableColumn(),
        dataTableColumn(),
        dataTableColumn(),
      ], rows: [
        dataTableRow()
      ]),
    );
  }
  DataColumn dataTableColumn(){
    return DataColumn(label: Text("data"),);
  }

  DataRow dataTableRow(){
    return DataRow(cells: [
      DataCell(TextFormField()),
      DataCell(TextFormField()),
      DataCell(TextFormField()),
      DataCell(TextFormField()),
      ],
    );
  }

  Widget getPrescriptionTable(){
    return DataTable(
      headingRowHeight: 30,
      headingRowColor: MaterialStateProperty.resolveWith(
              (states) => themeData.primaryColor.withOpacity(0.3),),


      // columnSpacing: 20,

      columns: [
        DataColumn(label:getColumnItem("Medicine")),
        DataColumn(label:getColumnItem("Size")),
        DataColumn(label:getColumnItem("Time")),
        DataColumn(label:getColumnItem("Quantity")),
        DataColumn(label:getColumnItem("Instruction")),
        DataColumn(label:getColumnItem("Mrp")),
        DataColumn(label:getColumnItem("Total amount")),
        // DataColumn(label:Center(child:Text("Quantity",style: themeData.textTheme.bodyText1,))),
        // DataColumn(label:Center(child:Text("Instruction",style: themeData.textTheme.bodyText1,))),
        // DataColumn(label:Center(child:Text("Amount",style: themeData.textTheme.bodyText1,))),
        // DataColumn(label:Center(child:Text("Total amount",style: themeData.textTheme.bodyText1,))),
      ],
      rows: [
        getDataRow(name: "paracetamol",description: "3 nos", quantity: 3, time: "Afternoon,Evening", instruction: "take only when have fever",totalAmount: 26.4),
        getDataRow(name: "crux",description: "50 ml", quantity: 1, time: "Afternoon,Evening", instruction: "after meal", totalAmount: 30),
      ],
    );
  }

  DataRow getDataRow({required String name,required String description,required int quantity,required String time,required String instruction, required double totalAmount }){
    return DataRow(
        cells: [
          getDataCell(name,),
          getDataCell(description,),
          getDataCell(time),
          getDataCell(quantity.toString(),),
          getDataCell(instruction,),
          getDataCell(totalAmount.toString(),),
          getDataCell((quantity*totalAmount).toStringAsFixed(2).toString(),),
          // getDataCell(name,),
        ]
    );
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
                amountItemView("CGST", "12%"),
                amountItemView("SGST", "12%"),
                SizedBox(height: 10,),
                amountItemView("Total Amount", "₹ 200"),
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
