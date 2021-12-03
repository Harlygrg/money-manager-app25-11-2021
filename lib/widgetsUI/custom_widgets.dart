

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Color appbarBackgroundColor = Color(0xff005c99);
Widget appBarTexts({
  required String text,
  Color textColor=Colors.white,
  double fontSize = 24,
}){
  return Text(text,
    style: TextStyle(shadows:const [
      // Shadow(
      //   color: Colors.grey,
      //   blurRadius: 1,
      //   offset: Offset(2,2),
      // )
    ],
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      fontFamily: "BalsamiqSans",
      color:textColor,),
  );
}


Widget appBarSubtitlesWithGestureDetector({
  required Function() onTap,
  required String titleText,
  Color subtitleColor =Colors.white
}){
  return GestureDetector(
      onTap:onTap,
      child: appBarTexts(
          text: titleText,
          fontSize: 15,
          textColor: subtitleColor)
  );
}

Widget appTitle(){
  return appBarTexts(text: "Money Manager",
      fontSize: 24,
      textColor:Color(0xffffeecc) );
}



Widget appBarRightSideIconButton({
  required Function() onPressed,
  required Icon icon
}){
  return IconButton(
    onPressed: onPressed,
    icon:icon ,
  );
}


Widget elevatedButton({
  required String buttonName,
  required Function() onPressed,
  required Color buttonBackground,
  double borderRadius =2,
}){
  return  ElevatedButton(style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    primary: buttonBackground, // background
    onPrimary: Colors.white, // foreground
  ),
      onPressed: onPressed,
      child: Text(buttonName,
      ));
}



Widget totalIncomeOrExpense({
  required String value,
  required backgroundColor,
  required textColor,
}){
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(0),
    ),
    child: Center(child:
    appBarTexts(text: value,fontSize: 15,textColor:textColor ),),
  );
}



Widget totalIncomeAndTotalExpenseShowingRow({
  required String totalIncome,
  required String totalExpense,

}){
  return Row(
    children: [
      Expanded(child: totalIncomeOrExpense(value: totalIncome, backgroundColor: Color(0xff80d4ff),textColor: Color(0xff009900))),

      Expanded(child: totalIncomeOrExpense(value: totalExpense, backgroundColor: Color(0xffffc2b3),textColor: Color(0xffff3300))),

    ],);
}



Widget divider({
  double ?width,
  double ?height
}){
  return SizedBox(
    width: width,
    height: height,
  );
}



Widget monthPopupListTile({
  required String month,
  required Function () onTap
}){
  return Card(elevation: 5,
    color: Colors.grey[400],
    child: ListTile(
      trailing: Text(month),
      onTap: onTap,
    ),
  );
}
Widget listTileCard({
  String title ='',
  String leading ='',
  String trailing ='',
  Color tileColor =Colors.white,
  Color trailingTextColor= Colors.black,
  double ?trailingFontSize,
  double ?leadingFontSize,
  Function() ?onTap,
  double elevation=5,
  Function() ?onLongTap
}){
  return Card(elevation: elevation,
    color: tileColor,
    child: ListTile(
      leading: Text(leading,style: TextStyle(fontSize: leadingFontSize,fontFamily: "Roboto"),),
      title: Text(title,style: TextStyle(fontFamily: "Roboto",),),
      trailing: Text(
        trailing,
        style: TextStyle(
            color: trailingTextColor,
            fontSize:trailingFontSize ),),

      onTap: onTap,
      onLongPress: onLongTap,
    ),
  );
}


Widget floatingActoinButton({
  required Function() actions
}){
  return FloatingActionButton(
    onPressed: actions,
    backgroundColor: appbarBackgroundColor,
    child: Icon(Icons.add),
  );
}


Widget textButton({
  required String text,
  required Function() onPressed
}){
  return TextButton(
    onPressed: onPressed,
    child: Text(text,
      style: TextStyle(fontSize: 18),),
  );
}

Widget timePeriodeChageIcon({
  required Function() onPressed,
  required Icon icon
}){
  return RawMaterialButton(
    onPressed: onPressed,
    elevation: 2.0,
    fillColor: Colors.blue,
    child: icon,
    padding: EdgeInsets.all(1.0),
    shape: CircleBorder(),
  );
}


Widget dateRangeShow({
  required String initialDate,
  required String finalDate,
  required Function() onTap
}){
  return Container(
    padding: EdgeInsets.only(left: 5,right: 5),
    child: GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(initialDate,style: TextStyle(fontFamily: "Roboto",fontSize: 17)),

          Text(finalDate,style: TextStyle(fontFamily: "Roboto",fontSize: 17))
        ],
      ),
      onTap:onTap ,
    ),
  );
}
// required String month,
// Text(month,style: TextStyle(fontFamily: "BalsamiqSans",fontSize: 17),),

Widget pichartTitles({
  required String text,
}){
  return Text(text,style:TextStyle(
  fontSize: 17,fontFamily: "BalsamiqSans",color: Color(0xff005c99)
  ));
}


