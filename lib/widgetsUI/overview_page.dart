

import 'package:flutter/material.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {


  Widget incomeExpenseBalanceText(
      {
        required String text,
        double fontSize = 20,
        FontWeight fontWeight= FontWeight.bold,
        Color color = Colors.black,
        String fontFamily = "ArchitectsDaughter"
      }
      ){
    return Text(
      text,
      style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color:color),
    );
  }
  Widget totalIncomeAndExpenseBalanceTile({
    required String titleText,
    required String amount,
    required final Color trailingTextColor,
    String fontFamily ="ArchitectsDaughter"
  }){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top:5,bottom: 5),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          incomeExpenseBalanceText(
            text: titleText,color: Colors.black,
            fontSize: 17,fontFamily: fontFamily,
          ),
          incomeExpenseBalanceText(
              text: amount,color: trailingTextColor,fontSize: 17,
              fontFamily: fontFamily,fontWeight: FontWeight.normal
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [

          divider(height: 10),
          incomeExpenseBalanceText(text: "December 2021",fontSize: 20,color: Colors.black,fontFamily: "PermanentMarker",fontWeight: FontWeight.normal),
          totalIncomeAndExpenseBalanceTile(titleText: "Total Income", amount: "100000", trailingTextColor: Colors.green),
          totalIncomeAndExpenseBalanceTile(titleText: "Total Expense", amount: "50000", trailingTextColor: Colors.red),
          Divider(color: Color(0xff005c99),),
          totalIncomeAndExpenseBalanceTile(titleText: "Balance", amount: "50000", trailingTextColor: Colors.green),

          divider(height: 10),
          Container(
            height: MediaQuery.of(context).size.height*.53,
            width: MediaQuery.of(context).size.width*.95,
            margin: EdgeInsets.only(left: 10),
            child: ListView.separated(

              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 10,

              itemBuilder: (context,position){
                return totalIncomeAndExpenseBalanceTile(
                    titleText: "Category",
                    amount: "amount",
                    trailingTextColor: Colors.green,
                    fontFamily: "Roboto"
                );
              }, separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Color(0xff66b3ff),);
            },
            ),
          ),


        ],
      ),
    );
  }
}

