import 'package:flutter/material.dart';
import 'package:pharma/configs/app_strings.dart';

import '../../configs/styles.dart';

class AppTextFormField extends StatelessWidget {
     const AppTextFormField({Key? key, required this.controller,this.hintText = "Enter", this.textAlign = TextAlign.start, this.onChanged}) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextAlign textAlign;
  final Function(String? val)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign:textAlign ,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        fillColor: Styles.lightTextFiledFillColor,
        border: inputBorder(),
        enabledBorder: inputBorder(),
        disabledBorder: inputBorder(),
        hoverColor: Styles.lightHoverColor,
        focusedBorder:focusedBorder(),
        contentPadding: EdgeInsets.fromLTRB(10, 2, 5, 2)
      ),
    );
  }
  InputBorder inputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.3),width: 0.5)
    );
  }  InputBorder focusedBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Styles.lightFocusedTextFormFieldColor.withOpacity(0.5),width: 0.5)
    );
  }
}
