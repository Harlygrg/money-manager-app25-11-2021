import 'package:flutter/material.dart';
import 'package:money_manager_app/screens/custom_textfields.dart';

class LoginWidgets {
  Widget newUserLogin({
    required String userStatus,
    required context,
    required TextEditingController newPinController,
    required TextEditingController newPinController2,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loginTexts(
                      text: "Enter pin",
                      leftPadding: 0,
                      textColor: Colors.black),
                  popupTextField(inputValue: newPinController),
                  loginTexts(
                      text: "Confirm", leftPadding: 0, textColor: Colors.black),
                  popupTextField(inputValue: newPinController2),
                  Padding(
                    padding: const EdgeInsets.only(left: 150),
                    child: loginButton(onClicked: () {}, buttonName: "Save"),
                  ),
                ],
              ));
            });
      },
      child: loginTexts(text: "New user", leftPadding: 45),
    );
  }

  Widget loginButton(
      {required Function() onClicked, required String buttonName}) {
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
    FontWeight fontWeight = FontWeight.normal,
    double leftPadding = 45,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
