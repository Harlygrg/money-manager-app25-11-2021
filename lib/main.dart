import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/widgetsUI/login_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'package:money_manager_app/actions/data_model.dart';
import 'package:money_manager_app/widgetsUI/transactions_page.dart';
import 'package:money_manager_app/widgetsUI/home_page.dart';
import 'package:money_manager_app/widgetsUI/adding_expense_or_income.dart';
import 'package:money_manager_app/widgetsUI/piechart.dart';
import 'package:money_manager_app/widgetsUI/testingPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_manager_app/widgetsUI/settings_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
const categoryBoxName ="categoryMain";
const incomeExpenseBoxName ="incomeExpenseMain";
  late SharedPreferences sharedPreferences;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(IncomeExpenseModelAdapter());
  await Hive.openBox<IncomeExpenseModel>(incomeExpenseBoxName);
  await Hive.openBox<CategoryModel>(categoryBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'AddIncomeOrExpense':(context) =>  AddIncomeOrExpense(),
        'pie_chart':(context) =>  Piechart(),
        'HomePage':(context) =>  HomePage(),
        'SettingsPage':(context) =>  Setting(),


      },
      home: LoginPage(),

    );
  }
}

