import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:money_manager_app/controls/home_chart_settings_login_controller.dart';
import 'package:money_manager_app/screens/custom_widgets.dart';
import 'package:money_manager_app/widgets/pichart_widgets.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Piechart extends StatelessWidget {
  final chartController = Get.find<HomeChartSettingsLoginController>();
  PieChartWidgets _pieChartWidgets = PieChartWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Manager"),
        backgroundColor: Color(0xff005c99),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child:
            GetBuilder<HomeChartSettingsLoginController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              divider(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * .533,
                child: Row(children: [
                  elevatedButton(
                    borderRadius: 0,
                    buttonName: "INCOME",
                    buttonBackground: chartController.incomePichartSelect
                        ? appbarBackgroundColor
                        : Colors.white,
                    textColor: !chartController.incomePichartSelect
                        ? appbarBackgroundColor
                        : Colors.white,
                    onPressed: chartController.incomeButtonOnPressed,
                  ),
                  elevatedButton(
                    borderRadius: 0,
                    buttonName: "EXPENSE",
                    buttonBackground: !chartController.incomePichartSelect
                        ? appbarBackgroundColor
                        : Colors.white,
                    textColor: chartController.incomePichartSelect
                        ? appbarBackgroundColor
                        : Colors.white,
                    onPressed: chartController.expenseButtonOnPressed,
                  ),
                ]),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 40,
                      padding: const EdgeInsets.only(left: 10, right: 3),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xff005c99),
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: DropdownButton(
                        underline: Text(""),
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                        focusColor: Colors.white,
                        hint: Text("Select Category"),
                        items: chartController.items.map((itemsname) {
                          return DropdownMenuItem(
                            value: itemsname,
                            child: Text(itemsname,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: "Outfit",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500)),
                          );
                        }).toList(),
                        onChanged: chartController.dropdownButtonOnchanged,
                        value: chartController.dropdownValues,
                      ),
                    ),
                  ],
                ),
              ),
              chartController.dropdownValues == "Monthly"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        timePeriodeChageIcon(
                            onPressed:
                                chartController.timePeriodChangeIconIncrement,
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 25,
                            )),
                        timePeriodeChageIcon(
                            onPressed:
                                chartController.timePeriodChangeIconDecrement,
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 25,
                            )
                            //arrow_back_ios
                            ),
                        divider(width: MediaQuery.of(context).size.width * .25),
                        Text(
                          chartController.selectedMonth,
                          style: TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  : divider(height: 1),
              chartController.dropdownValues == "Select Range"
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: dateRangeShow(
                          initialDate: DateFormat('MMMMd')
                              .format(chartController.dateRange.start),
                          finalDate: DateFormat('MMMMd')
                              .format(chartController.dateRange.end),
                          onTap: () {
                            chartController.pickDateRange(context);
                          }),
                    )
                  : SizedBox(
                      height: 1,
                    ),
              divider(height: 37),
              (chartController.incomeCategories(isIncome: true).isNotEmpty &&
                          chartController.incomePichartSelect) ||
                      (chartController
                              .incomeCategories(isIncome: false)
                              .isNotEmpty &&
                          !chartController.incomePichartSelect)
                  ? Expanded(
                      child: ListView(
                      children: [
                        divider(height: 50),
                        _pieChartWidgets.piechart(
                          context: context,
                          piechartDatas: chartController
                                      .incomeCategories(isIncome: false)
                                      .isNotEmpty &&
                                  !chartController.incomePichartSelect
                              ? chartController.incomeCategories(
                                  isIncome: false)
                              : chartController.incomeCategories(
                                  isIncome: true),
                          colorList: chartController.colorList,
                        ),
                      ],
                    ))
                  : Text("No transcactions"),
              //Center(child: Text("No transactions yet")),
            ],
          );
        }),
      ),
    );
  }
}
