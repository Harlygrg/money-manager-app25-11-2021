
import 'package:flutter/cupertino.dart';
import 'package:money_manager_app/main.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';



class Transactions extends StatefulWidget {
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
    initialDateRange: dateRange?? initialDateRange,
  );
  if(newDateRange==null){
    return;
  }
  else{
    setState(() {
      dateRange =newDateRange;
    });
  }
}

  late Box<IncomeExpenseModel> incomeExpenseBox;
  static DateTime now = DateTime.now();
  static String newdate=  DateFormat('yyyy-MM-dd').format(now);
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
  DateRangePickerController _controller = DateRangePickerController();
  double incomeSum(){
    if(dropdownValue=="All"){
      List<int> incomeKeys = incomeExpenseBox.keys.
      cast<int>().where((key) => incomeExpenseBox.get(key)!.isIncome==true).toList();

      for(int i=0;i<=incomeKeys.length-1;i++){
        var incomeAmounts= incomeExpenseBox.get(incomeKeys[i]);
        sumInc =sumInc + incomeAmounts!.amount!;
        print("==============sum Income:$sumInc ");

      }
    }

    else if(dropdownValue=="Today") {
      List<int> incomeKeys = incomeExpenseBox.keys.
      cast<int>()
          .where((key) => incomeExpenseBox.get(key)!.isIncome == true)
          .toList();

      for (int i = 0; i <= incomeKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeys[i]);
        sumInc = sumInc + incomeAmounts!.amount!;
        print("==============sum Income:$sumInc ");
      }
    }
    return sumInc;
  }
  double expenseSum(){
    List<int> expenseKeys = incomeExpenseBox.keys.
    cast<int>().where((key) => incomeExpenseBox.get(key)!.isIncome==false).toList();

    for(int i=0;i<=expenseKeys.length-1;i++){
      var incomeAmounts= incomeExpenseBox.get(expenseKeys[i]);
      sumExp =sumExp + incomeAmounts!.amount!;
      print("==============sum Expense :$sumExp ");

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

    return Container(
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
              Container(
                width: 176,
                margin: EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    timePeriodeChageIcon(
                        onPressed: (){
                          if(dropdownValue=="Monthly"){
                            setState(() {
                              if(incrementCounter>0){
                                incrementCounter=incrementCounter-1;
                                selectedMonth=DateFormat('MMMM').format(monthlyDateSelector());
                              }
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_back_ios,size: 25,)
                    ),
                    timePeriodeChageIcon(
                        onPressed: (){
                          if(dropdownValue=="Monthly"){
                            setState(() {
                              incrementCounter=incrementCounter+1;
                              selectedMonth=DateFormat('MMMM').format(monthlyDateSelector());
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded,size: 25,)
                        //arrow_back_ios
                    )
                  ],
                ),
              ):divider(),
              DropdownButton(
                style:  const TextStyle(color: Colors.blue),
                focusColor:Colors.white,
                hint: Text("Select Category"),
                items: items.map((itemsname) {
                  return DropdownMenuItem(
                    value: itemsname,
                    child: Text(itemsname),
                  );
                }).toList(),
                onChanged:(String ?newValue){
                  setState(() {
                    dropdownValue =newValue!;
                  });
                },
                value: dropdownValue,
              ),
              divider(height: 15),
            ],
          ),
          dropdownValue=="Monthly"?
          Text(
            selectedMonth,
            style: TextStyle(fontFamily: "BalsamiqSans",fontSize: 17),):
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
          totalIncomeAndTotalExpenseShowingRow(
              totalIncome: sumInc.toString(),
              totalExpense: sumExp.toString()),
          Container(
            margin: EdgeInsets.only(left: 10),
            height: MediaQuery.of(context).size.height*.59,
            width: MediaQuery.of(context).size.width*.95,
                    child: ValueListenableBuilder(
                      valueListenable: incomeExpenseBox.listenable(),
                      builder: (context, Box<IncomeExpenseModel> incomeExpense,_){


                        List<int> keys;
                        // keys =incomeExpense.keys.cast<int>().toList();
                        if(dropdownValue=="All"){
                          keys =incomeExpense.keys.cast<int>().toList();
                        }
                        else if(dropdownValue=="Today") {
                          keys = incomeExpense.keys.cast<int>().where((key) =>
                          incomeExpense.get(key)!.createdDate==todaysDateSelector()).toList();
                        }
                        else if(dropdownValue=="Yesterday"){
                          keys = incomeExpense.keys.cast<int>().where((key) =>
                          incomeExpense.get(key)!.createdDate==yesterdaysDateSelector()).toList();
                        }
                        else if(dropdownValue=="Monthly"){
                          keys = incomeExpense.keys.cast<int>().where((key) =>
                          incomeExpense.get(key)!.createdDate.month==monthlyDateSelector().month).toList();
                          selectedMonth =DateFormat('MMMM').format(monthlyDateSelector());
                          print("selectedMonth:----------$selectedMonth");

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
                          keys =range.toList();
                        }
                        else{
                          return Text("No Transactions");
                        }

                        // List<dynamic> incomeSum=[];
                        // incomeSum.add(incomeExpense.values.toList());
                        // print("incomeSum---$incomeSum");
                        // incomeSum = incomeExpense.keys.cast<int>().where((key) => incomeExpense.get(key)!.isIncome).toList();

                        //List<IncomeExpenseModel> dateOrder;
                        //dateOrder.sort((a,b){a.});
                        //keys = incomeExpense.keys.cast<int>().where((key) => incomeExpense.get(key)!.isIncome).toList();

                        //keys.sort();
                       // keys.reversed;
                       //  if(incomeCategoryButtonSelected==true){
                       //    keys = categories.keys.cast<int>().where((key) => categories.get(key)!.isIncome).toList();
                       //  }
                       //  else{
                       //    keys = categories.keys.cast<int>().where((key) => !categories.get(key)!.isIncome).toList();
                       //  }
                       //  keys =categories.keys.cast<int>().toList();
                        //List<int> days;
                        //days =incomeExpense.keys.cast<int>().where((element) => false);

                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: keys.length,
                          itemBuilder: (context,index){
                            //keys.sort()

                            //final List<int>keysReversed = keys.reversed.toList();
                             //List<DateTime> ?keysOfDate;
                            final int key  = keys[index];
                            final incomeExpenseValues= incomeExpense.get(key);
                            return listTileCard(
                              leading: DateFormat.MMMd().format(incomeExpenseValues!.createdDate),
                              trailing: "${incomeExpenseValues.amount}",
                              title: "${incomeExpenseValues.category}",
                              trailingTextColor:incomeExpenseValues.isIncome==true? Colors.green:Colors.red,
                              tileColor:
                              Colors.white,
                              onTap: (){
                                //Navigator.pushNamed(context, 'UpdateOrDeleteDetails');
                                showDialog(context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        actions: [
                                          Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: (){
                                                  incomeExpenseBox.delete(key);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Delete"),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                            );
                          }, separatorBuilder: (BuildContext context, int index)
                        {
                          return    Divider(
                            thickness: 2.5,
                            color: Color(0xffccccff),
                          );
                        },
                        );
                      },
                    ),

                    // itemBuilder: (context,_){
                    //   return listTileCard(
                    //     title: "Category",
                    //     trailing: "amount",
                    //     leading: "12-19-2020",
                    //     onTap: (){
                    //       Navigator.pushNamed(context, 'UpdateOrDeleteDetails');
                    //     },
                    //     trailingTextColor: Colors.red,
                    //     tileColor:
                    //     Colors.white,
                    //   );
                    // },
                    // separatorBuilder: (context,int index){
                    //   return Divider();
                    // },


          ),
        ],
      ),

    );
  }
}
