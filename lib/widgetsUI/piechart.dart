import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/widgetsUI/textFields.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/actions/data_model.dart';
import 'package:money_manager_app/main.dart';

class Piechart extends StatefulWidget {
  @override
  _PiechartState createState() => _PiechartState();
}

class _PiechartState extends State<Piechart> {
  late Box<IncomeExpenseModel> incomeExpenseBox;
  late Box<CategoryModel> categoryBox;
  final items = ["All","Today","Yesterday","Monthly","Select Range"];
  String dropdownValue ="All";

  void incTranscat(){
    List<double> incCatSum=[];
    List<int> incomeKeys = incomeExpenseBox.keys.
    cast<int>().where((key) => incomeExpenseBox.get(key)!.isIncome==true).toList();
    for(int j=0;j<categoryItems().length;j++){
      double sum=0;
      for(int i=0;i<incomeKeys.length;i++){
        var inCat = incomeExpenseBox.get(incomeKeys[i])!.category!;
        var incCatAmt= incomeExpenseBox.get(incomeKeys[i])!.amount!;
        if(categoryItems()[j]==inCat){
          sum = sum+incCatAmt;
        }
      }
      incCatSum.add(sum);
    }
    print("Incme category sum: $incCatSum");
  }

List categoryItems(){
  List<String> incCatList=[];
  List<int> incomeKeys = categoryBox.keys.
  cast<int>().where((key) => categoryBox.get(key)!.isIncome==true).toList();
  for(int i=0;i<incomeKeys.length;i++){
    var incCat = categoryBox.get(incomeKeys[i])!.category!;
    incCatList.add(incCat.toString());
  }
  print("income categories : $incCatList");
  return incCatList;
}


  Map<String, double> datasForPieChart = {
    "Category1": 5,
    "Category2": 3,
    "Category3": 7,
    "Category4": 2,
  };

  List<Color> colorList=[Colors.green,Colors.red,Colors.yellow,Colors.orangeAccent];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryBox = Hive.box<CategoryModel>(categoryBoxName);
    incomeExpenseBox =Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
    categoryItems();
    incTranscat();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Manager"),
        backgroundColor: Color(0xff005c99),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: pichartTitles(text: "INCOME"),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                height: 40,
                padding: const EdgeInsets.only(left: 10,right: 3),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff005c99),
                        width: 2,
                        style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(3))
                ),
                child: DropdownButton(
                  underline: Text(""),
                  style:  const TextStyle(
                    color: Colors.blue,
                    fontFamily: "BalsamiqSans",
                    fontSize: 17,
                  ),
                  focusColor:Colors.white,
                  hint: Text("Select Category"),
                  items: items.map((itemsname) {
                    return DropdownMenuItem(
                      value: itemsname,
                      child: Text(itemsname),
                    );
                  }).toList(),
                  onChanged:(String ?newValue){
                    setState(() {
                      dropdownValue =newValue!;
                    });
                  },
                  value: dropdownValue,
                ),
              ),

            ],
          ),
          divider(height: 40),
          piechart(
              piechartDatas: datasForPieChart,
              colorList: colorList
          ),
          divider(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: pichartTitles(text: "EXPENSE"),
          ),
          divider(height: 40),
          piechart(
            piechartDatas: datasForPieChart,
            colorList: colorList,
          ),
        ],
      ),
    );
  }
  Widget piechart({
    required Map<String,double> piechartDatas,
    required List<Color> colorList,
}){
    return PieChart(
      dataMap: piechartDatas,
      animationDuration: Duration(microseconds: 750),
      chartLegendSpacing: 40,
      chartRadius: MediaQuery.of(context).size.width*.4,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 60,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape:
        BoxShape.circle, legendTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }



}
