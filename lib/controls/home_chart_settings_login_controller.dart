import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/model/data_model.dart';
import 'package:money_manager_app/model/notification_api.dart';
import 'package:money_manager_app/screens/home_page.dart';
import 'package:money_manager_app/screens/login_page.dart';

import '../main.dart';

class HomeChartSettingsLoginController extends GetxController
    with GetTickerProviderStateMixin {
  BuildContext cont;

  HomeChartSettingsLoginController({required this.cont});

  updateSettings() {
    update();
  }

//variables from home page
  late TabController tabController;
  late int tabIndex;

  //variablse from pichart
  static DateTime now = DateTime.now();
  bool incomePichartSelect = true;
  int incrementCounter = 0;
  String selectedMonth = DateFormat('MMMM').format(now);
  late Box<IncomeExpenseModel> incomeExpenseBox;
  final items = ["All", "Today", "Yesterday", "Monthly", "Select Range"];
  String dropdownValues = "All";
  List<Color> colorList = [
    Color(0xff003f5c),
    Color(0xff58508d),
    Color(0xffbc5090),
    Color(0xffff6361),
    Color(0xffffa600),
  ];

  //variabes from settings
  bool isSwitched = false;
  TimeOfDay? picked;
  TimeOfDay notificationTime = TimeOfDay.now();
  int hr = 0;
  int mn = 0;
  String selectedTime = '8:00 AM';

  //variables from login page
  bool loginPageData = false;
  final pinController = TextEditingController();
  final forgotpinRecovary = TextEditingController();
  final newPinController = TextEditingController();
  final newPinController2 = TextEditingController();
  late Box<CategoryModel> categoryBox;
  final initialCatList = [
    "Shopping",
    "Clothes",
    "Kids",
    "Education",
    "Holidays",
    "Entertainment",
    "Salary",
    "Other"
  ];

//home page controlls
  @override
  void onInit() {
    // TODO: implement onInit
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.onInit();
    //pichart initiliasation
    incomeExpenseBox = Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
    incomeCategories(isIncome: true);
    incomeCategories(isIncome: false);
    //settings initilisation
    NotificationApi.init(initScheduled: true);
    //listenNotifications();
    //getSavedDataSettingsPage(context);
    // login page initilisation
    WidgetsBinding.instance!.addPostFrameCallback((_) => getSavedData(cont));
    categoryBox = Hive.box<CategoryModel>(categoryBoxName);
  }

//piechart controllers

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(now.year, now.month, (now.day) - 3),
    end: now,
  );

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime(now.year, now.month, (now.day) - 3),
      end: now,
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: dateRange,
    );
    if (newDateRange == null) {
      return;
    } else {
      dateRange = newDateRange;
      incomeCategories(isIncome: true);
      incomeCategories(isIncome: false);
      update();
    }
  }

  DateTime monthlyDateSelector() {
    DateTime monthlyDatas =
        DateTime(now.year, (now.month) - incrementCounter, now.day);
    return monthlyDatas;
  }

  DateTime todaysDateSelector() {
    DateTime todaysDate = DateTime(now.year, now.month, now.day);
    return todaysDate;
  }

  DateTime yesterdaysDateSelector() {
    DateTime yesterdayDate = DateTime(now.year, now.month, (now.day) - 1);
    return yesterdayDate;
  }

  Map<String, double> incomeCategories({required bool isIncome}) {
    if (dropdownValues == "All") {
      return pieChartDatas(
          incomeKeys: incomeExpenseBox.keys
              .cast<int>()
              .where((key) =>
                  ((incomeExpenseBox.get(key)!.isIncome == isIncome) &&
                      (incomeExpenseBox.get(key)!.createdDate.year ==
                          todaysDateSelector().year)))
              .toList(),
          isIncome: isIncome);
    } else if (dropdownValues == "Today") {
      return pieChartDatas(
          incomeKeys: incomeExpenseBox.keys
              .cast<int>()
              .where((key) =>
                  ((incomeExpenseBox.get(key)!.isIncome == isIncome) &&
                      (incomeExpenseBox.get(key)!.createdDate ==
                          todaysDateSelector())))
              .toList(),
          isIncome: isIncome);
    } else if (dropdownValues == "Yesterday") {
      return pieChartDatas(
          incomeKeys: incomeExpenseBox.keys
              .cast<int>()
              .where((key) =>
                  ((incomeExpenseBox.get(key)!.isIncome == isIncome) &&
                      (incomeExpenseBox.get(key)!.createdDate ==
                          yesterdaysDateSelector())))
              .toList(),
          isIncome: isIncome);
    } else if (dropdownValues == "Monthly") {
      return pieChartDatas(
          incomeKeys: incomeExpenseBox.keys
              .cast<int>()
              .where((key) =>
                  ((incomeExpenseBox.get(key)!.isIncome == isIncome) &&
                      (incomeExpenseBox.get(key)!.createdDate.month ==
                          monthlyDateSelector().month) &&
                      (incomeExpenseBox.get(key)!.createdDate.year ==
                          monthlyDateSelector().year)))
              .toList(),
          isIncome: isIncome);
    } else {
      //List<int> incomeKeysRange;
      List<int> range = [];
      int difference = dateRange.end.difference(dateRange.start).inDays;
      for (int i = 0; i <= difference; i++) {
        range.addAll(incomeExpenseBox.keys.cast<int>().where((key) {
          return (incomeExpenseBox.get(key)!.createdDate ==
                  dateRange.start.add(Duration(days: i))) &&
              (incomeExpenseBox.get(key)!.isIncome == isIncome);
        }).toList());
      }
      return pieChartDatas(incomeKeys: range, isIncome: isIncome);
    }
  }

  Map<String, double> pieChartDatas(
      {required List<int> incomeKeys, required bool isIncome}) {
    Map<String, double> datasForPieChart = {};
    List<String> incCatList = [];
    List<int> incomeKeysForCatType = incomeExpenseBox.keys
        .cast<int>()
        .where((key) => incomeExpenseBox.get(key)!.isIncome == isIncome)
        .toList();
    for (int i = 0; i < incomeKeysForCatType.length; i++) {
      var incCat = incomeExpenseBox.get(incomeKeysForCatType[i])!.category;
      incCatList.add(incCat.toString());
    }
    var incCatListDuplicateCatRemove = incCatList.toSet().toList();
    incCatList = incCatListDuplicateCatRemove.toList();
    print("income categories : $incCatList");

    for (int j = 0; j < incCatList.length; j++) {
      double sum = 0;
      for (int i = 0; i < incomeKeys.length; i++) {
        var inCat = incomeExpenseBox.get(incomeKeys[i])!.category;
        var incCatAmt = incomeExpenseBox.get(incomeKeys[i])!.amount!;
        if (incCatList[j] == inCat) {
          sum = sum + incCatAmt;
        }
      }
      if (sum > 0) {
        datasForPieChart[incCatList[j]] = sum;
      }
    }
    print("Incme category sum: $datasForPieChart");

    return datasForPieChart;
  }

  incomeButtonOnPressed() {
    //incomeTrue =true;
    incomePichartSelect = true;
    update();
  }

  expenseButtonOnPressed() {
    //incomeTrue =true;
    incomePichartSelect = false;
    update();
  }

  dropdownButtonOnchanged(newValue) {
    dropdownValues = newValue!;
    incomeCategories(isIncome: true);
    incomeCategories(isIncome: false);
    update();
  }

  timePeriodChangeIconIncrement() {
    if (dropdownValues == "Monthly") {
      if (incrementCounter > 0) {
        incrementCounter = incrementCounter - 1;
        selectedMonth = DateFormat('MMMM').format(monthlyDateSelector());
        incomeCategories(isIncome: true);
        incomeCategories(isIncome: false);
      }
      update();
    }
  }

  timePeriodChangeIconDecrement() {
    if (dropdownValues == "Monthly") {
      incrementCounter = incrementCounter + 1;
      selectedMonth = DateFormat('MMMM').format(monthlyDateSelector());
      incomeCategories(isIncome: true);
      incomeCategories(isIncome: false);
      update();
    }
  }

  // settings controls
  Future<void> selectTime(BuildContext context) async {
    picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      selectedTime = picked!.format(context);
      notificationTime = picked!;
      hr = notificationTime.hour;
      mn = notificationTime.minute;
    }
    update();
  }

  // void listenNotifications(){
  //   NotificationApi.onNotifications.stream.listen(onClickedNotification);
  // }
  //
  // void onClickedNotification(String ? payload,){
  //   Get.to(HomePage());
  // }
  Future<void> saveSettingsPageDataToStorage(
    BuildContext context,
  ) async {
    await sharedPreferences.setBool("notification", isSwitched);
    await sharedPreferences.setInt('hour', hr);
    await sharedPreferences.setInt('minute', mn);
  }

  Future<void> getSavedDataSettingsPage(
    BuildContext context,
  ) async {
    final savedValue = sharedPreferences.getBool("notification");
    final savedHour = sharedPreferences.getInt("hour");
    final savedMinute = sharedPreferences.getInt("minute");
    if (savedHour! > 12) {
      if (savedMinute! < 10) {
        selectedTime = "${savedHour - 12}:0$savedMinute PM";
      } else {
        selectedTime = "${savedHour - 12}:$savedMinute PM";
      }
    } else {
      if (savedMinute! < 10) {
        selectedTime = "${savedHour}:0$savedMinute AM";
      } else {
        selectedTime = "$savedHour:$savedMinute AM";
      }
    }
    if (savedHour != hr && savedMinute != mn) {
      hr = savedHour;
      mn = savedMinute;
    }
    if (savedValue == false) {
      isSwitched = true;
    } else {
      isSwitched = false;
    }
  }

//login page controllers
  Future<void> saveDataToStorage() async {
    print(loginPageData);
    await sharedPreferences.setBool('login_data', loginPageData);
  }

  Future<void> getSavedData(BuildContext context) async {
    final savedValue = sharedPreferences.getBool("login_data");
    if (savedValue == true) {
      Navigator.pushReplacementNamed(context, "HomePage");
    }
  }
}
