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
import 'package:intl/intl.dart';

class Piechart extends StatefulWidget {
  @override
  _PiechartState createState() => _PiechartState();
}

class _PiechartState extends State<Piechart> {
  static DateTime now = DateTime.now();
  int incrementCounter =0;
  String selectedMonth=DateFormat('MMMM').format(now);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(now.year,now.month,(now.day)-3),
    end: now,
  );
  Future  pickDateRange(BuildContext context)async{
    final   initialDateRange = DateTimeRange(
      start:  DateTime(now.year,now.month,(now.day)-3),
      end: now,
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year-3),
      lastDate: now,
      initialDateRange: dateRange,
    );
    if(newDateRange==null){
      return;
    }
    else{
      setState(() {
        dateRange =newDateRange;
        incomeCategories(isIncome: true);
        incomeCategories(isIncome: false);
      });
    }
  }
  DateTime monthlyDateSelector(){
    DateTime monthlyDatas = DateTime(now.year,(now.month)-incrementCounter,now.day);
    return monthlyDatas;
  }
  DateTime todaysDateSelector(){
    DateTime todaysDate = DateTime(now.year,now.month,now.day);
    return todaysDate;
  }
  DateTime yesterdaysDateSelector(){
    DateTime yesterdayDate = DateTime(now.year,now.month,(now.day)-1);
    return yesterdayDate;
  }

  late Box<IncomeExpenseModel> incomeExpenseBox;
  final items = ["All","Today","Yesterday","Monthly","Select Range"];
  String dropdownValues ="All";

  Map<String,double> incomeCategories({required bool isIncome}){
    if(dropdownValues=="All"){
     return pieChartDatas(
          incomeKeys:incomeExpenseBox.keys.cast<int>()
              .where((key)=>((incomeExpenseBox.get(key)!.isIncome == isIncome)
              && (incomeExpenseBox.get(key)!.
              createdDate.year==todaysDateSelector().year))).toList(),
              isIncome: isIncome
      );
   }
    else if(dropdownValues=="Today") {
      return pieChartDatas(
          incomeKeys: incomeExpenseBox.keys.cast<int>()
              .where((key)=>((incomeExpenseBox.get(key)!.isIncome == isIncome)
                      &&
              (incomeExpenseBox.get(key)!.createdDate==todaysDateSelector())) ).toList(),
          isIncome: isIncome);
    }
    else if(dropdownValues=="Yesterday") {
      return pieChartDatas(
          incomeKeys: incomeExpenseBox.keys.cast<int>()
              .where((key)=>((incomeExpenseBox.get(key)!.isIncome == isIncome)
              &&
              (incomeExpenseBox.get(key)!.createdDate==yesterdaysDateSelector())) ).toList(),
          isIncome: isIncome
      );
    }
    else if(dropdownValues=="Monthly") {
      return pieChartDatas(
          incomeKeys: incomeExpenseBox.keys.cast<int>()
              .where(
                  (key)=> ((incomeExpenseBox.get(key)!.isIncome == isIncome)
                      && (incomeExpenseBox.get(key)!.createdDate.month==monthlyDateSelector().month)
                      &&(incomeExpenseBox.get(key)!.createdDate.year==monthlyDateSelector().year)) ).toList(),
          isIncome: isIncome);
    }
    else{
      //List<int> incomeKeysRange;
      List <int> range=[];
      int difference = dateRange.end.difference(dateRange.start).inDays;
      for(int i =0;i<=difference; i++){
        range.addAll(incomeExpenseBox.keys.cast<int>().where((key) {
          return (incomeExpenseBox.get(key)!.createdDate==dateRange.start.add(Duration(days: i)))&&
              (incomeExpenseBox.get(key)!.isIncome == isIncome);
        }
        ).toList());
      }
      return pieChartDatas(
          incomeKeys: range,
          isIncome: isIncome);
    }

  }
  //------------------------------------------------------------------------------------------------------------------
  Map<String,double> pieChartDatas({required List<int> incomeKeys,required bool isIncome}){
    Map<String, double> datasForPieChart = {};
    List<String> incCatList=[];
    List<int> incomeKeysForCatType = incomeExpenseBox.keys.
    cast<int>().where((key) => incomeExpenseBox.get(key)!.isIncome==isIncome).toList();
    for(int i=0;i<incomeKeysForCatType.length;i++){
      var incCat = incomeExpenseBox.get(incomeKeysForCatType[i])!.category;
      incCatList.add(incCat.toString());
    }
    var incCatListDuplicateCatRemove=incCatList.toSet().toList();
    incCatList=incCatListDuplicateCatRemove.toList();
    print("income categories : $incCatList");

    for(int j=0;j<incCatList.length;j++){
      double sum=0;
      for(int i=0;i<incomeKeys.length;i++){
        var inCat = incomeExpenseBox.get(incomeKeys[i])!.category;
        var incCatAmt= incomeExpenseBox.get(incomeKeys[i])!.amount!;
        if(incCatList[j]==inCat){
          sum = sum+incCatAmt;

        }
      }
      datasForPieChart[incCatList[j]]=sum;
    }
    print("Incme category sum: $datasForPieChart");


    return datasForPieChart;

  }

  List<Color> colorList=[
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.yellow,
    Colors.blueAccent,
    Colors.amberAccent,
    Colors.teal,
    Colors.deepPurpleAccent,
    Colors.pinkAccent,
    Colors.deepOrangeAccent,
    Colors.lime,];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    incomeExpenseBox =Hive.box<IncomeExpenseModel>(incomeExpenseBoxName);
    incomeCategories(isIncome: true);
    incomeCategories(isIncome: false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Manager"),
        backgroundColor: Color(0xff005c99),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
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
                        dropdownValues =newValue!;
                        incomeCategories(isIncome: true);
                        incomeCategories(isIncome: false);
                      });
                    },
                    value: dropdownValues,
                  ),
                ),

              ],
            ),
            dropdownValues=="Monthly"?
            Container(
              //width: 176,
              margin: EdgeInsets.only(right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  timePeriodeChageIcon(
                      onPressed: (){
                        if(dropdownValues=="Monthly"){
                          setState(() {
                            if(incrementCounter>0){
                              incrementCounter=incrementCounter-1;
                              selectedMonth=DateFormat('MMMM').format(monthlyDateSelector());
                              incomeCategories(isIncome: true);
                              incomeCategories(isIncome: false);
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios,size: 25,)
                  ),
                  timePeriodeChageIcon(
                      onPressed: (){
                        if(dropdownValues=="Monthly"){
                          setState(() {
                            incrementCounter=incrementCounter+1;
                            selectedMonth=DateFormat('MMMM').format(monthlyDateSelector());
                            incomeCategories(isIncome: true);
                            incomeCategories(isIncome: false);
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded,size: 25,)
                    //arrow_back_ios
                  ),divider(width: 100),
                  Text(
                    selectedMonth,
                    style: TextStyle(fontFamily: "BalsamiqSans",fontSize: 17),),
                ],
              ),
            ): divider(height: 1),
            dropdownValues=="Select Range" ?
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10),
              child: dateRangeShow(
                  initialDate: DateFormat('MMMMd').format(dateRange.start),
                  finalDate: DateFormat('MMMMd').format(dateRange.end),
                  onTap: (){
                    pickDateRange(context);
                  }
              ),
            ):SizedBox(height: 1,),
            divider(height: 35),
          incomeCategories(isIncome: true).isNotEmpty ?
            piechart(
                piechartDatas: incomeCategories(isIncome: true),
                colorList: colorList
            ):Center(child: Text("No transactions yet")),
            divider(height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: pichartTitles(text: "EXPENSE"),
            ),
            divider(height: 37),
           incomeCategories(isIncome: false).isNotEmpty ?
                       piechart(
              piechartDatas: incomeCategories(isIncome: false),
              colorList: colorList,
            ):Center(child: Text("No transactions yet")),
          ],
        ),
      ),
    );
  }
  Widget piechart({
    required Map<String,double> piechartDatas,
    required List<Color> colorList,
}){
    return PieChart(
      dataMap: piechartDatas,
      animationDuration: Duration(milliseconds: 1500),
      chartLegendSpacing: 40,
      chartRadius: MediaQuery.of(context).size.width*.4,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 70,
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
