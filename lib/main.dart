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


const categoryBoxName ="categoryMain";
const incomeExpenseBoxName ="incomeExpenseMain";
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
      routes: {
        'AddIncomeOrExpense':(context) =>  AddIncomeOrExpense(),
        'pie_chart':(context) =>  Piechart(),
        'HomePage':(context) =>  HomePage(),


      },
      home: LoginPage(),

    );
  }
}

