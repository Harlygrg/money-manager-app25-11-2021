

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_app/main.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/widgetsUI/textfields.dart';


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
    return Container(
      height: double.infinity,
      width: double.infinity,

      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          divider(height: 10),
          SizedBox(width: 188,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                elevatedButton(
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
                elevatedButton(
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
              ],
            ),
          ),
          Container(height: MediaQuery.of(context).size.height*.55,
            width:MediaQuery.of(context).size.width*.85,
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
                return
                  ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: keys.length,
                  itemBuilder: (context,index){
                    final int key  = keys[index];
                    final categoryValues= categories.get(key);
                    return listTileCard(
                        leading:categoryValues!.category.toString(),
                        trailingTextColor: Colors.black,
                        tileColor: color2,
                        elevation: 5,
                        leadingFontSize: 20,


                        onTap: (){
                          showDialog(context: context,
                              builder: (context){
                                return AlertDialog(
                                    content: Container(
                                      width: 70,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // textButton(
                                          //   text: "Edit",
                                          //   onPressed: (){
                                          //     Navigator.pop(context);
                                          //     showDialog(context: context,
                                          //         builder: (context){
                                          //           return AlertDialog(
                                          //               content: Container(
                                          //                 width: 100,
                                          //                 child: Column(
                                          //                   mainAxisSize: MainAxisSize.min,
                                          //                   children: [
                                          //                     TextFormField(
                                          //                       initialValue: categoryValues.category.toString(),
                                          //                       controller:updateCategoryController,
                                          //                       key: formKey,
                                          //                       decoration: InputDecoration(
                                          //                           hintText: "Category Name",
                                          //                       ),
                                          //                     ),
                                          //                     divider(height: 5),
                                          //                     elevatedButton(
                                          //                         buttonBackground: Color(0xff005c99),
                                          //                         buttonName: "Update Category",
                                          //                         onPressed: (){
                                          //                           //categories.put(widget.key,);
                                          //                           print("========================UPdated");
                                          //                           Navigator.pop(context);
                                          //                         })
                                          //                   ],
                                          //                 ),
                                          //               )
                                          //           );
                                          //         }
                                          //     );
                                          //   },
                                          //
                                          // ),
                                          textButton(
                                            text: " Delete",
                                            onPressed: (){
                                              categoryBox.delete(key);
                                              Navigator.pop(context);
                                              print("Item Deleted");
                                            },

                                          ),


                                        ],
                                      ),
                                    )
                                );
                              }
                          );
                        }
                    );
                  }, separatorBuilder: (BuildContext context, int index)
                {
                  return    divider();
                },
                );
              },
            ),
          ),
          ElevatedButton(
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

                                      // if(isValid!=null){
                                      //  final isValidCheck = isValid.validate();
                                      //  if(isValidCheck){
                                      //    CategoryModel category = CategoryModel(
                                      //        incomeCategory: newCategory
                                      //    );
                                      //    moneyDataBox.add(category);
                                      //    print("Money added-------------");
                                      //    Navigator.pop(context);
                                      //  }
                                      // }

                                    })
                              ],
                            ),
                          )
                      );
                    }
                );

              }),
        ],
      ),

    );
  }
}


