import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:money_manager_app/model/data_model.dart';

import '../main.dart';

class Categorycontroller extends GetxController {
  bool incomeCategoryButtonSelected = true;
  final formKey = GlobalKey<FormState>();
  final newCategoryController = TextEditingController();
  final updateCategoryController = TextEditingController();
  late Box<CategoryModel> categoryBox;
  bool categoriesButtonColorChecker = true;
  List<int> keys = [];

  @override
  void onInit() {
    // TODO: implement onInit
    categoryBox = Hive.box<CategoryModel>(categoryBoxName);
    super.onInit();
  }

  updateState() {
    update();
  }

  incomeButtonOnPressed() {
    update();
    incomeCategoryButtonSelected = true;
    //incomeTrue =true;
    categoriesButtonColorChecker = true;
  }

  expenseButtonOnPressed() {
    //incomeTrue =false;
    update();
    incomeCategoryButtonSelected = false;
    categoriesButtonColorChecker = false;
  }

  incomeExpenseAddition() {
    final isValid = formKey.currentState!.validate();
    final String newCategory = newCategoryController.text;

    if (isValid) {
      if (incomeCategoryButtonSelected == true) {
        CategoryModel category =
            CategoryModel(category: newCategory, isIncome: true);
        categoryBox.add(category);
        print("Income category added-------------");
      } else {
        CategoryModel category =
            CategoryModel(category: newCategory, isIncome: false);
        categoryBox.add(category);
        print("Expense Category added-------------");
      }

      newCategoryController.clear();
      Get.back();
    }
  }

  List<int> listViewCondition() {
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
    //update();
    return keys;
  }
}
