import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/model/data_model.dart';
import 'package:money_manager_app/widgets/overview_widgets.dart';
import '../main.dart';

class OverviewController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    incomeExpenseBox = Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
    super.onInit();
  }

  String monthYear = DateFormat.yMMMM().format((DateTime.now()));
  late Box<IncomeExpenseModel> incomeExpenseBox;
  ViewWidgtes widgets = ViewWidgtes();
  List incAmounts = [];
  List expAmounts = [];
  List incCategories = [];
  List expCategories = [];
  List allAmounts = [];
  List allCategories = [];
  double prgInd = 0;
  var check;

  setUpdate() {
    update();
  }

  Map<String, double> incExpCatWiseDatas({required bool isIncome}) {
    List<int> incomeKeys = incomeExpenseBox.keys
        .cast<int>()
        .where((key) => ((incomeExpenseBox.get(key)!.isIncome == isIncome) &&
            (incomeExpenseBox.get(key)!.createdDate.month ==
                DateTime.now().month) &&
            (incomeExpenseBox.get(key)!.createdDate.year ==
                DateTime.now().year)))
        .toList();
    Map<String, double> datasForPieChart = {};
    List<String> incCatList = [];
    for (int i = 0; i < incomeKeys.length; i++) {
      var incCat = incomeExpenseBox.get(incomeKeys[i])!.category;
      incCatList.add(incCat.toString());
    }
    var incCatListDuplicateCatRemove = incCatList.toSet().toList();
    incCatList = incCatListDuplicateCatRemove.toList();

    for (int j = 0; j < incCatList.length; j++) {
      double sum = 0;
      for (int i = 0; i < incomeKeys.length; i++) {
        var inCat = incomeExpenseBox.get(incomeKeys[i])!.category;
        var incCatAmt = incomeExpenseBox.get(incomeKeys[i])!.amount!;
        if (incCatList[j] == inCat) {
          sum = sum + incCatAmt;
        }
      }
      datasForPieChart[incCatList[j]] = sum;
    }
    //update();
    return datasForPieChart;
  }

  double totalAmouns({
    required bool isIncome,
  }) {
    List<double> totals = [];
    double total = 0;
    totals = incExpCatWiseDatas(isIncome: isIncome).values.toList();
    for (int i = 0; i < totals.length; i++) {
      total = total + totals[i];
    }
    return total;
  }

  double balance() {
    double balance = totalAmouns(isIncome: true) - totalAmouns(isIncome: false);
    return balance;
  }

  double progresIndicatorVal() {
    if (totalAmouns(isIncome: true) > 0) {
      prgInd = (totalAmouns(isIncome: true) - totalAmouns(isIncome: false)) /
          totalAmouns(isIncome: true);
      return prgInd;
    } else {
      prgInd = 0;
      return prgInd;
    }
  }

  listvalues() {
    allCategories.clear();
    allAmounts.clear();
    incCategories = incExpCatWiseDatas(isIncome: true).keys.toList();
    incAmounts = incExpCatWiseDatas(isIncome: true).values.toList();
    expCategories = incExpCatWiseDatas(isIncome: false).keys.toList();
    expAmounts = incExpCatWiseDatas(isIncome: false).values.toList();
    allAmounts.addAll(incAmounts);
    allAmounts.addAll(expAmounts);
    allCategories.addAll(incCategories.cast());
    allCategories.addAll(expCategories);
  }
}
