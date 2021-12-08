

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
    Color titleColor=Colors.black,
    FontWeight fontWeight= FontWeight.bold,
    String fontFamily ="ArchitectsDaughter"
  }){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top:5,bottom: 5),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          incomeExpenseBalanceText(
            text: titleText,color: titleColor,
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
      padding: EdgeInsets.only(left: 5,right: 5),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [

          divider(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Container(
                width: MediaQuery.of(context).size.width*.9,
                height: MediaQuery.of(context).size.height*.185,
                padding: EdgeInsets.all(8),
                //margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  //color: Color(0xff00bfff),
                  gradient: LinearGradient(
                      colors:
                      [appbarBackgroundColor,color2]

                  ),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(monthYear,style: TextStyle(
                      fontFamily: "Outfit",color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500
                    ),),
                    divider(height: 5),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children:  <TextSpan>[
                            TextSpan(text: 'Balance: ',
                                style: TextStyle(fontSize: 15,fontFamily: "Outfit",fontWeight: FontWeight.w400)),
                            TextSpan(text: '${balance()}',
                                style: TextStyle(fontSize: 25,fontFamily: "Outfit",fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        incomeExpenseContainer(text1: " Earned\n", text2:"   ${totalAmouns(isIncome: true)}"),
                        incomeExpenseContainer(text1: "Spent\n ", text2:" ${totalAmouns(isIncome: false)}     ")
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text("income",style: TextStyle(fontFamily: "Outfit",
                color: appbarBackgroundColor,fontWeight:FontWeight.bold ),),
            Text("expense",style: TextStyle(fontFamily: "Outfit",
                color: color2,fontWeight: FontWeight.bold),),
          ],),
          divider(height: 5),
          SizedBox(width: MediaQuery.of(context).size.width*.9,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              child: LinearProgressIndicator(
                backgroundColor: color2,
                valueColor: AlwaysStoppedAnimation(appbarBackgroundColor),
                minHeight: 8,
                value:progresIndicatorVal(),
              ),
            ),
          ),
//--------------------------------------------------------------------------------------------------------------------
          divider(height: 10),
          Expanded(
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
                        // titleColor: position<incCategories.length ?
                        // appbarBackgroundColor:color2,
                          titleText: category,
                          fontWeight: FontWeight.w500,
                          amount: amount.toString(),
                          trailingTextColor: position<incCategories.length ?
                          appbarBackgroundColor:color2,
                          fontFamily: "Outfit"
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return SizedBox();
                      // Divider(color: color2,
                      // thickness: 1,);
                  },
                  );
                }
            ),
          ),

        ],
      ),
    );
  }
  Widget incomeExpenseContainer({
  required String text1,
    required String text2,

}){
    return
    //   SizedBox(
    //   width: 120,
    //   child:RichText(
    //     text: TextSpan(
    //         children: <TextSpan>[
    //           TextSpan(text: text1,
    //               style: TextStyle(fontSize: 15,fontFamily: "Outfit",fontWeight: FontWeight.w400)),
    //           TextSpan(text:text2,style: TextStyle(fontSize: 18,fontFamily: "Outfit")),
    //         ]
    //     ),
    //   ),
    // );
      Container(
      width: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          //color: Color(0xff005c99),
        border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child:RichText(
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: text1,
                  style: TextStyle(fontSize: 15,fontFamily: "Outfit",fontWeight: FontWeight.w400)),
              TextSpan(text:text2,style: TextStyle(fontSize: 18,fontFamily: "Outfit",fontWeight: FontWeight.w500)),
            ]
        ),
      ),
    );
  }
}

