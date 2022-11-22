import 'package:flutter/material.dart';

import '../../../configs/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, this.onTap,
    this.backgroundColor = Styles.lightPrimaryColor,
    this.horizontalPadding = 10,
    this.verticalPadding = 5,
    this.fontColor = Colors.white, this.child, this.minWidth = 88.0, this.circularRadius = 10, this.text = "", this.fontSize = 14, this.fontWeight = FontWeight.w500}) : super(key: key);

  final Function()? onTap;
  final Color backgroundColor, fontColor;
  final Widget? child;
  final double minWidth; //by default minWidth is 88.0;
  final double circularRadius, fontSize, horizontalPadding, verticalPadding; //by default is 10;
  final String text;
  final FontWeight fontWeight;


  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      onPressed: onTap,
      disabledColor: backgroundColor.withOpacity(0.6),
      minWidth: minWidth,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circularRadius)),
      child: child ?? Text(text, style: TextStyle(fontSize: fontSize,fontWeight: fontWeight,color: fontColor),),
    );
  }
}
