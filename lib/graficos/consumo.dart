import 'package:dashboard_tesis/components/Panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class Consumo extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Consumo({Key? key}) : super(key: key);

  @override
  ConsumoState createState() => ConsumoState();
}

class ConsumoState extends State<Consumo> {
  List<_ChartData> dataDinero = [];
  List<_ChartData> datakwh = [];
  late TooltipBehavior _tooltip;
  late DatabaseReference firebaseConsumo;

  @override
  void initState() {
    firebaseConsumo = FirebaseDatabase.instance.ref('dashboard/consumo');

    firebaseConsumo.onValue.listen((DatabaseEvent event) {
      final consumo = event.snapshot.value as Map<dynamic, dynamic>;
      final newDataDinero = consumo.entries.map((e) {
        final date = DateTime.parse(e.key);
        final dayOfWeek = DateFormat('EEEE').format(date);
        return _ChartData(dayOfWeek, e.value['Dinero'] as double);
      }).toList();
      final newDatakwh = consumo.entries.map((e) {
        final date = DateTime.parse(e.key);
        final dayOfWeek = DateFormat('EEEE').format(date);
        return _ChartData(dayOfWeek, e.value['kwh'] as double);
      }).toList();
      setState(() {
        dataDinero = newDataDinero;
        datakwh = newDatakwh;
      });
    });

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Panel(
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Container(
              // width: 200,
              // height: 200,
              // decoration: BoxDecoration(
              //   // color: Colors.blueGrey[800],
              //   border: Border.all(color: Colors.white, width: 1),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Consumo Total',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      '\$ ${dataDinero.fold(0.0, (p, e) => p + e.y).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Kw/h ${datakwh.fold(0.0, (p, e) => p + e.y).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Wrap(
                        spacing: 10,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.blue,
                          ),
                          Text('Costo', style: TextStyle(color: Colors.white)),
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.amber,
                          ),
                          Text('Kw/h', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
        Expanded(
          child: Panel(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCartesianChart(
                
                  // borderColor: Colors.white,
                      
                  primaryXAxis: CategoryAxis(
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
                      
                      
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<_ChartData, String>>[
                    ColumnSeries<_ChartData, String>(
                      dataSource: dataDinero,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      name: 'Costo',
                      color: Colors.blue,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    ColumnSeries<_ChartData, String>(
                      dataSource: datakwh,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      name: 'Kw/h',
                      color: Colors.amber,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
              ),
            ),
          ),
        ),
        
      ],
    );
  }
}




class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

    // DatabaseReference starCountRef = FirebaseDatabase.instance.ref('dashboard/consumo');

    // starCountRef.onValue.listen((DatabaseEvent event) {
    //     final data = event.snapshot.value;
    //     print(data);
    // });