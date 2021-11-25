import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/widgetsUI/textFields.dart';
import 'package:pie_chart/pie_chart.dart';


class Piechart extends StatefulWidget {
  @override
  _PiechartState createState() => _PiechartState();
}

class _PiechartState extends State<Piechart> {

  Map<String, double> datasForPieChart = {
    "Category1": 5,
    "Category2": 3,
    "Category3": 7,
    "Category4": 2,
  };

  List<Color> colorList=[Colors.green,Colors.red,Colors.yellow,Colors.orangeAccent];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Manager"),
        backgroundColor: Color(0xff005c99),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: PieChart(
              dataMap: datasForPieChart,
              animationDuration: Duration(microseconds: 750),
              chartLegendSpacing: 10,
              chartRadius: MediaQuery.of(context).size.width*.8,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.disc,
              ringStrokeWidth: 02,
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
            ),
          )
        ],
      ),
    );
  }
}
