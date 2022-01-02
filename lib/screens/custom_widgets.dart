import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sizer/sizer.dart';

final Color appbarBackgroundColor = Color(0xff005c99);
final Color color2 = Color(0xff00bfff);

Widget appBarTexts({
  required String text,
  Color textColor = Colors.white,
  double fontSize = 24,
}) {
  return Text(
    text,
    style: TextStyle(
      shadows: const [
        Shadow(
          color: Colors.grey,
          blurRadius: 1,
          offset: Offset(2, 2),
        )
      ],
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      fontFamily: "BalsamiqSans",
      color: textColor,
    ),
  );
}

Widget appBarSubtitlesWithGestureDetector(
    {required Function() onTap,
    required String titleText,
    Color subtitleColor = Colors.white}) {
  return GestureDetector(
      onTap: onTap,
      child:
          appBarTexts(text: titleText, fontSize: 15, textColor: subtitleColor));
}

Widget appTitle() {
  return appBarTexts(
      text: "Money Manager", fontSize: 24, textColor: Color(0xffffeecc));
}

Widget appBarRightSideIconButton(
    {required Function() onPressed, required Icon icon}) {
  return IconButton(
    onPressed: onPressed,
    icon: icon,
  );
}

Widget elevatedButton({
  required String buttonName,
  required Function() onPressed,
  required Color buttonBackground,
  Color? textColor,
  double borderRadius = 2,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        primary: buttonBackground, // background
        onPrimary: Colors.white, // foreground
      ),
      onPressed: onPressed,
      child: Text(
        buttonName,
        style: TextStyle(
            color: textColor,
            fontSize: 12.sp,
            fontFamily: "Outfit",
            fontWeight: FontWeight.w500),
      ));
}

Widget totalIncomeOrExpense({
  required String value,
  required String value2,
  required List<Color> colorList,
  required Color textColor,
  required double width,
}) {
  return Card(
    elevation: 5,
    child: Container(
      width: width,
      padding: EdgeInsets.only(left: 8, top: 5, bottom: 5),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colorList,
          ),
          borderRadius: BorderRadius.circular(5)),
      //value
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: "Outfit",
                  fontWeight: FontWeight.w400,
                  color: textColor)),
          TextSpan(
              text: value2,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: "Outfit",
                  color: textColor,
                  fontWeight: FontWeight.w500)),
        ]),
      ),
    ),
  );
}

Widget totalIncomeAndTotalExpenseShowingRow(
    {required String totalIncomeText,
    required String totalIncome,
    required String totalExpenseText,
    required String totalExpense,
    required double width}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      totalIncomeOrExpense(
          width: width,
          value: totalIncomeText,
          textColor: Colors.white,
          value2: totalIncome,
          colorList: [appbarBackgroundColor, color2]),
      totalIncomeOrExpense(
          width: width,
          value: totalExpenseText,
          textColor: Colors.black,
          value2: totalExpense,
          colorList: [
            color2,
            appbarBackgroundColor,
          ])
    ],
  );
}

Widget divider({double? width, double? height}) {
  return SizedBox(
    width: width,
    height: height,
  );
}

Widget monthPopupListTile({required String month, required Function() onTap}) {
  return Card(
    elevation: 5,
    color: Colors.grey[400],
    child: ListTile(
      trailing: Text(month),
      onTap: onTap,
    ),
  );
}

Widget listTileCard(
    {String title = '',
    String leading = '',
    String trailing = '',
    Color tileColor = Colors.white,
    Color trailingTextColor = Colors.black,
    Color leadingTextColor = Colors.black,
    Color titleTextColor = Colors.black,
    double? trailingFontSize,
    double? leadingFontSize,
    FontWeight? leadingFontWeight,
    Function()? onTap,
    double elevation = 5,
    Function()? onLongTap}) {
  return Card(
    elevation: elevation,
    color: tileColor,
    shadowColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3.0),
    ),
    child: ListTile(
      leading: Text(
        leading,
        style: TextStyle(
          fontSize: leadingFontSize,
          color: leadingTextColor,
          fontFamily: "Outfit",
          fontWeight: FontWeight.w500,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Outfit",
          color: titleTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        trailing,
        style: TextStyle(
          color: trailingTextColor,
          fontSize: trailingFontSize,
          fontFamily: "Outfit",
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      onLongPress: onLongTap,
    ),
  );
}

Widget floatingActoinButton({required Function() actions}) {
  return FloatingActionButton(
    onPressed: actions,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    backgroundColor: appbarBackgroundColor,
    child: const Icon(Icons.add),
  );
}

Widget textButton({required String text, required Function() onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(fontSize: 18),
    ),
  );
}

Widget timePeriodeChageIcon(
    {required Function() onPressed, required Icon icon}) {
  return ConstrainedBox(
    constraints: BoxConstraints.tightForFinite(width: 35, height: 35),
    child: RawMaterialButton(
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: appbarBackgroundColor,
      child: icon,
      padding: EdgeInsets.all(0.0),
      shape: CircleBorder(),
    ),
  );
}

Widget dateRangeShow(
    {required String initialDate,
    required String finalDate,
    required Function() onTap}) {
  return Container(
    padding: EdgeInsets.only(left: 5, right: 5),
    child: GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(initialDate,
              style: TextStyle(fontFamily: "Roboto", fontSize: 12.5.sp)),
          Text(finalDate,
              style: TextStyle(fontFamily: "Roboto", fontSize: 12.5.sp))
        ],
      ),
      onTap: onTap,
    ),
  );
}
// required String month,
// Text(month,style: TextStyle(fontFamily: "BalsamiqSans",fontSize: 17),),

Widget pichartTitles({
  required String text,
}) {
  return Text(text,
      style: TextStyle(
          fontSize: 17, fontFamily: "BalsamiqSans", color: Color(0xff005c99)));
}
