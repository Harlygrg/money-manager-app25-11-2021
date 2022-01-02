import 'package:flutter/material.dart';

class HomeWidget {
  Widget tabbarTxt(
      {
        required String text,
      }
      )
  {
    return Text(text,
      style:TextStyle(
        fontSize: 15,
        fontFamily: "Outfit",
        fontWeight: FontWeight.w500,
      ),

    );
  }
}