import 'dart:io' show Directory;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/screens/inc_exp_add.dart';
import 'package:money_manager_app/screens/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:money_manager_app/model/data_model.dart';
import 'package:money_manager_app/screens/home_page.dart';
import 'package:money_manager_app/screens/piechart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_manager_app/screens/settings_page.dart';
import 'package:sizer/sizer.dart';

import 'controls/home_chart_settings_login_controller.dart';

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
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.openBox<IncomeExpenseModel>(incomeExpenseBoxName);
  await Hive.openBox<CategoryModel>(categoryBoxName);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
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
    );


  }
}

