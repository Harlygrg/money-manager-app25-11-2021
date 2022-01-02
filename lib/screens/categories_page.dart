import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:money_manager_app/controls/category_controller.dart';
import 'package:money_manager_app/model/data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_app/screens/custom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

DateTime currentDateTime = DateTime.now();
String formated = DateFormat.jm().format(currentDateTime);

//Categories
class Categories extends StatelessWidget {
  final catController = Get.put(Categorycontroller());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        divider(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * .65,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetBuilder<Categorycontroller>(builder: (controller) {
                return Expanded(
                  child: elevatedButton(
                    borderRadius: 0,
                    buttonName: "INCOME",
                    buttonBackground: catController.categoriesButtonColorChecker
                        ? appbarBackgroundColor
                        : Colors.white,
                    textColor: !catController.categoriesButtonColorChecker
                        ? appbarBackgroundColor
                        : Colors.white,
                    onPressed: catController.incomeButtonOnPressed,
                  ),
                );
              }),
              GetBuilder<Categorycontroller>(builder: (controller) {
                return Expanded(
                  child: elevatedButton(
                    buttonName: "EXPENSE",
                    borderRadius: 0,
                    buttonBackground:
                        !catController.categoriesButtonColorChecker
                            ? appbarBackgroundColor
                            : Colors.white,
                    textColor: catController.categoriesButtonColorChecker
                        ? appbarBackgroundColor
                        : Colors.white,
                    onPressed: catController.expenseButtonOnPressed,
                  ),
                );
              }),
            ],
          ),
        ),
        divider(height: 15),
        Expanded(
            child: catController.listViewCondition().isNotEmpty
                ? GetBuilder<Categorycontroller>(builder: (controller) {
                    catController.listViewCondition();

                    return ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: catController.listViewCondition().length,
                      itemBuilder: (context, index) {
                        catController.listViewCondition();
                        final int key =
                            catController.listViewCondition()[index];
                        final categoryValues = catController.categoryBox
                            .get(catController.listViewCondition()[index])!
                            .category;
                        return Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Card(
                            elevation: 5,
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, top: 10, bottom: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: index % 2 == 0
                                          ? [appbarBackgroundColor, color2]
                                          : [
                                              color2,
                                              appbarBackgroundColor,
                                            ]),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(categoryValues!.toString(),
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          textButton(
                                            text: " Delete",
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Do you want to delete'),
                                                backgroundColor:
                                                    appbarBackgroundColor,
                                                action: SnackBarAction(
                                                    textColor: color2,
                                                    label: "yes",
                                                    onPressed: () {
                                                      catController.categoryBox
                                                          .delete(catController
                                                                  .listViewCondition()[
                                                              index]);
                                                      catController
                                                          .updateState();
                                                    }),
                                              ));
                                              Navigator.pop(context);
                                              //Get.back();
                                              print("Item Deleted");
                                            },
                                          ),
                                        ],
                                      ));
                                    });
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return divider();
                      },
                    );
                  })
                : Center(
                    child: Text("Add new categories"),
                  )),
        Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff005c99),
              ),
              child: Text("+ Category"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: Container(
                        width: 100,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: catController.formKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Category';
                                  } else if (value.length >= 15) {
                                    return 'Please Enter less than 20 letters';
                                  }
                                  return null;
                                },
                                controller: catController.newCategoryController,
                                decoration: InputDecoration(
                                  hintText: "Category Name",
                                ),
                              ),
                            ),
                            divider(height: 5),
                            elevatedButton(
                              buttonName: "Save Category",
                              buttonBackground: Color(0xff005c99),
                              onPressed: catController.incomeExpenseAddition,
                            )
                          ],
                        ),
                      ));
                    });
              }),
        ),
      ],
    );
  }
}
