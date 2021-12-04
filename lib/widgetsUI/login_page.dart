

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_manager_app/main.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/widgetsUI/custom_textfields.dart';
import 'package:money_manager_app/widgetsUI/home_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int loginPageData =0;
  final pinController =TextEditingController();
  final forgotpinRecovary =TextEditingController();
  final newPinController =TextEditingController();
  final newPinController2 =TextEditingController();

  Widget newUserLogin({
    required String userStatus
  }){
    return GestureDetector(
      onTap: (){
        showDialog(context: context,
            builder: (context){
              return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      loginTexts(text: "Enter pin",leftPadding: 0,textColor: Colors.black),
                      popupTextField(inputValue: newPinController),
                      loginTexts(text: "Confirm",leftPadding: 0,textColor: Colors.black),
                      popupTextField(inputValue: newPinController2),
                      Padding(
                        padding: const EdgeInsets.only(left: 150),
                        child: loginButton(onClicked: (){}, buttonName: "Save"),
                      ),
                    ],
                  )
              );
            });

      },
      child: loginTexts(text: "New user",leftPadding: 45),
    );
  }

  Widget loginButton({
    required Function() onClicked,
    required String buttonName
  }){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff1e88e5), // background
        onPrimary: Colors.white, // foreground
      ),
      onPressed: onClicked,
      child: Text(buttonName),
    );
  }

  Widget loginTexts({
    required String text,
    double fontSize = 15,
    Color textColor = Colors.blue,
    FontWeight fontWeight= FontWeight.normal,
    double leftPadding=45,
  }){
    return Padding(
      padding:  EdgeInsets.only(left: leftPadding,top: 10),
      child: Text(text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
        ),

      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getSavedData(context));
  }

  @override


  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfffff7e6),
        // appBar: AppBar(
        //   backgroundColor:  appbarBackgroundColor,
        //   title:Center(
        //     child: appTitle(),
        //   ) ,
        // ),

        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 110,),
              //loginTexts(text: "Enter your pin"),

              Container(
                width: MediaQuery.of(context).size.width*0.75,
                margin: EdgeInsets.only(left: 45,top: 5),
                child:
                appBarTexts(
                    text: "Welcome to Money Manager",
                    fontSize: 35,
                    textColor: Color(0xff0080ff)),
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
              SizedBox(height: 25,),
              Center(
                child: Container(
                  width: 250,height: 250,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(125),
                      image: DecorationImage(
                        image: AssetImage('ImageAssets/undraw_make_it_rain_iwk4-removebg-preview.png'),
                        fit: BoxFit.fill,
                      )
                  ),
                ),
              ),
              SizedBox(height: 25,),
              loginTexts(text: "Balancing your money is the key to having enough."),
              divider(height: 20),
              Center(
                child: elevatedButton(
                    buttonName: "Proceed",
                    buttonBackground:  Color(0xff005c99),
                    onPressed: (){
                      loginPageData = 15;
                      saveDataToStorage();
                      Navigator.pushNamed(context, "HomePage");
                    }),
              )

            ])
    );
  }
  Future<void> saveDataToStorage()async{
    print(loginPageData);
   await sharedPreferences.setInt('login_data', loginPageData);
  }
}
Future<void>getSavedData(BuildContext context)async{
  final savedValue =  sharedPreferences.getInt("login_data");
  if(savedValue!=0){
    Navigator.pushReplacementNamed(context, "HomePage");
  }
}