import 'package:flutter/material.dart';
import 'package:pharma/utils/date_presentation.dart';

import '../../configs/app_strings.dart';
import '../../configs/styles.dart';
import '../common/app_text_form_field.dart';
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
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: DashboardHeader(title:AppStrings.dashboard),
          ),
          getMainBody(),
        ],
      ),
    );
  }

  Widget getMainBody(){
    return Column(
      children: [
        customerDetailView()
      ],
    );
  }

  Widget customerDetailView(){
    return Column(
      children: [
        Text("Customer Details",style: TextStyle(fontWeight: FontWeight.w500),),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 0.5,color: Colors.black54)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(child: commonWidgetWithHeader("UserName",UserNameController)),
                  SizedBox(width: 10,),
                  Flexible(child: commonWidgetWithHeader("Unique Id",uniqueIdController)),
                  SizedBox(width: 10,),
                  Flexible(child: commonWidgetWithHeader("Age",ageController))
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Flexible(child: dobTextFormField()),
                  SizedBox(width: 10,),
                  Flexible(child: commonWidgetWithHeader("Phone",mobileControlller)),
                  SizedBox(width: 10,),
                  Flexible(child: commonWidgetWithHeader("Age",ageController))

                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget commonWidgetWithHeader(String headerText,TextEditingController textEditingController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headerText, style: TextStyle(fontSize: 14.5),),
        AppTextFormField(
          controller: textEditingController,
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
}
