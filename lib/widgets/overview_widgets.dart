import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ViewWidgtes {
  Widget incomeExpenseBalanceText(
      {required String text,
      required double fontSize,
      FontWeight fontWeight = FontWeight.bold,
      Color color = Colors.black,
      String fontFamily = "ArchitectsDaughter"}) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color),
    );
  }

  Widget totalIncomeAndExpenseBalanceTile(
      {required String titleText,
      required String amount,
      required final Color trailingTextColor,
      Color titleColor = Colors.black,
      FontWeight fontWeight = FontWeight.bold,
      String fontFamily = "ArchitectsDaughter"}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          incomeExpenseBalanceText(
              text: titleText,
              color: titleColor,
              fontSize: 13.sp,
              fontFamily: fontFamily,
              fontWeight: fontWeight),
          incomeExpenseBalanceText(
              text: amount,
              color: trailingTextColor,
              fontSize: 13.sp,
              fontFamily: fontFamily,
              fontWeight: fontWeight),
        ],
      ),
    );
  }

  Widget incomeExpenseContainer(
      {required String text1, required String text2, required context}) {
    return Container(
      width: MediaQuery.of(context).size.width * .35,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          //color: Color(0xff005c99),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: text1,
              style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: "Outfit",
                  fontWeight: FontWeight.w400)),
          TextSpan(
              text: text2,
              style: TextStyle(
                  fontSize: 13.5.sp,
                  fontFamily: "Outfit",
                  fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}
