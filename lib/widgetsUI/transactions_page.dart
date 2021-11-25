
import 'package:flutter/cupertino.dart';
import 'package:money_manager_app/main.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/actions/data_model.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late Box<IncomeExpenseModel> incomeExpenseBox;
  static DateTime now = DateTime.now();
  static String newdate=  DateFormat('yyyy-MM-dd').format(now);
  DateTime todaysDate = DateTime.parse(newdate);
  final items = ["All","Today","Yesterday","Monthly","Custom","Select Range"];
  String dropdownValue ="All";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    incomeExpenseBox =Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      //backgroundColor: Color(0xfffff7e6),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          divider(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              divider(width: 2),
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    timePeriodeChageIcon(
                        onPressed: (){},
                        icon: Icon(Icons.arrow_back_ios)
                    ),
                    timePeriodeChageIcon(
                        onPressed: (){},
                        icon: Icon(Icons.arrow_forward_ios_rounded)
                        //arrow_back_ios
                    )
                  ],
                ),
              ),
              DropdownButton(
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
          totalIncomeAndTotalExpenseShowingRow(
              totalIncome: "21313",
              totalExpense: "14234"),

          Container(
            margin: EdgeInsets.only(left: 10),
            height: MediaQuery.of(context).size.height*.6,
            width: MediaQuery.of(context).size.width*.95,
                    child: ValueListenableBuilder(
                      valueListenable: incomeExpenseBox.listenable(),
                      builder: (context, Box<IncomeExpenseModel> incomeExpense,_){
                        List<int> keys;
                        // keys =incomeExpense.keys.cast<int>().toList();
                        if(dropdownValue=="All"){
                          keys =incomeExpense.keys.cast<int>().toList();
                        }
                        else {
                          keys = incomeExpense.keys.cast<int>().where((key) => incomeExpense.get(key)!.createdDate==todaysDate).toList();
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
          divider(height: 7),
          Row(
            children: [divider(width: 30),
              elevatedButton(
                  buttonName: "Time Period",
                  buttonBackground:  Color(0xff005c99),
                  onPressed: (){
                    showDialog(context: context,
                        builder: (context){
                          return AlertDialog(
                            actions: [
                              Column(
                                children: [
                                  TextButton(
                                    onPressed: (){},
                                    child: Text("Monthly"),
                                  ),
                                  TextButton(
                                    onPressed: (){},
                                    child: Text("Yearly"),
                                  ),
                                ],
                              )
                            ],


                          );
                        }
                    );
                  }
              ),
            ],
          ),
          divider(height: 10)

        ],
      ),

    );
  }
}
// ListView.builder(
//
// scrollDirection: Axis.vertical,
// shrinkWrap: true,
// itemCount: 20,
//
// itemBuilder: (context,position){
//
// }
// )