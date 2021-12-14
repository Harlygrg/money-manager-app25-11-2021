
//import 'dart:ui';
//adding_expense_income.dart-file name
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../main.dart';
import 'package:sizer/sizer.dart';
class AddIncomeOrExpense extends StatefulWidget {
  @override
  _AddIncomeOrExpenseState createState() => _AddIncomeOrExpenseState();
}

class _AddIncomeOrExpenseState extends State<AddIncomeOrExpense> {
  var _formKey = GlobalKey<FormState>();
  static DateTime nowq = DateTime.now();
  DateTime currentDate=DateTime(nowq.year,nowq.month,nowq.day);
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
  String _date = DateFormat.yMMMEd().format(nowq);
  String dropdownValue="apple";
  late Box<IncomeExpenseModel> incomeAndExpenseBox;


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
     // backgroundColor: Color(0xffe6f0ff),
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
                  AutoSizeText(
                    "Income",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(width:  135,
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
                  AutoSizeText(
                    "Expense ",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500
                    ),),
                ],
              ),
            ),

          ],),

          divider(height: 5),
          //-------------------------------------------------------------------------------------------------------------
          ListTile(
            onTap: ()async{
               currentDate =(await showDatePicker(
                  context: context,
                  initialDate:DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
                  firstDate: DateTime(2010,12,31),
                  lastDate:DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day), ))!;
               setState(() {
                 _date = DateFormat.yMMMEd().format(currentDate);
               });

               print("current date ==$currentDate");
            },
            title: Text(
             " $_date",
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 12.sp,
                  color: Color(0xff005c99)),
            ),
            trailing: Icon(
              Icons.date_range,
              size: 25.0,
              color: Color(0xff005c99),
            ),
          ),

          TextButton(
            child:SizedBox(
              width: MediaQuery.of(context).size.width*.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //divider(width: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(selectedCategory,style: TextStyle(fontSize: 12.5.sp,fontFamily: "Roboto",
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
                          ValueListenableBuilder(
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
                              return keys.isNotEmpty?
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*.50,
                                  width:MediaQuery.of(context).size.width*.90,
                                  child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                               // physics: NeverScrollableScrollPhysics(),
                                  itemCount: keys.length,
                                  itemBuilder: (context,index){
                                    final int key  = keys[index];
                                    final categoryValues= categories.get(key);
                                    return GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0,top: 5),
                                          child: Text(categoryValues!.category.toString(),
                                            style: TextStyle(
                                                fontSize: 12.5.sp,fontFamily: "Roboto",fontWeight: FontWeight.w500
                                            ),),
                                        ),
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

                                  }, separatorBuilder:
                                    (BuildContext context, int index)
                              {
                                  return Divider(thickness: 2,color: appbarBackgroundColor,);
                                  //SizedBox(height: 5,);
                              },
                              ),
                                ):
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text("Please add Categories"),
                                ),
                              );
                            },
                          )
                              //: divider(height: 1),
                        ],
                      );
                    }
                );
              });
            },

          ),

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
                    else if(value.length>10){
                      return 'Pleas enter amount less than 1000000000';
                    }
                    return null;
                  },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Amount",
                      ),
                    ),
                    divider(height: 15),
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
 Center(
            child: elevatedButton(
                buttonName: '  SAVE  ',
                buttonBackground:  Color(0xff005c99),
                onPressed: (){
                  final double newAmount = double.parse(amountController.text);
                  final String newExtraNotes = extranotesController.text;
                  final DateTime newDate    = currentDate;
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
                        Navigator.
                        pushNamed(context, 'HomePage').then((value) {
                          setState(() {

                          });
                        }
                        );
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
                        Navigator.
                        pushNamed(context, 'HomePage').then((value) {
                          setState(() {

                          });
                        });
                      }
                    }

                  }
                  else if(categoryChoosed==false){
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
          divider(height: 50),
          Center(
            child: OutlinedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.white
              ),
              child: Text("back",style:
              TextStyle(color: appbarBackgroundColor,fontSize: 18,fontFamily: "Outfit"),),
            ),
          )
        ],
      ),
    );
  }
}