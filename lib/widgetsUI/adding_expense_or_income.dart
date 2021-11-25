
//import 'dart:ui';
//adding_expense_income.dart-file name
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../main.dart';
class AddIncomeOrExpense extends StatefulWidget {
  @override
  _AddIncomeOrExpenseState createState() => _AddIncomeOrExpenseState();
}

class _AddIncomeOrExpenseState extends State<AddIncomeOrExpense> {
  var _formKey = GlobalKey<FormState>();
  static DateTime nowq = DateTime.now();
  static String newdate=  DateFormat('yyyy-MM-dd').format(nowq);
  var currentDate=newdate;
  String categoryValue ="";
  String selectedCategory ="Select Category";
  final amountController = TextEditingController();
  final extranotesController = TextEditingController();
  bool incomeCategoryButtonSelected = true;
  bool categoriesButtonColorChecker =true;
  bool categoryChoosed              =false;
  bool catagorySelector = false;
  late Box<IncomeExpenseModel> incomeExpenseBox;
  late Box<CategoryModel> categoryBox;
  int _buttonGroupvalue=1;
  int ? _selectedIndex;
  String _date = DateFormat.yMMMEd().format(nowq);
  //final items = ["apple","banana","orange","mange"];
  String dropdownValue="apple";
  late Box<IncomeExpenseModel> incomeAndExpenseBox;
  // _onSelected(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    incomeAndExpenseBox = Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
    categoryBox = Hive.box<CategoryModel>(categoryBoxName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Money Manager"),
        backgroundColor: Color(0xff005c99),
        actions: [

        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          divider(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            SizedBox(width: 120,
              child: Row(
                children: [
                  Radio(
                      value: 1,
                      groupValue: _buttonGroupvalue,
                      onChanged: (value){
                        incomeCategoryButtonSelected = true;
                        setState(() {
                          _buttonGroupvalue= 1;
                          catagorySelector =false;
                          categoriesButtonColorChecker=true;
                        });
                      }
                  ),
                  Text(
                    "Income",
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: "ArchitectsDaughter",
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(width:  130,
              child: Row(
                children: [
                  Radio(
                      value: 2,
                      groupValue: _buttonGroupvalue,
                      onChanged: (value){
                        incomeCategoryButtonSelected = false;
                        setState(() {
                          _buttonGroupvalue=2;
                          categoriesButtonColorChecker=false;
                          catagorySelector =false;
                        });
                      }
                  ),
                  Text(
                    "Expense ",
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: "ArchitectsDaughter",
                        fontWeight: FontWeight.bold
                    ),),
                ],
              ),
            ),

          ],),

          divider(height: 5),
          ListTile(
            onTap: (){
              DatePicker.showDatePicker(
                    context,
                  theme: DatePickerTheme(
                    containerHeight: 210,
                  ),showTitleActions: true,
                  minTime: DateTime(2010,12,31),
                  maxTime: DateTime.now(),
                  onConfirm: (date){
                    print("confirm $date");
                    currentDate ="${date.year}-${date.month}-${date.day}";
                    _date = DateFormat.yMMMEd().format(date);
                    setState(() {
                    });

                  },
                  //currentTime: DateTime.now(), locale: LocaleType.en
              );
            },
            title: Text(
             " $_date",
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 17,
                  color: Color(0xff005c99)),
            ),
            trailing: Icon(
              Icons.date_range,
              size: 25.0,
              color: Color(0xff005c99),
            ),
          ),

          TextButton(
            child:Container(
              width: MediaQuery.of(context).size.width*.95,
              //padding: EdgeInsets.only(left: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //divider(width: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(selectedCategory,style: TextStyle(fontSize: 17,fontFamily: "Roboto",
                        color: Color(0xff005c99)),),
                  ),
                  Icon(Icons.arrow_drop_down,size: 40,color: Color(0xff005c99)),
                ],
              ),
            ),
            onPressed: (){
              setState(() {
                catagorySelector =true;
                showDialog(context: context,
                    builder: (context){
                      return AlertDialog(
                        actions: [
                          Container(
                            height: MediaQuery.of(context).size.height*.80,
                            width:MediaQuery.of(context).size.width*.90,
                            padding: EdgeInsets.all(10),
                            child: ValueListenableBuilder(
                              valueListenable: categoryBox.listenable(),
                              builder: (context, Box<CategoryModel> categories,_){
                                List<int> keys;
                                if(incomeCategoryButtonSelected==true){
                                  keys = categories.keys.cast<int>().where((key) => categories.get(key)!.isIncome).toList();
                                }
                                else{
                                  keys = categories.keys.cast<int>().where((key) => !categories.get(key)!.isIncome).toList();
                                }
                                //keys =categories.keys.cast<int>().toList();
                                return ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: keys.length,
                                  itemBuilder: (context,index){
                                    final int key  = keys[index];
                                    final categoryValues= categories.get(key);
                                    return GestureDetector(
                                        child: Text(categoryValues!.category.toString(),
                                          style: TextStyle(
                                              fontSize: 17,fontFamily: "Roboto",fontWeight: FontWeight.w200
                                          ),),
                                        onTap: (){
                                          categoryValue =categoryBox.get(key)!.category!;
                                          setState(() {
                                            selectedCategory =categoryValue;
                                            catagorySelector =false;
                                            categoryChoosed  =true;
                                          });
                                          // _onSelected(index);
                                          Navigator.pop(context);
                                        }
                                    );
                                    //   ListTile(
                                    //     title: Text(categoryValues!.category.toString(),
                                    //       style: TextStyle(
                                    //           fontSize: 15,fontFamily: "Roboto"
                                    //       ),),
                                    //     onTap: (){
                                    //       categoryValue =categoryBox.get(key)!.category!;
                                    //       setState(() {
                                    //         selectedCategory =categoryValue;
                                    //         catagorySelector =false;
                                    //         categoryChoosed  =true;
                                    //       });
                                    //       // _onSelected(index);
                                    //
                                    //     }
                                    // );

                                  }, separatorBuilder:
                                    (BuildContext context, int index)
                                {
                                  return Divider(thickness: 2,color: Colors.blue[200],);
                                  //SizedBox(height: 5,);
                                },
                                );
                              },
                            ),
                          )
                              //: divider(height: 1),
                        ],
                      );
                    }
                );
              });
            },

          ),

          // catagorySelector==true?
          // Container(height: MediaQuery.of(context).size.height*.20,
          //   width:MediaQuery.of(context).size.width*.95,
          //   padding: EdgeInsets.only(left: 10),
          //   child: ValueListenableBuilder(
          //     valueListenable: categoryBox.listenable(),
          //     builder: (context, Box<CategoryModel> categories,_){
          //       List<int> keys;
          //       if(incomeCategoryButtonSelected==true){
          //         keys = categories.keys.cast<int>().where((key) => categories.get(key)!.isIncome).toList();
          //       }
          //       else{
          //         keys = categories.keys.cast<int>().where((key) => !categories.get(key)!.isIncome).toList();
          //       }
          //       //keys =categories.keys.cast<int>().toList();
          //       return ListView.separated(
          //         scrollDirection: Axis.vertical,
          //         shrinkWrap: true,
          //         itemCount: keys.length,
          //         itemBuilder: (context,index){
          //           final int key  = keys[index];
          //           final categoryValues= categories.get(key);
          //           return GestureDetector(
          //               child: Center(
          //                 child: Text(categoryValues!.category.toString(),
          //                   style: TextStyle(
          //                       fontSize: 17,fontFamily: "Roboto",fontWeight: FontWeight.w200
          //                   ),),
          //               ),
          //               onTap: (){
          //                 categoryValue =categoryBox.get(key)!.category!;
          //                 setState(() {
          //                   selectedCategory =categoryValue;
          //                   catagorySelector =false;
          //                   categoryChoosed  =true;
          //                 });
          //                 // _onSelected(index);
          //
          //               }
          //           );
          //           //   ListTile(
          //           //     title: Text(categoryValues!.category.toString(),
          //           //       style: TextStyle(
          //           //           fontSize: 15,fontFamily: "Roboto"
          //           //       ),),
          //           //     onTap: (){
          //           //       categoryValue =categoryBox.get(key)!.category!;
          //           //       setState(() {
          //           //         selectedCategory =categoryValue;
          //           //         catagorySelector =false;
          //           //         categoryChoosed  =true;
          //           //       });
          //           //       // _onSelected(index);
          //           //
          //           //     }
          //           // );
          //
          //         }, separatorBuilder:
          //           (BuildContext context, int index)
          //       {
          //         return Divider(thickness: 2,color: Colors.blue[200],);
          //           //SizedBox(height: 5,);
          //       },
          //       );
          //     },
          //   ),
          // )
          //     : divider(height: 1),
          Form(key:_formKey ,
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: amountController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please Enter Amount';
                    }
                    return null;
                  },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Amount",
                      ),
                    ),
                    divider(height: 15),


                    // DropdownButton(
                    //   items: items.map((itemsname) {
                    //     return DropdownMenuItem(
                    //       value: itemsname,
                    //       child: Text(itemsname),
                    //     );
                    //   }).toList(),
                    //   onChanged:(String ?newValue){
                    //     setState(() {
                    //       dropdownValue =newValue!;
                    //     });
                    //   },
                    //   value: dropdownValue,
                    // ),
                    // divider(height: 15),
                    TextFormField(
                      controller: extranotesController,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Extra notes",
                      ),
                    ),
                  ],
                ),
              )
          ),
          divider(height: 20 ),

