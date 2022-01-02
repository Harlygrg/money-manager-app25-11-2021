import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_manager_app/controls/home_chart_settings_login_controller.dart';
import 'package:money_manager_app/main.dart';
import 'package:money_manager_app/screens/custom_widgets.dart';
import 'package:money_manager_app/screens/custom_textfields.dart';
import 'package:money_manager_app/model/data_model.dart';
import 'package:money_manager_app/widgets/login_widgets.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatelessWidget {
  LoginWidgets _loginWidgets = LoginWidgets();

  @override
  Widget build(BuildContext context) {
    final loginControll =
        Get.put(HomeChartSettingsLoginController(cont: context));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfffff7e6),
        // appBar: AppBar(
        //   backgroundColor:  appbarBackgroundColor,
        //   title:Center(
        //     child: appTitle(),
        //   ) ,
        // ),

        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .15,
          ),
          //loginTexts(text: "Enter your pin"),

          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            margin: EdgeInsets.only(left: 45, top: 5),
            child: appBarTexts(
              text: "Welcome to Money Manager",
              fontSize: 28.sp,
              textColor: Color(0xff0080ff),
            ),
            //popupTextField(inputValue: pinController),
          ),
          // Row(mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     GestureDetector(onTap: (){
          //       showDialog(context: context,
          //           builder: (context){
          //         return AlertDialog(
          //                 content: Column(mainAxisSize: MainAxisSize.min,
          //                                 crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     loginTexts(
          //                         text: "Name of your favourite book?",
          //                         leftPadding: 0,
          //                         textColor: Colors.black),
          //                     popupTextField(inputValue: forgotpinRecovary),
          //                     loginButton(onClicked: (){}, buttonName: "Proceed"),
          //                   ],
          //                 ),
          //         );
          //           });
          //     },
          //         child: loginTexts(text: "Forgot pin")
          //     ),
          //     SizedBox(width: MediaQuery.of(context).size.width*.295,),
          //     newUserLogin(userStatus: "New user"),
          //   ],
          // ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              width: 250,
              height: MediaQuery.of(context).size.height * .30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(125),
                  image: DecorationImage(
                    image: AssetImage(
                        'ImageAssets/undraw_make_it_rain_iwk4-removebg-preview.png'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          _loginWidgets.loginTexts(
              text: "Balancing your money is the key to having enough."),
          divider(height: 20),
          Center(
            child: elevatedButton(
                buttonName: "Proceed",
                buttonBackground: Color(0xff005c99),
                onPressed: () {
                  for (int i = 0;
                      i < loginControll.initialCatList.length;
                      i++) {
                    if (i < 6) {
                      CategoryModel catModel = CategoryModel(
                          isIncome: false,
                          category: loginControll.initialCatList[i]);
                      loginControll.categoryBox.add(catModel);
                    } else {
                      CategoryModel catModel = CategoryModel(
                          isIncome: true,
                          category: loginControll.initialCatList[i]);
                      loginControll.categoryBox.add(catModel);
                    }
                  }
                  loginControll.loginPageData = true;
                  loginControll.saveDataToStorage();
                  Navigator.pushReplacementNamed(context, "HomePage");
                }),
          )
        ]));
  }
}
