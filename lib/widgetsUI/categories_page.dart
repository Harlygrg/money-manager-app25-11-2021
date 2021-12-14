

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_app/main.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

DateTime currentDateTime = DateTime.now();
String formated = DateFormat.jm().format(currentDateTime);



class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool incomeCategoryButtonSelected = true;
  final formKey = GlobalKey<FormState>();
  final newCategoryController = TextEditingController();
  final updateCategoryController =TextEditingController();
  late Box<CategoryModel> categoryBox;
  bool categoriesButtonColorChecker =true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryBox = Hive.box<CategoryModel>(categoryBoxName);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        divider(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width*.65,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child:elevatedButton(
                    borderRadius: 0,
                    buttonName: "INCOME",
                    buttonBackground: categoriesButtonColorChecker?appbarBackgroundColor:Colors.white,
                    textColor: !categoriesButtonColorChecker?appbarBackgroundColor:Colors.white,
                    onPressed: (){
                      incomeCategoryButtonSelected = true;
                      //incomeTrue =true;
                      setState(() {

                        categoriesButtonColorChecker=true;
                      });
                    }
                ),
              ),
              Expanded(
                child: elevatedButton(
                    buttonName: "EXPENSE",
                    borderRadius: 0,
                    buttonBackground: !categoriesButtonColorChecker?appbarBackgroundColor:Colors.white,
                    textColor: categoriesButtonColorChecker?appbarBackgroundColor:Colors.white,
                    onPressed: (){
                      //incomeTrue =false;
                      incomeCategoryButtonSelected = false;
                      setState(() {
                        categoriesButtonColorChecker=false;
                      });
                    }
                ),
              ),
            ],
          ),
        ),
        divider(height: 15),
        Expanded(
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
              return keys.isNotEmpty?
                ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: keys.length,
                itemBuilder: (context,index){
                  final int key  = keys[index];
                  final categoryValues= categories.get(key);
                  return
                      Padding(
                        padding:const EdgeInsets.only(left: 25,right: 25),
                        child: Card(
                          elevation: 5,
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(left: 20,top: 10,bottom: 10),
                              height: 50,
                              decoration: BoxDecoration(
                                gradient:  LinearGradient(
                                    colors: index%2==0 ?
                                    [appbarBackgroundColor,color2]:[color2,appbarBackgroundColor,]
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(categoryValues!.category.toString(),
                              style: TextStyle(fontSize: 15.sp,fontFamily: "Outfit",
                                  fontWeight: FontWeight.w500,color: Colors.white)),
                            ),
                            onTap: (){
                              showDialog(context: context,
                                  builder: (context){
                                    return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            textButton(
                                              text: " Delete",
                                              onPressed: (){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content:Text('Do you want to delete'),
                                                      backgroundColor: appbarBackgroundColor,
                                                      action: SnackBarAction(
                                                        textColor: color2,
                                                          label:"yes",
                                                          onPressed: (){
                                                            categoryBox.delete(key);
                                                          }
                                                      ),
                                                    ));
                                                Navigator.pop(context);
                                                print("Item Deleted");
                                              },

                                            ),


                                          ],
                                        )
                                    );
                                  }
                              );
                            },
                          ),
                        ),
                      );
                }, separatorBuilder: (BuildContext context, int index)
              {
                return    divider();
              },
              ):Center(
                child: Text("Add new categories"),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff005c99),
              ),
              child: Text("+ Category"),
              onPressed: (){
                showDialog(context: context,
                    builder: (context){
                      return AlertDialog(
                          content: Container(
                            width: 100,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Form(
                                  key: formKey,
                                  child: TextFormField(
                                    autovalidateMode:AutovalidateMode.onUserInteraction ,

                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Please Enter Category';
                                      }
                                      else if(value.length>=15){
                                        return 'Please Enter less than 20 letters';
                                      }
                                      return null;
                                    },
                                    controller:newCategoryController ,
                                    decoration: InputDecoration(
                                      hintText: "Category Name",
                                    ),
                                  ),
                                ),
                                divider(height: 5),
                                elevatedButton(
                                    buttonName: "Save Category",
                                    buttonBackground: Color(0xff005c99),
                                    onPressed: (){
                                      final isValid = formKey.currentState!.validate();
                                      final String newCategory =newCategoryController.text;

                                      if(isValid){
                                        if(incomeCategoryButtonSelected==true){
                                          CategoryModel category = CategoryModel(
                                              category: newCategory,isIncome: true
                                          );
                                          categoryBox.add(category);
                                          print("Income category added-------------");
                                        }
                                        else{
                                          CategoryModel category = CategoryModel(
                                              category: newCategory,isIncome: false
                                          );
                                          categoryBox.add(category);
                                          print("Expense Category added-------------");
                                        }

                                        newCategoryController.clear();
                                        Navigator.pop(context);
                                      }

                                    })
                              ],
                            ),
                          )
                      );
                    }
                );

              }),
        ),
      ],
    );
  }
}


