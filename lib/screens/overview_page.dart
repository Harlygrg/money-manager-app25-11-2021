import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:money_manager_app/controls/overview_controller.dart';
import 'package:money_manager_app/screens/custom_widgets.dart';
import 'package:sizer/sizer.dart';

class Overview extends StatelessWidget {
  var viewCntrlr = Get.put(OverviewController());

  Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          divider(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                // height: MediaQuery.of(context).size.height*.185,
                padding: EdgeInsets.all(8),
                //margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                    //color: Color(0xff00bfff),
                    gradient:
                        LinearGradient(colors: [appbarBackgroundColor, color2]),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewCntrlr.monthYear,
                      style: TextStyle(
                          fontFamily: "Outfit",
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                    divider(height: 5),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Balance: ',
                                style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '${viewCntrlr.balance()}',
                                style: TextStyle(
                                    fontSize: 19.5.sp,
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    divider(height: 10), //before
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        viewCntrlr.widgets.incomeExpenseContainer(
                            context: context,
                            text1: " Earned\n",
                            text2:
                                "   ${viewCntrlr.totalAmouns(isIncome: true)}"),
                        viewCntrlr.widgets.incomeExpenseContainer(
                            context: context,
                            text1: "Spent\n ",
                            text2:
                                " ${viewCntrlr.totalAmouns(isIncome: false)}     ")
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "income",
                  style: TextStyle(
                      fontFamily: "Outfit",
                      color: appbarBackgroundColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "expense",
                  style: TextStyle(
                      fontFamily: "Outfit",
                      color: color2,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          divider(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              child: LinearProgressIndicator(
                backgroundColor: color2,
                valueColor: AlwaysStoppedAnimation(appbarBackgroundColor),
                minHeight: 8,
                value: viewCntrlr.progresIndicatorVal(),
              ),
            ),
          ),
//--------------------------------------------------------------------------------------------------------------------
          divider(height: 20),
          Expanded(
            child: GetBuilder<OverviewController>(builder: (controller) {
              viewCntrlr.listvalues();
              return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.allCategories.length,
                itemBuilder: (
                  context,
                  position,
                ) {
                  String category = controller.allCategories[position];
                  double amount = controller.allAmounts[position];

                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: controller.widgets
                          .totalIncomeAndExpenseBalanceTile(
                              titleText: category,
                              fontWeight: FontWeight.w500,
                              amount: amount.toString(),
                              trailingTextColor:
                                  position < controller.incCategories.length
                                      ? appbarBackgroundColor
                                      : color2,
                              fontFamily: "Outfit"));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox();
                  // Divider(color: color2,
                  // thickness: 1,);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
