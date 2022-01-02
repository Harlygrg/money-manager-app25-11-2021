import 'package:flutter/material.dart';

Widget popupTextField({
  required TextEditingController inputValue,
  String hintText = '',
}) {
  return TextField(
    obscureText: true,
    controller: inputValue,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(hintText: hintText),
  );
}

Widget expenseOrIncomeTextField({
  required TextEditingController textEditingController,
  required String hint,
}) {
  return SizedBox(
    width: 300,
    child: TextField(
        controller: textEditingController,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white70,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: Colors.red),
          ),
        )),
  );
}
