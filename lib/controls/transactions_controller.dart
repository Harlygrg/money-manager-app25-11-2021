import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/model/data_model.dart';
import 'package:money_manager_app/model/refactored_functions.dart';

import '../main.dart';

class TransactionsController extends GetxController {
  late Box<IncomeExpenseModel> incomeExpenseBox;

  updateState() {
    update();
  }

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
      incomeSum();
      expenseSum();
      update();
    }
  }

  var incrementCounter = 0;
  DateTime _startDate = now;
  DateTime _endDate = now;
  double sumInc = 0;
  double sumExp = 0;
  String selectedMonth = DateFormat('MMMM').format(now);

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

  final items = <String>[
    "All",
    "Today",
    "Yesterday",
    "Monthly",
    "Select Range"
  ];
  String dropdownValue = "All";

  double incomeSum() {
    if (dropdownValue == "All") {
      List<int> incomeKeys = incomeExpenseBox.keys
          .cast<int>()
          .where((key) =>
              (incomeExpenseBox.get(key)!.isIncome == true) &&
              (incomeExpenseBox.get(key)!.createdDate.year ==
                  monthlyDateSelector().year))
          .toList();
      double sumIncAll = 0;
      for (int i = 0; i <= incomeKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeys[i]);
        sumIncAll = sumIncAll + incomeAmounts!.amount!;
      }
      sumInc = sumIncAll;
    } else if (dropdownValue == "Today") {
      List<int> incomeKeys = incomeExpenseBox.keys.cast<int>().where((key) {
        return (incomeExpenseBox.get(key)!.isIncome == true) &&
            (incomeExpenseBox.get(key)!.createdDate == todaysDateSelector());
      }).toList();
      double sumIncDay = 0;
      for (int i = 0; i <= incomeKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeys[i]);
        sumIncDay = sumIncDay + incomeAmounts!.amount!;
      }
      sumInc = sumIncDay;
    } else if (dropdownValue == "Yesterday") {
      List<int> incomeKeys = incomeExpenseBox.keys.cast<int>().where((key) {
        return (incomeExpenseBox.get(key)!.isIncome == true) &&
            (incomeExpenseBox.get(key)!.createdDate ==
                yesterdaysDateSelector());
      }).toList();
      double sumIncYesterday = 0;
      for (int i = 0; i <= incomeKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeys[i]);
        sumIncYesterday = sumIncYesterday + incomeAmounts!.amount!;
      }
      sumInc = sumIncYesterday;
    } else if (dropdownValue == "Monthly") {
      List<int> incomeKeys = incomeExpenseBox.keys.cast<int>().where((key) {
        return (incomeExpenseBox.get(key)!.isIncome == true) &&
            (incomeExpenseBox.get(key)!.createdDate.month ==
                monthlyDateSelector().month) &&
            (incomeExpenseBox.get(key)!.createdDate.year ==
                monthlyDateSelector().year);
      }).toList();
      double sumIncMonthly = 0;
      for (int i = 0; i <= incomeKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeys[i]);
        sumIncMonthly = sumIncMonthly + incomeAmounts!.amount!;
      }
      sumInc = sumIncMonthly;
    } else {
      List<int> incomeKeysRange;
      List<int> range = [];
      _startDate = dateRange.start;
      _endDate = dateRange.end;
      int difference = _endDate.difference(_startDate).inDays;
      for (int i = 0; i <= difference; i++) {
        range.addAll(incomeExpenseBox.keys.cast<int>().where((key) {
          return (incomeExpenseBox.get(key)!.createdDate ==
                  _startDate.add(Duration(days: i))) &&
              (incomeExpenseBox.get(key)!.isIncome == true);
        }).toList());
      }
      incomeKeysRange = range.toList();

      double sumIncRange = 0;
      for (int i = 0; i <= incomeKeysRange.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(incomeKeysRange[i]);
        sumIncRange = sumIncRange + incomeAmounts!.amount!;
      }
      sumInc = sumIncRange;
    }
    return sumInc;
  }

  double expenseSum() {
    if (dropdownValue == "All") {
      List<int> expenseKeys = incomeExpenseBox.keys
          .cast<int>()
          .where((key) =>
              (incomeExpenseBox.get(key)!.isIncome == false) &&
              (incomeExpenseBox.get(key)!.createdDate.year ==
                  monthlyDateSelector().year))
          .toList();
      double sumExpAll = 0;
      for (int i = 0; i <= expenseKeys.length - 1; i++) {
        var expenseAmounts = incomeExpenseBox.get(expenseKeys[i]);
        sumExpAll = sumExpAll + expenseAmounts!.amount!;
      }
      sumExp = sumExpAll;
    } else if (dropdownValue == "Today") {
      List<int> expenseKeys = incomeExpenseBox.keys.cast<int>().where((key) {
        return (incomeExpenseBox.get(key)!.isIncome == false) &&
            (incomeExpenseBox.get(key)!.createdDate == todaysDateSelector());
      }).toList();
      double sumExpDay = 0;
      for (int i = 0; i <= expenseKeys.length - 1; i++) {
        var expenseAmounts = incomeExpenseBox.get(expenseKeys[i]);
        sumExpDay = sumExpDay + expenseAmounts!.amount!;
      }
      sumExp = sumExpDay;
    } else if (dropdownValue == "Yesterday") {
      List<int> expenseKeys = incomeExpenseBox.keys.cast<int>().where((key) {
        return (incomeExpenseBox.get(key)!.isIncome == false) &&
            (incomeExpenseBox.get(key)!.createdDate ==
                yesterdaysDateSelector());
      }).toList();
      double sumExpYesterday = 0;
      for (int i = 0; i <= expenseKeys.length - 1; i++) {
        var expenseAmounts = incomeExpenseBox.get(expenseKeys[i]);
        sumExpYesterday = sumExpYesterday + expenseAmounts!.amount!;
      }
      sumExp = sumExpYesterday;
    } else if (dropdownValue == "Monthly") {
      List<int> expenseKeys = incomeExpenseBox.keys.cast<int>().where((key) {
        return (incomeExpenseBox.get(key)!.isIncome == false) &&
            (incomeExpenseBox.get(key)!.createdDate.month ==
                monthlyDateSelector().month) &&
            (incomeExpenseBox.get(key)!.createdDate.year ==
                monthlyDateSelector().year);
      }).toList();
      double sumExpMonthly = 0;
      for (int i = 0; i <= expenseKeys.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(expenseKeys[i]);
        sumExpMonthly = sumExpMonthly + incomeAmounts!.amount!;
      }
      sumExp = sumExpMonthly;
    } else {
      List<int> expenseKeysRange;
      List<int> range = [];
      _startDate = dateRange.start;
      _endDate = dateRange.end;
      print("start Date :$_startDate, end Date : $_endDate");
      int difference = _endDate.difference(_startDate).inDays;
      for (int i = 0; i <= difference; i++) {
        range.addAll(incomeExpenseBox.keys.cast<int>().where((key) {
          return (incomeExpenseBox.get(key)!.createdDate ==
                  _startDate.add(Duration(days: i))) &&
              (incomeExpenseBox.get(key)!.isIncome == false);
        }).toList());
      }
      expenseKeysRange = range.toList();

      double sumExpRange = 0;
      for (int i = 0; i <= expenseKeysRange.length - 1; i++) {
        var incomeAmounts = incomeExpenseBox.get(expenseKeysRange[i]);
        sumExpRange = sumExpRange + incomeAmounts!.amount!;
      }
      sumExp = sumExpRange;
    }
    return sumExp;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    incomeExpenseBox = Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
    incomeSum();
    expenseSum();
    super.onInit();
  }

  timePeriodChangeIconIncrementOnPressed() {
    if (dropdownValue == "Monthly") {
      if (incrementCounter > 0) {
        incrementCounter = incrementCounter - 1;
        selectedMonth = DateFormat('MMMM').format(monthlyDateSelector());
        incomeSum();
        expenseSum();
        //update();
      }
    }
  }

  timePeriodChangeIconDecrementOnPressed() {
    if (dropdownValue == "Monthly") {
      if (incrementCounter < 11) {
        incrementCounter = incrementCounter + 1;
      }
      selectedMonth = DateFormat('MMMM').format(monthlyDateSelector());
      incomeSum();
      expenseSum();
      update();
    }
  }

  dropdownMenuItemOnchanged(newValue) {
    dropdownValue = newValue!;
    incomeSum();
    expenseSum();
    update();
  }

  List<int> keys = [];

  listenableBuilder() {
    incomeSum();
    expenseSum();
    if (dropdownValue == "All") {
      List<int> keysUnsorted;
      keysUnsorted = incomeExpenseBox.
          //keys.cast<int>().toList();
          keys
          .cast<int>()
          .where((key) => (incomeExpenseBox.get(key)!.createdDate.year ==
              todaysDateSelector().year))
          .toList();
      List<DateTime> datesList = [];
      for (int i = 0; i < keysUnsorted.length; i++) {
        DateTime date = incomeExpenseBox.get(keysUnsorted[i])!.createdDate;
        datesList.add(date);
      }
      datesList.sort();
      List<DateTime> reversedDateList = List.from(datesList.reversed);
      var duplicatesRemovedFromReversedDateList =
          reversedDateList.toSet().toList();
      reversedDateList = duplicatesRemovedFromReversedDateList.toList();
      List<int> sortedKeys = [];
      List<int> keyInorder;
      for (int j = 0; j < reversedDateList.length; j++) {
        keyInorder = incomeExpenseBox.keys
            .cast<int>()
            .where((key) =>
                incomeExpenseBox.get(key)!.createdDate == reversedDateList[j])
            .toList();
        List<int> reversedList = List.from(keyInorder.reversed);
        sortedKeys.addAll(reversedList);
      }
      keys = sortedKeys.toList();
    } else if (dropdownValue == "Today") {
      keys = incomeExpenseBox.keys
          .cast<int>()
          .where((key) =>
              incomeExpenseBox.get(key)!.createdDate == todaysDateSelector())
          .toList();
      var reversedKeys = keys.reversed;
      keys = reversedKeys.toList();
    } else if (dropdownValue == "Yesterday") {
      keys = incomeExpenseBox.keys
          .cast<int>()
          .where((key) =>
              incomeExpenseBox.get(key)!.createdDate ==
              yesterdaysDateSelector())
          .toList();
      var reversedKeys = keys.reversed;
      keys = reversedKeys.toList();
    } else if (dropdownValue == "Monthly") {
      List<int> unsortedKeysForOneMonth;
      unsortedKeysForOneMonth = incomeExpenseBox.keys
          .cast<int>()
          .where((key) =>
              (incomeExpenseBox.get(key)!.createdDate.month ==
                  monthlyDateSelector().month) &&
              (incomeExpenseBox.get(key)!.createdDate.year ==
                  monthlyDateSelector().year))
          .toList();
      selectedMonth = DateFormat('MMMM').format(monthlyDateSelector());
      List<DateTime> monthlyDatesList = [];
      for (int i = 0; i < unsortedKeysForOneMonth.length; i++) {
        DateTime date =
            incomeExpenseBox.get(unsortedKeysForOneMonth[i])!.createdDate;
        monthlyDatesList.add(date);
      }
      monthlyDatesList.sort();
      var duplicateDatesRemoved = monthlyDatesList.reversed.toSet().toList();
      monthlyDatesList = duplicateDatesRemoved.toList();
      Iterable<int> monthelyKeysInorder;
      List<int> sortedMothlyKeys = [];
      for (int j = 0; j < monthlyDatesList.length; j++) {
        monthelyKeysInorder = incomeExpenseBox.keys.cast<int>().where((key) =>
            incomeExpenseBox.get(key)!.createdDate == monthlyDatesList[j]);
        sortedMothlyKeys.addAll(monthelyKeysInorder);
      }
      keys = sortedMothlyKeys.toList();
    } else if (dropdownValue == "Select Range") {
      List<int> range = [];
      _startDate = dateRange.start;
      _endDate = dateRange.end;
      int difference = _endDate.difference(_startDate).inDays;
      for (int i = 0; i <= difference; i++) {
        range.addAll(incomeExpenseBox.keys
            .cast<int>()
            .where((key) =>
                incomeExpenseBox.get(key)!.createdDate ==
                _startDate.add(Duration(days: i)))
            .toList());
      }
      keys = range.reversed.toList();
    } else {
      return Text("No Transactions");
    }
  }
}
