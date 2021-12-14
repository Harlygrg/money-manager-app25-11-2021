
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:money_manager_app/main.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/actions/refactored_functions.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:auto_size_text/auto_size_text.dart';



class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime(now.year,now.month,(now.day)-3),
       end: now,
  );

Future  pickDateRange(BuildContext context)async{
  final   initialDateRange = DateTimeRange(
    start:  DateTime(now.year,now.month,(now.day)-3),
    end: now,
  );
  final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year-3),
      lastDate: now,
    initialDateRange: dateRange,
  );
  if(newDateRange==null){
    return;
  }
  else{
    setState(() {
      dateRange =newDateRange;
      incomeSum();
      expenseSum();
    });
  }
}
  late Box<IncomeExpenseModel> incomeExpenseBox;

  int incrementCounter=0;
DateTime _startDate =now;
 DateTime _endDate =now;
  double sumInc =0;
  double sumExp =0;
  String selectedMonth=DateFormat('MMMM').format(now);
  DateTime monthlyDateSelector(){
    DateTime monthlyDatas = DateTime(now.year,(now.month)-incrementCounter,now.day);
    return monthlyDatas;
  }
  DateTime todaysDateSelector(){
    DateTime todaysDate = DateTime(now.year,now.month,now.day);
    return todaysDate;
  }
  DateTime yesterdaysDateSelector(){
    DateTime yesterdayDate = DateTime(now.year,now.month,(now.day)-1);
    return yesterdayDate;
  }
  final items = ["All","Today","Yesterday","Monthly","Select Range"];
  String dropdownValue ="All";
  double incomeSum(){
    if(dropdownValue=="All"){
      List<int> incomeKeys = incomeExpenseBox.keys.
      cast<int>().where((key) => incomeExpenseBox.get(key)!.isIncome==true).toList();
        double sumIncAll=0;
      for(int i=0;i<=incomeKeys.length-1;i++){
        var incomeAmounts= incomeExpenseBox.get(incomeKeys[i]);
        sumIncAll =sumIncAll + incomeAmounts!.amount!;
      }
      sumInc=sumIncAll;
    }
    else if(dropdownValue=="Today") {
      List<int> incomeKeys = incomeExpenseBox.keys.cast<int>()
          .where(
              (key){
                return
                  (incomeExpenseBox.get(key)!.isIncome == true)
                    &&
                      (incomeExpenseBox.get(key)!.createdDate==todaysDateSelector());
              } )
          .toList();
        double sumIncDay=0;
      for (int i = 0; i <= incomeKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeys[i]);
       sumIncDay = sumIncDay + incomeAmounts!.amount!;
      }
      sumInc=sumIncDay;
    }
    else if(dropdownValue=="Yesterday") {
      List<int> incomeKeys = incomeExpenseBox.keys.cast<int>()
          .where(
              (key){
            return
              (incomeExpenseBox.get(key)!.isIncome == true)
                  &&
                  (incomeExpenseBox.get(key)!.createdDate==yesterdaysDateSelector());
          } )
          .toList();
      double sumIncYesterday=0;
      for (int i = 0; i <= incomeKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeys[i]);
        sumIncYesterday = sumIncYesterday + incomeAmounts!.amount!;
      }
      sumInc=sumIncYesterday;
    }
    else if(dropdownValue=="Monthly") {
      List<int> incomeKeys = incomeExpenseBox.keys.cast<int>()
          .where(
              (key){
            return
              (incomeExpenseBox.get(key)!.isIncome == true)
                  &&
                  (incomeExpenseBox.get(key)!.createdDate.month==monthlyDateSelector().month)
                  &&
                    (incomeExpenseBox.get(key)!.createdDate.year==todaysDateSelector().year);
          } )
          .toList();
      double sumIncMonthly=0;
      for (int i = 0; i <= incomeKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeys[i]);
        sumIncMonthly =sumIncMonthly + incomeAmounts!.amount!;
      }
      sumInc=sumIncMonthly;
    }
    else{
      List<int> incomeKeysRange;
      List <int> range=[];
      _startDate=dateRange.start;
      _endDate =dateRange.end;
      int difference = _endDate.difference(_startDate).inDays;
      for(int i =0;i<=difference; i++){
        range.addAll(incomeExpenseBox.keys.cast<int>().where((key) {
          return (incomeExpenseBox.get(key)!.createdDate==_startDate.add(Duration(days: i)))&&
              (incomeExpenseBox.get(key)!.isIncome == true);
        }
        ).toList());
      }
      incomeKeysRange =range.toList();

      double sumIncRange=0;
      for (int i = 0; i <= incomeKeysRange.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeysRange[i]);
        sumIncRange =sumIncRange + incomeAmounts!.amount!;
      }
      sumInc=sumIncRange;
    }
    return sumInc;
  }
  double expenseSum(){

    if(dropdownValue=="All"){
        List<int> expenseKeys = incomeExpenseBox.keys.
        cast<int>().where((key) => incomeExpenseBox.get(key)!.isIncome==false).toList();
        double sumExpAll=0;
        for(int i=0;i<=expenseKeys.length-1;i++){
          var expenseAmounts= incomeExpenseBox.get(expenseKeys[i]);
          sumExpAll =sumExpAll + expenseAmounts!.amount!;
        }
        sumExp=sumExpAll;
      }
      else if(dropdownValue=="Today") {
        List<int> expenseKeys = incomeExpenseBox.keys.cast<int>()
            .where(
                (key){
              return
                (incomeExpenseBox.get(key)!.isIncome == false)
                    &&
                    (incomeExpenseBox.get(key)!.createdDate==todaysDateSelector());
            } )
            .toList();
        double sumExpDay=0;
        for (int i = 0; i <= expenseKeys.length - 1; i++) {
          var expenseAmounts = incomeExpenseBox.get(expenseKeys[i]);
          sumExpDay = sumExpDay + expenseAmounts!.amount!;
        }
        sumExp=sumExpDay;
      }
      else if(dropdownValue=="Yesterday") {
        List<int> expenseKeys = incomeExpenseBox.keys.cast<int>()
            .where(
                (key){
              return
                (incomeExpenseBox.get(key)!.isIncome == false)
                    &&
                    (incomeExpenseBox.get(key)!.createdDate==yesterdaysDateSelector());
            } )
            .toList();
        double sumExpYesterday=0;
        for (int i = 0; i <= expenseKeys.length - 1; i++) {
          var expenseAmounts = incomeExpenseBox.get(expenseKeys[i]);
          sumExpYesterday =  sumExpYesterday + expenseAmounts!.amount!;
        }
        sumExp= sumExpYesterday;
      }
      else if(dropdownValue=="Monthly") {
        List<int> expenseKeys = incomeExpenseBox.keys.cast<int>()
            .where(
                (key){
              return
                (incomeExpenseBox.get(key)!.isIncome == false)
                    &&
                    (incomeExpenseBox.get(key)!.createdDate.month==monthlyDateSelector().month)
                    &&
                      (incomeExpenseBox.get(key)!.createdDate.year==todaysDateSelector().year);
            } )
            .toList();
        double sumExpMonthly=0;
        for (int i = 0; i <= expenseKeys.length - 1; i++) {
          var incomeAmounts = incomeExpenseBox.get(expenseKeys[i]);
          sumExpMonthly =sumExpMonthly + incomeAmounts!.amount!;
        }
        sumExp=sumExpMonthly;
      }
      else{
        List<int> expenseKeysRange;
        List <int> range=[];
        _startDate=dateRange.start;
        _endDate =dateRange.end;
        print("start Date :$_startDate, end Date : $_endDate");
        int difference = _endDate.difference(_startDate).inDays;
        for(int i =0;i<=difference; i++){
          range.addAll(incomeExpenseBox.keys.cast<int>().where((key) {
            return (incomeExpenseBox.get(key)!.createdDate==_startDate.add(Duration(days: i)))&&
                (incomeExpenseBox.get(key)!.isIncome == false);
          }
          ).toList());
        }
        expenseKeysRange =range.toList();

        double sumExpRange=0;
        for (int i = 0; i <= expenseKeysRange.length - 1; i++) {
          var incomeAmounts = incomeExpenseBox.get(expenseKeysRange[i]);
          sumExpRange =sumExpRange + incomeAmounts!.amount!;
        }
        sumExp=sumExpRange;
      }


    return sumExp;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    incomeExpenseBox =Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
    incomeSum();
    expenseSum();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: SizedBox(
        //backgroundColor: Color(0xfffff7e6),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            divider(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                divider(width: 2),
                dropdownValue=="Monthly"?
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: timePeriodeChageIcon(
                          onPressed: (){
                            if(dropdownValue=="Monthly"){
                              setState(() {
                                if(incrementCounter<11){
                                  incrementCounter=incrementCounter+1;
                                }

                                selectedMonth=DateFormat('MMMM').format(monthlyDateSelector());
                                incomeSum();
                                expenseSum();

                              });
                            }
                          },
                          icon: const Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: timePeriodeChageIcon(
                          onPressed: (){
                            if(dropdownValue=="Monthly"){
                              setState(() {
                                if(incrementCounter>0) {
                                  incrementCounter = incrementCounter - 1;
                                  selectedMonth = DateFormat('MMMM').format(
                                      monthlyDateSelector());
                                  incomeSum();
                                  expenseSum();
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.arrow_forward_ios,size: 25,color: Colors.white,)
                          //arrow_back_ios
                      ),
                    )
                  ],
                ):divider(),
                Container(
                  margin: const EdgeInsets.only(top: 5,right: 3),
                  height: 40,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff005c99),
                        width: 2,
                        style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  child: FittedBox(
                    fit:BoxFit.fitWidth,
                    child: DropdownButton(
                      underline: AutoSizeText(""),
                      style:   TextStyle(
                          color: appbarBackgroundColor,
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                      focusColor:Colors.white,
                      hint: AutoSizeText("Select Category"),
                      items: items.map((itemsname) {
                        return DropdownMenuItem(
                          value: itemsname,
                          child: AutoSizeText(itemsname),
                        );
                      }).toList(),
                      onChanged:(String ?newValue){
                        setState(() {
                          dropdownValue =newValue!;
                          incomeSum();
                          expenseSum();
                        });
                      },
                      value: dropdownValue,
                    ),
                  ),
                ),
                divider(height: 15),
              ],
            ),
            dropdownValue=="Monthly"?
            Text(
              selectedMonth,
              style: TextStyle(fontFamily: "Outfit",fontWeight: FontWeight.w500,
                  fontSize: 17),):
                divider(),
            dropdownValue=="Select Range" ?
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: dateRangeShow(
                      initialDate: DateFormat('MMMMd').format(dateRange.start),
                      finalDate: DateFormat('MMMMd').format(dateRange.end),
                      onTap: (){
                        pickDateRange(context);
                      }
                  ),
                ):SizedBox(height: 1,),
            divider(height: 5),
            totalIncomeAndTotalExpenseShowingRow(totalIncomeText: "income\n",
                totalIncome: sumInc.toString(),
                totalExpenseText: "expense\n",
                totalExpense: sumExp.toString()),
           divider(height: 15),

           if (incomeExpenseBox.isNotEmpty) Expanded(
             child: ValueListenableBuilder(
               valueListenable: incomeExpenseBox.listenable(),
               builder: (context, Box<IncomeExpenseModel> incomeExpense,_){
                 List<int> keys;
                 if(dropdownValue=="All"){
                   List<int> keysUnsorted;
                   keysUnsorted =incomeExpense.keys.cast<int>().where((key) =>
                   incomeExpense.get(key)!.createdDate.year==todaysDateSelector().year).toList();
                   List<DateTime> datesList=[];
                   for(int i=0;i<keysUnsorted.length;i++){
                     DateTime date = incomeExpense.get(keysUnsorted[i])!.createdDate;
                     datesList.add(date);
                   }
                   datesList.sort();
                   List<DateTime> reversedDateList = List.from(datesList.reversed);
                   var duplicatesRemovedFromReversedDateList= reversedDateList.toSet().toList();
                   reversedDateList =duplicatesRemovedFromReversedDateList.toList();
                   List<int> sortedKeys=[];
                   List<int> keyInorder;
                   for(int j=0;j<reversedDateList.length;j++){
                     keyInorder = incomeExpense.keys.cast<int>().where((key) =>
                     incomeExpense.get(key)!.createdDate==reversedDateList[j]).toList();
                     List<int> reversedList = List.from(keyInorder.reversed);
                     sortedKeys.addAll(reversedList);

                   }
                   keys= sortedKeys.toList();
                 }
                 else if(dropdownValue=="Today") {
                   keys = incomeExpense.keys.cast<int>().where((key) =>
                   incomeExpense.get(key)!.createdDate==todaysDateSelector()).toList();
                   var reversedKeys=keys.reversed;
                   keys = reversedKeys.toList();
                 }
                 else if(dropdownValue=="Yesterday"){
                   keys = incomeExpense.keys.cast<int>().where((key) =>
                   incomeExpense.get(key)!.createdDate==yesterdaysDateSelector()).toList();
                   var reversedKeys=keys.reversed;
                   keys = reversedKeys.toList();
                 }
                 else if(dropdownValue=="Monthly"){
                   List<int> unsortedKeysForOneMonth;
                   unsortedKeysForOneMonth = incomeExpense.keys.cast<int>().where((key) =>
                   (incomeExpense.get(key)!.createdDate.month==monthlyDateSelector().month)&&
                       (incomeExpense.get(key)!.createdDate.year==monthlyDateSelector().year)).toList();
                   selectedMonth =DateFormat('MMMM').format(monthlyDateSelector());
                   List<DateTime> monthlyDatesList=[];
                   for(int i=0;i<unsortedKeysForOneMonth.length;i++){
                     DateTime date = incomeExpense.get(unsortedKeysForOneMonth[i])!.createdDate;
                     monthlyDatesList.add(date);
                   }
                   monthlyDatesList.sort();
                   var duplicateDatesRemoved = monthlyDatesList.reversed.toSet().toList();
                   monthlyDatesList = duplicateDatesRemoved.toList();
                   Iterable<int> monthelyKeysInorder;
                   List<int> sortedMothlyKeys=[];
                   for(int j=0;j<monthlyDatesList.length;j++){
                     monthelyKeysInorder = incomeExpense.keys.cast<int>().where((key) =>
                     incomeExpense.get(key)!.createdDate==monthlyDatesList[j]);
                     sortedMothlyKeys.addAll(monthelyKeysInorder);

                   }
                   keys =sortedMothlyKeys.toList();

                 }
                 else if(dropdownValue=="Select Range"){
                   List <int> range=[];
                   _startDate=dateRange.start;
                   _endDate =dateRange.end;
                   int difference = _endDate.difference(_startDate).inDays;
                   for(int i =0;i<=difference; i++){
                     range.addAll(incomeExpense.keys.cast<int>().where((key) =>
                     incomeExpense.get(key)!.createdDate==_startDate.add(Duration(days: i))).toList());
                   }
                   keys =range.reversed.toList();
                 }
                 else{
                   return Text("No Transactions");
                 }
                 //---------------------------------------------------++++++++++++++++++++------------------------------
                 return keys.length==0? Center(
                   child:Text("No Trasactions saved",
                     style: TextStyle(fontSize: 18,fontFamily: "Outfit",fontWeight: FontWeight.w500),)
                 ):
                   GridView.count(crossAxisCount: 2,
                     scrollDirection: Axis.vertical,
                     crossAxisSpacing: 10,
                     mainAxisSpacing: 10,
                     shrinkWrap: true,
                     childAspectRatio: (2/1.1 ),
                     children: List.generate(keys.length, (index){
                       final int key  = keys[index];
                       final incomeExpenseValues= incomeExpense.get(key);
                       return GestureDetector(
                         child: Container(
                           decoration: BoxDecoration(
                               // gradient: LinearGradient(
                               //     colors:
                               //     [appbarBackgroundColor,color2],
                               //   begin: Alignment.topCenter,
                               //   end: Alignment.bottomCenter,
                               //   stops: [.3,1]
                               // ),
                             color: appbarBackgroundColor,
                               borderRadius: BorderRadius.circular(10),
                               border: Border.all(color: appbarBackgroundColor,width: 3)
                           ),
                           padding: const EdgeInsets.only(left: 15,top: 10,bottom: 5),
                           child: RichText(
                             text: TextSpan(
                               children: <TextSpan>[
                                 TextSpan(
                                   text:"${DateFormat.MMMd().format(incomeExpenseValues!.createdDate)}\n",
                                 style: TextStyle(fontFamily: "Outfit",fontSize: 15,
                                     fontWeight: FontWeight.w400,
                                     color: incomeExpenseValues.isIncome==true?Color(0xffe6f7ff): Colors.black87,
                                 )
                             ),
                         TextSpan(
                         text:"  ${incomeExpenseValues.category}\n",
                         style: TextStyle(fontFamily: "Outfit",fontSize: 20,
                             fontWeight: FontWeight.w500,
                             color: incomeExpenseValues.isIncome==true?Color(0xffe6f7ff): Colors.black87,
                         )
                         ),
                                 TextSpan(
                                     text:"  ${incomeExpenseValues.amount}",
                                     style: TextStyle(fontFamily: "Outfit",fontSize: 24,
                                         fontWeight: FontWeight.w500,
                                         color: incomeExpenseValues.isIncome==true?Color(0xffe6f7ff): Colors.black87,
                                     )
                                 )]
                           )
                         )),
                         onLongPress:  (){
                           showDialog(context: context,
                               builder: (context){
                                 return AlertDialog(
                                   title:Text(incomeExpenseValues.category),
                                   content:  Text("${incomeExpenseValues.extraNotes}"),
                                   actions: [
                                     Text(DateFormat.MMMd().format(incomeExpenseValues.createdDate),),
                                     Text( "${incomeExpenseValues.amount}",
                                       style: TextStyle(
                                         color: incomeExpenseValues.isIncome==true? Colors.green:Colors.red,),),
                                   ],
                                 );
                               }
                           );
                         },
                         onTap:  (){
                           //Navigator.pushNamed(context, 'UpdateOrDeleteDetails');
                           showDialog(context: context,
                               builder: (context){
                                 return AlertDialog(
                                   actions: [
                                     ListTile(
                                       title: Text("Delete",
                                         style: TextStyle(color: Colors.black),),

                                       onTap:  (){
                                         ScaffoldMessenger.of(context).showSnackBar(
                                             SnackBar(
                                               content:Text('Are you sure?'),
                                               behavior: SnackBarBehavior.floating,
                                               elevation: 6.0,
                                               action: SnackBarAction(
                                                 textColor: appbarBackgroundColor,
                                                   label: "yes",
                                                   onPressed:(){
                                                     incomeExpenseBox.delete(key);
                                                     setState(() {
                                                       incomeSum();
                                                       expenseSum();
                                                     });
                                                   }),
                                               backgroundColor: color2,
                                             )
                                         );
                                         Navigator.pop(context);
                                       },
                                     )
                                   ],

                                 );
                               }
                           );
                         },
                       );
                     }),);
               },
             ),
           ) else Center(child: Text("No Transactions")),
          ],
        ),

      ),
    );
  }
}