//-------------------------------------------------------------------------------------------------------------------------------------------


          Center(
            child: elevatedButton(
                buttonName: '  SAVE  ',
                buttonBackground:  Color(0xff005c99),
                onPressed: (){
                  final double newAmount = double.parse(amountController.text);
                  final String newExtraNotes = extranotesController.text;
                  final DateTime newDate     = DateTime.parse(currentDate);
                  final isValid = _formKey.currentState!.validate();

                  if(isValid){
                    if(categoryChoosed==false){
                      showDialog(context: context,
                          builder: (context){
                            return AlertDialog(
                              content: Text("Please choose category"),
                            );
                          }
                      );
                    }
                    else {
                      if (incomeCategoryButtonSelected == true) {
                        IncomeExpenseModel income = IncomeExpenseModel(
                            isIncome: true,
                            createdDate: newDate,
                            amount: newAmount,
                            extraNotes: newExtraNotes,
                            category: categoryValue
                        );
                        incomeAndExpenseBox.add(income);
                        print("income added");
                        print("-!-${income.category},${income.amount}, ${income
                            .createdDate},${income.extraNotes}-!-");
                        amountController.clear();
                        extranotesController.clear();
                        categoryValue = "";
                        Navigator.pop(context);
                      }
                      else {
                        IncomeExpenseModel expense = IncomeExpenseModel(
                            isIncome: false,
                            createdDate: newDate,
                            amount: newAmount,
                            extraNotes: newExtraNotes,
                            category: categoryValue
                        );
                        incomeAndExpenseBox.add(expense);
                        print("-----expense added------");
                        print("-!-${expense.category},${expense.amount}, ${expense
                            .createdDate}-!-");
                        amountController.clear();
                        extranotesController.clear();
                        categoryValue = "";
                        Navigator.pop(context);
                      }
                    }

                  }
                  else if(!isValid){
                    return showDialog(context: context,
                        builder: (context){
                          return AlertDialog(
                            content: Text("Please choose category"),
                          );
                        }
                    );
                  }

                  }
                ),
          ),
        ],
      ),
    );
  }
}
