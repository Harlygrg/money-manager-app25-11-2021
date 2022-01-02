import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:money_manager_app/controls/transactions_controller.dart';
import 'package:money_manager_app/screens/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sizer/sizer.dart';

class Transactions extends StatelessWidget {
  final controller = Get.put(TransactionsController());

  Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        //backgroundColor: Color(0xfffff7e6),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            divider(height: 5),
            GetBuilder<TransactionsController>(builder: (dropdownRow) {
              controller.listenableBuilder();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  divider(width: MediaQuery.of(context).size.width / 300),
                  controller.dropdownValue == "Monthly"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 5, right: 5),
                              child: timePeriodeChageIcon(
                                  onPressed: controller
                                      .timePeriodChangeIconDecrementOnPressed,
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                            ),
                            divider(
                                width: MediaQuery.of(context).size.width / 30),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 5, right: 5),
                              child: timePeriodeChageIcon(
                                  onPressed: controller
                                      .timePeriodChangeIconIncrementOnPressed,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 25,
                                    color: Colors.white,
                                  )
                                  //arrow_back_ios
                                  ),
                            ),
                            divider(
                                width: MediaQuery.of(context).size.width / 5),
                          ],
                        )
                      : divider(width: 1),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 5,
                    ),
                    height: 40,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xff005c99),
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: DropdownButton(
                      underline: AutoSizeText(""),
                      style: TextStyle(
                        color: appbarBackgroundColor,
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                      focusColor: Colors.white,
                      hint: AutoSizeText("Select Category"),
                      items: controller.items.map((itemsname) {
                        return DropdownMenuItem(
                          value: itemsname,
                          child: Text(
                            itemsname,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: controller.dropdownMenuItemOnchanged,
                      value: controller.dropdownValue,
                    ),
                  ),
                  divider(height: 15),
                ],
              );
            }),
            GetBuilder<TransactionsController>(builder: (contrlr) {
              return Column(
                children: [
                  controller.dropdownValue == "Monthly"
                      ? Text(
                          controller.selectedMonth,
                          style: TextStyle(
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp),
                        )
                      : divider(),
                  controller.dropdownValue == "Select Range"
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: dateRangeShow(
                              initialDate: DateFormat('MMMMd')
                                  .format(controller.dateRange.start),
                              finalDate: DateFormat('MMMMd')
                                  .format(controller.dateRange.end),
                              onTap: () {
                                controller.pickDateRange(context);
                                controller.updateState();
                              }),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  divider(height: 5),
                  totalIncomeAndTotalExpenseShowingRow(
                      width: MediaQuery.of(context).size.width / 2.6,
                      totalIncomeText: "income\n",
                      totalIncome: controller.sumInc.toString(),
                      totalExpenseText: "expense\n",
                      totalExpense: controller.sumExp.toString()),
                  divider(height: 15),
                ],
              );
            }),
            if (controller.incomeExpenseBox.isNotEmpty)
              Expanded(child:
                  GetBuilder<TransactionsController>(builder: (gridcontroller) {
                controller.listenableBuilder();
                return controller.keys.length == 0
                    ? Center(
                        child: Text(
                        "No Trasactions saved",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w500),
                      ))
                    : GridView.count(
                        crossAxisCount: 2,
                        scrollDirection: Axis.vertical,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        childAspectRatio: (2 / 1.1),
                        children:
                            List.generate(controller.keys.length, (index) {
                          final int key = controller.keys[index];
                          final incomeExpenseValues =
                              controller.incomeExpenseBox.get(key);
                          return GestureDetector(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: appbarBackgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: appbarBackgroundColor,
                                        width: 3)),
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 5),
                                child: RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "${DateFormat.MMMd().format(incomeExpenseValues!.createdDate)}\n",
                                      style: TextStyle(
                                        fontFamily: "Outfit",
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            incomeExpenseValues.isIncome == true
                                                ? Color(0xffe6f7ff)
                                                : Colors.black87,
                                      )),
                                  TextSpan(
                                      text:
                                          "  ${incomeExpenseValues.category}\n",
                                      style: TextStyle(
                                        fontFamily: "Outfit",
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            incomeExpenseValues.isIncome == true
                                                ? Color(0xffe6f7ff)
                                                : Colors.black87,
                                      )),
                                  TextSpan(
                                      text: "  ${incomeExpenseValues.amount}",
                                      style: TextStyle(
                                        fontFamily: "Outfit",
                                        fontSize: 18.5.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            incomeExpenseValues.isIncome == true
                                                ? Color(0xffe6f7ff)
                                                : Colors.black87,
                                      ))
                                ]))),
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(incomeExpenseValues.category),
                                      content: Text(
                                          "${incomeExpenseValues.extraNotes}"),
                                      actions: [
                                        Text(
                                          DateFormat.MMMd().format(
                                              incomeExpenseValues.createdDate),
                                        ),
                                        Text(
                                          "${incomeExpenseValues.amount}",
                                          style: TextStyle(
                                            color:
                                                incomeExpenseValues.isIncome ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            onTap: () {
                              //Navigator.pushNamed(context, 'UpdateOrDeleteDetails');
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        GetBuilder<TransactionsController>(
                                            builder: (snackController) {
                                          return ListTile(
                                            title: Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onTap: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text('Are you sure?'),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                elevation: 6.0,
                                                action: SnackBarAction(
                                                    textColor:
                                                        appbarBackgroundColor,
                                                    label: "yes",
                                                    onPressed: () {
                                                      controller
                                                          .incomeExpenseBox
                                                          .delete(key);
                                                      controller.incomeSum();
                                                      controller.expenseSum();
                                                      controller.updateState();
                                                    }),
                                                backgroundColor: color2,
                                              ));
                                              Get.back();
                                            },
                                          );
                                        })
                                      ],
                                    );
                                  });
                            },
                          );
                        }),
                      );
              }))
            else
              Center(child: Text("No Transactions")),
          ],
        ),
      ),
    );
  }
}
