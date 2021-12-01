
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/main.dart';
class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

late Box<IncomeExpenseModel> incomeExpenseBox;
double ?incTotal;
double ?expTotal;
double balance=0;

List<double> incAmounts=[];
List<double> expAmounts=[];
List<String> incCategories=[];
List<String> expCategories=[];
List<double> allAmounts=[];
List<String> allCategories=[];


@override
void initState() {
  // TODO: implement initState
  super.initState();
  incomeExpenseBox =Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
}
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
              fontFamily: fontFamily,fontWeight: FontWeight.bold
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
          totalIncomeAndExpenseBalanceTile(titleText: "Total Income", amount: incTotal.toString(), trailingTextColor: Colors.green),
          totalIncomeAndExpenseBalanceTile(titleText: "Total Expense", amount: expTotal.toString(), trailingTextColor: Colors.red),
          Divider(color: Color(0xff005c99),),
          totalIncomeAndExpenseBalanceTile(titleText: "Balance", amount: balance.toString(), trailingTextColor: Colors.green),

          divider(height: 10),
          Container(
            height: MediaQuery.of(context).size.height*.53,
            width: MediaQuery.of(context).size.width*.95,
            margin: EdgeInsets.only(left: 10),
            child: ValueListenableBuilder(

                valueListenable: incomeExpenseBox.listenable(),
                builder: (context, Box<IncomeExpenseModel> incomeExpense,_){

                  Map<String,double> incExpCatWiseDatas({required bool isIncome}){
                        List<int> incomeKeys =incomeExpense.keys.cast<int>().where(
                                (key)=> ((incomeExpense.get(key)!.isIncome == isIncome)
                                && (incomeExpense.get(key)!.createdDate.month==DateTime.now().month)
                                &&(incomeExpense.get(key)!.createdDate.year==DateTime.now().year)) ).toList();
                    Map<String, double> datasForPieChart = {};
                    List<String> incCatList=[];
                    for(int i=0;i<incomeKeys.length;i++){
                      var incCat = incomeExpense.get(incomeKeys[i])!.category;
                      incCatList.add(incCat.toString());
                    }
                    var incCatListDuplicateCatRemove=incCatList.toSet().toList();
                    incCatList=incCatListDuplicateCatRemove.toList();

                    for(int j=0;j<incCatList.length;j++){
                      double sum=0;
                      for(int i=0;i<incomeKeys.length;i++){
                        var inCat = incomeExpense.get(incomeKeys[i])!.category;
                        var incCatAmt= incomeExpense.get(incomeKeys[i])!.amount!;
                        if(incCatList[j]==inCat){
                          sum = sum+incCatAmt;

                        }
                      }
                      datasForPieChart[incCatList[j]]=sum;
                    }
                    return datasForPieChart;
                  }

                  incCategories=incExpCatWiseDatas(isIncome: true).keys.toList();
                  incAmounts=incExpCatWiseDatas(isIncome: true).values.toList();
                  expCategories=incExpCatWiseDatas(isIncome: false).keys.toList();
                  expAmounts=incExpCatWiseDatas(isIncome: false).values.toList();
                  allAmounts.addAll(incAmounts);
                  allAmounts.addAll(expAmounts);
                  allCategories.addAll(incCategories);
                  allCategories.addAll(expCategories);
                    incTotal=0;
                    expTotal=0;
                  for(int i=0;i<allAmounts.length;i++){
                    if(i<incAmounts.length){
                      incTotal=incTotal! + allAmounts[i];

                    }
                    else{
                      expTotal = expTotal! + allAmounts[i];
                    }
                  }


                  balance=incTotal!-expTotal!;
                  print("incomeCategory:$incCategories,"
                      " incomeAmounts: $incAmounts, expenseCat: $expCategories, expAmount: $expAmounts,"
                      "allAmounts: $allAmounts, allCat: $allCategories");
//-----------------------------------------------------------------------------------------------------------------------
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: allCategories.length,
                    itemBuilder: (context,position,){

                      String category = allCategories[position];
                      double amount   = allAmounts[position];

                      return totalIncomeAndExpenseBalanceTile(
                          titleText: category,
                          amount: amount.toString(),
                          trailingTextColor: position<incCategories.length ?
                          Colors.green:Colors.red,
                          fontFamily: "Roboto"
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: Color(0xff66b3ff),
                      thickness: 2.5,);
                  },
                  );
                }
            )

          ),

        ],
      ),
    );
  }
}

