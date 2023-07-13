import 'package:dashboard_tesis/components/Panel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TimeSeriesChart extends StatelessWidget {
  final List<DataPoint> dataPoints;

  const TimeSeriesChart({Key? key, required this.dataPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Panel(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enableDoubleTapZooming: true,
              enablePanning: true,
            ),
            primaryXAxis: DateTimeAxis(
              labelStyle: TextStyle(color: Colors.white),
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 0),
              majorTickLines: MajorTickLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 200,
              interval: 50,
              labelStyle: TextStyle(color: Colors.white),
              majorGridLines: MajorGridLines(width: 1),
              axisLine: AxisLine(color: Colors.transparent),
              majorTickLines: MajorTickLines(size: 0),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
              LineSeries<DataPoint, DateTime>(
                dataSource: dataPoints,
                xValueMapper: (DataPoint data, _) => data.date,
                yValueMapper: (DataPoint data, _) => data.dinero,
                name: 'Costo',
                color: Colors.blue,
                // dataLabelSettings: DataLabelSettings(
                //   isVisible: true,
                //   textStyle: TextStyle(color: Colors.white),
                // ),
              ),
              LineSeries<DataPoint, DateTime>(
                dataSource: dataPoints,
                xValueMapper: (DataPoint data, _) => data.date,
                yValueMapper: (DataPoint data, _) => data.kwh,
                name: 'Kw/h',
                color: Colors.amber,
                // dataLabelSettings: DataLabelSettings(
                //   isVisible: true,
                //   textStyle: TextStyle(color: Colors.white),
                // ),
              ),
              LineSeries<DataPoint, DateTime>(
                dataSource: dataPoints,
                xValueMapper: (DataPoint data, _) => data.date,
                yValueMapper: (DataPoint data, _) => data.ozono,
                name: 'Ozono',
                color: Colors.green,
                // dataLabelSettings: DataLabelSettings(
                //   isVisible: true,
                //   textStyle: TextStyle(color: Colors.white),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataPoint {
  final DateTime date;
  final double dinero;
  final double kwh;
  final double ozono;

  DataPoint(this.date, this.dinero, this.kwh, this.ozono);
}
