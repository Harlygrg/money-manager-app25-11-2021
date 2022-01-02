import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/model/data_model.dart';

import '../main.dart';

class IncExpAddController extends GetxController {
  var formKey = GlobalKey<FormState>();
  static DateTime nowq = DateTime.now();
  DateTime currentDate = DateTime(nowq.year, nowq.month, nowq.day);
  String categoryValue = "";
  String selectedCategory = "Select Category";
  final amountController = TextEditingController();
  final extranotesController = TextEditingController();
  bool incomeCategoryButtonSelected = true;
  bool categoriesButtonColorChecker = true;
  bool categoryChoosed = false;
  bool catagorySelector = false;
  late Box<IncomeExpenseModel> incomeExpenseBox;
  late Box<CategoryModel> categoryBox;
  int buttonGroupvalue = 1;
  String date = DateFormat.yMMMEd().format(nowq);
  String dropdownValue = "apple";
  late Box<IncomeExpenseModel> incomeAndExpenseBox;
  List<int> keys = [];

  updateState() {
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    incomeAndExpenseBox = Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
    categoryBox = Hive.box<CategoryModel>(categoryBoxName);
    super.onInit();
  }

  radioButtonOnChanged(value) {
    incomeCategoryButtonSelected = true;
    buttonGroupvalue = 1;
    catagorySelector = false;
    categoriesButtonColorChecker = true;
    update();
  }

  radioButtonSecondOnChanged(value) {
    incomeCategoryButtonSelected = false;
    buttonGroupvalue = 2;
    categoriesButtonColorChecker = false;
    catagorySelector = false;
    update();
  }

  listTileOntap(BuildContext context) async {
    currentDate = (await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(2010, 12, 31),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
    ))!;
    date = DateFormat.yMMMEd().format(currentDate);
    update();
    print("current date ==$currentDate");
  }

  listenableBuilderValues() {
    if (incomeCategoryButtonSelected == true) {
      keys = categoryBox.keys
          .cast<int>()
          .where((key) => categoryBox.get(key)!.isIncome)
          .toList();
    } else {
      keys = categoryBox.keys
          .cast<int>()
          .where((key) => !categoryBox.get(key)!.isIncome)
          .toList();
    }
  }

  categorySelectingOnTap(key) {
    categoryValue = categoryBox.get(key)!.category!;
    selectedCategory = categoryValue;
    catagorySelector = false;
    categoryChoosed = true;
    update();
    // _onSelected(index);
    Get.back();
  }

  saveButtonPressed(BuildContext context) {
    final double newAmount = double.parse(amountController.text);
    final String newExtraNotes = extranotesController.text;
    final DateTime newDate = currentDate;
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      if (categoryChoosed == false) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Please choose category"),
              );
            });
      } else {
        if (incomeCategoryButtonSelected == true) {
          IncomeExpenseModel income = IncomeExpenseModel(
              isIncome: true,
              createdDate: newDate,
              amount: newAmount,
              extraNotes: newExtraNotes,
              category: categoryValue);
          incomeAndExpenseBox.add(income);
          print("income added");
          print(
              "-!-${income.category},${income.amount}, ${income.createdDate},${income.extraNotes}-!-");
          amountController.clear();
          extranotesController.clear();
          categoryValue = "";
          Get.back();
        } else {
          IncomeExpenseModel expense = IncomeExpenseModel(
              isIncome: false,
              createdDate: newDate,
              amount: newAmount,
              extraNotes: newExtraNotes,
              category: categoryValue);
          incomeAndExpenseBox.add(expense);
          print("-----expense added------");
          print(
              "-!-${expense.category},${expense.amount}, ${expense.createdDate}-!-");
          amountController.clear();
          extranotesController.clear();
          categoryValue = "";
          Get.back();
        }
      }
    } else if (categoryChoosed == false) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Please choose category"),
            );
          });
    }
  }
}
