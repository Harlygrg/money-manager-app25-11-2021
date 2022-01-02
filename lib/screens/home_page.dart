import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:money_manager_app/controls/home_chart_settings_login_controller.dart';
import 'package:money_manager_app/screens/custom_widgets.dart';
import 'package:money_manager_app/screens/transactions_page.dart';
import 'package:money_manager_app/screens/overview_page.dart';
import 'package:money_manager_app/screens/categories_page.dart';
import 'package:money_manager_app/widgets/home_widgets.dart';

class HomePage extends StatelessWidget {
  final homeController = Get.find<HomeChartSettingsLoginController>();
  HomeWidget homeWidget = HomeWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xffe6f0ff),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff005c99),
        //Color(0xff0000ff),
        title: Text(
          "Money Manager",
          style: TextStyle(shadows: const [
            Shadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(3, 2.5),
            )
          ], fontFamily: "Outfit"),
        ),
        actions: [
          appBarRightSideIconButton(
            onPressed: () {
              Get.toNamed('pie_chart');
            },
            icon: Icon(
              Icons.pie_chart,
              color: Colors.white,
            ),
          ),
          appBarRightSideIconButton(
              onPressed: () {
                Get.toNamed('SettingsPage');
              },
              icon: Icon(
                Icons.settings,
              )),
        ],
        bottom: TabBar(
          controller: homeController.tabController,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              child: homeWidget.tabbarTxt(text: "Overview"),
            ),
            Tab(
              child: homeWidget.tabbarTxt(text: "Transactions"),
            ),
            Tab(
              child: homeWidget.tabbarTxt(text: "Categories"),
            ),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: homeController.tabController,
        children: [
          Overview(),
          Transactions(),
          Categories(),
        ],
      ),

      floatingActionButton: Material(
          type: MaterialType.transparency,
          //Makes it usable on any background color, thanks @IanSmith
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70, width: 4.0),
              color: appbarBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              //This keeps the splash effect within the circle
              borderRadius: BorderRadius.circular(1000.0),
              //Something large to ensure a circle
              onTap: () {
                Get.toNamed("AddIncomeOrExpense");
              },
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Icon(
                  Icons.add,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
