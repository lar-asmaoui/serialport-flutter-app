// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomChart<T> extends StatelessWidget {
  final List<T> dataSource;
  String title;
  String unit;
  final String Function(T, int) xValueMapper;
  final num Function(T, int) yValueMapper;

  CustomChart({
    Key? key,
    required this.unit,
    required this.title,
    required this.dataSource,
    required this.xValueMapper,
    required this.yValueMapper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
      ),
      title: ChartTitle(text: title),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value} $unit',
          majorTickLines: const MajorTickLines(size: 0)),
      primaryXAxis: CategoryAxis(
          // axisLine: AxisLine(width: 0),

          ),
      series: <ChartSeries>[
        ColumnSeries<T, String>(
          dataSource: dataSource,
          xValueMapper: xValueMapper,
          yValueMapper: yValueMapper,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
