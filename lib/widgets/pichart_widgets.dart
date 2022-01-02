import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidgets {
  Widget piechart({
    required Map<String, double> piechartDatas,
    required List<Color> colorList,
    required context,
  }) {
    return PieChart(
      dataMap: piechartDatas,
      animationDuration: Duration(milliseconds: 1500),
      chartLegendSpacing: 50,
      chartRadius: MediaQuery.of(context).size.width * .6,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 80,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendShape: BoxShape.rectangle,
        legendTextStyle: TextStyle(
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
