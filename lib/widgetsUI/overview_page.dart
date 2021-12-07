
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/main.dart';
import 'package:intl/intl.dart';
class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
String monthYear = DateFormat.yMMMM().format((DateTime.now()));
late Box<IncomeExpenseModel> incomeExpenseBox;

List<double> incAmounts=[];
List<double> expAmounts=[];
List<String> incCategories=[];
List<String> expCategories=[];
List<double> allAmounts=[];
List<String> allCategories=[];
double prgInd =0;
//List<double>totalAmountsList=[];

  Map<String,double> incExpCatWiseDatas({required bool isIncome}){

    List<int> incomeKeys =incomeExpenseBox.keys.cast<int>().where(
            (key)=> ((incomeExpenseBox.get(key)!.isIncome == isIncome)
            && (incomeExpenseBox.get(key)!.createdDate.month==DateTime.now().month)
            &&(incomeExpenseBox.get(key)!.createdDate.year==DateTime.now().year)) ).toList();
    Map<String, double> datasForPieChart = {};
    List<String> incCatList=[];
    for(int i=0;i<incomeKeys.length;i++){
      var incCat = incomeExpenseBox.get(incomeKeys[i])!.category;
      incCatList.add(incCat.toString());
    }
    var incCatListDuplicateCatRemove=incCatList.toSet().toList();
    incCatList=incCatListDuplicateCatRemove.toList();

    for(int j=0;j<incCatList.length;j++){
      double sum=0;
      for(int i=0;i<incomeKeys.length;i++){
        var inCat = incomeExpenseBox.get(incomeKeys[i])!.category;
        var incCatAmt= incomeExpenseBox.get(incomeKeys[i])!.amount!;
        if(incCatList[j]==inCat){
          sum = sum+incCatAmt;

        }
      }
      datasForPieChart[incCatList[j]]=sum;
    }
    return datasForPieChart;
  }

  double totalAmouns({required bool isIncome,}){
    List<double> totals = [];
    double total = 0;
      totals =incExpCatWiseDatas(isIncome:isIncome).values.toList();
      for (int i = 0; i < totals.length; i++) {
          total = total + totals[i];
        }
      return total;
    }

double balance(){
    double balance = totalAmouns(isIncome: true)-totalAmouns(isIncome: false);
    return balance;
}

double progresIndicatorVal (){
    if(totalAmouns(isIncome: true)>0){
      prgInd = (totalAmouns(isIncome: true) -totalAmouns(isIncome: false))/totalAmouns(isIncome: true);
      return prgInd;
    }
    else{
      prgInd =0;
      return prgInd;
    }

}

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
    FontWeight fontWeight= FontWeight.bold,
    String fontFamily ="ArchitectsDaughter"
  }){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top:5,bottom: 5),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          incomeExpenseBalanceText(
            text: titleText,color: Colors.black,
            fontSize: 17,fontFamily: fontFamily,fontWeight: fontWeight
          ),
          incomeExpenseBalanceText(
              text: amount,color: trailingTextColor,fontSize: 17,
              fontFamily: fontFamily,fontWeight: fontWeight
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
          incomeExpenseBalanceText(text: monthYear,fontSize: 20,color: Colors.black,fontFamily: "PermanentMarker",fontWeight: FontWeight.normal),
          totalIncomeAndExpenseBalanceTile(titleText: "Total Income", amount: "${totalAmouns(isIncome: true)}", trailingTextColor: Colors.green),
          totalIncomeAndExpenseBalanceTile(titleText: "Total Expense", amount: "${totalAmouns(isIncome: false)}", trailingTextColor: Colors.red),
          Divider(color: Color(0xff005c99),),
          totalIncomeAndExpenseBalanceTile(titleText: "Balance", amount: "${balance()}",
              trailingTextColor: balance()>0?Colors.green:Colors.red
          ),
          SizedBox(width: MediaQuery.of(context).size.width*.9,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              child: LinearProgressIndicator(
                backgroundColor: Colors.red,
                valueColor: AlwaysStoppedAnimation(Colors.green),
                minHeight: 8,
                value:progresIndicatorVal(),
              ),
            ),
          ),

          divider(height: 10),
          Container(
            height: MediaQuery.of(context).size.height*.53,
            width: MediaQuery.of(context).size.width*.95,
            margin: EdgeInsets.only(left: 10),
            child: ValueListenableBuilder(

                valueListenable: incomeExpenseBox.listenable(),
                builder: (context, Box<IncomeExpenseModel> incomeExpense,_){
                  if(allCategories.isEmpty){
                    incCategories =
                        incExpCatWiseDatas(isIncome: true).keys.toList();
                    incAmounts =
                        incExpCatWiseDatas(isIncome: true).values.toList();
                    expCategories =
                        incExpCatWiseDatas(isIncome: false).keys.toList();
                    expAmounts =
                        incExpCatWiseDatas(isIncome: false).values.toList();
                    allAmounts.addAll(incAmounts);
                    allAmounts.addAll(expAmounts);
                    allCategories.addAll(incCategories);
                    allCategories.addAll(expCategories);
                  };
                    return ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: allCategories.length,
                    itemBuilder: (context,position,){

                      String category = allCategories[position];
                      double amount   = allAmounts[position];

                      return totalIncomeAndExpenseBalanceTile(
                          titleText: category,
                          fontWeight: FontWeight.w900,
                          amount: amount.toString(),
                          trailingTextColor: position<incCategories.length ?
                          Colors.green:Colors.red,
                          fontFamily: "Outfit"
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: Color(0xff66b3ff),
                      thickness: 1,);
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

