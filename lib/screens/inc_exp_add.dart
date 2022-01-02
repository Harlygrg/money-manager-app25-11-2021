//import 'dart:ui';
//adding_expense_income.dart-file name
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:money_manager_app/controls/inc_exp_add_controller.dart';
import 'package:sizer/sizer.dart';
import 'custom_widgets.dart';

class AddIncomeOrExpense extends StatelessWidget {
  final controller = Get.put(IncExpAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffe6f0ff),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Money Manager"),
        backgroundColor: Color(0xff005c99),
        actions: [],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          divider(height: 20),
          GetBuilder<IncExpAddController>(builder: (controller2) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: controller.buttonGroupvalue,
                        onChanged: controller.radioButtonOnChanged,
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
                SizedBox(
                  width: 135,
                  child: Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: controller.buttonGroupvalue,
                        onChanged: controller.radioButtonSecondOnChanged,
                      ),
                      AutoSizeText(
                        "Expense ",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          divider(height: 5),
          //-------------------------------------------------------------------------------------------------------------
          ListTile(
            onTap: () async {
              controller.currentDate = (await showDatePicker(
                context: context,
                initialDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                firstDate: DateTime(2010, 12, 31),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
              ))!;
              controller.date =
                  DateFormat.yMMMEd().format(controller.currentDate);
              controller.update();

              print("current date ==${controller.currentDate}");
            },
            title: Text(
              " ${controller.date}",
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

          GetBuilder<IncExpAddController>(builder: (controller3) {
            controller.listenableBuilderValues();
            return TextButton(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //divider(width: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        controller.selectedCategory,
                        style: TextStyle(
                            fontSize: 12.5.sp,
                            fontFamily: "Roboto",
                            color: Color(0xff005c99)),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down,
                        size: 40, color: Color(0xff005c99)),
                  ],
                ),
              ),
              onPressed: () {
                controller.catagorySelector = true;
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          controller.keys.isNotEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .50,
                                  width:
                                      MediaQuery.of(context).size.width * .90,
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.keys.length,
                                    itemBuilder: (context, index) {
                                      final int key = controller.keys[index];
                                      final categoryValues =
                                          controller.categoryBox.get(key);
                                      return GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 5),
                                            child: Text(
                                              categoryValues!.category
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12.5.sp,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          onTap: () {
                                            controller
                                                .categorySelectingOnTap(key);
                                          });
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider(
                                        thickness: 2,
                                        color: appbarBackgroundColor,
                                      );
                                      //SizedBox(height: 5,);
                                    },
                                  ),
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text("Please add Categories"),
                                  ),
                                )
                          //: divider(height: 1),
                        ],
                      );
                    });
                controller.update();
              },
            );
          }),

          Form(
              key: controller.formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: controller.amountController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Amount';
                        } else if (value.length > 10) {
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
                      controller: controller.extranotesController,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Extra notes",
                      ),
                    ),
                  ],
                ),
              )),
          divider(height: 20),
          Center(
            child: elevatedButton(
                buttonName: '  SAVE  ',
                buttonBackground: Color(0xff005c99),
                onPressed: () {
                  controller.saveButtonPressed(context);
                }),
          ),
          divider(height: 50),
          Center(
            child: OutlinedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.white),
              child: Text(
                "back",
                style: TextStyle(
                    color: appbarBackgroundColor,
                    fontSize: 18,
                    fontFamily: "Outfit"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
