import 'package:dashboard_tesis/components/Panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NumeroDashboard extends StatefulWidget {
  @override
  _NumeroDashboardState createState() => _NumeroDashboardState();
}

class _NumeroDashboardState extends State<NumeroDashboard> {
  late DatabaseReference firebaseNumero;
  int numero = 0;

  @override
  void initState() {
    // firebaseNumero = FirebaseDatabase.instance.ref('dashboard/numero');

    // firebaseNumero.onValue.listen((DatabaseEvent event) {
    //   final data = event.snapshot.value;
    //   if (data != null) {
    //     setState(() {
    //       numero = data as int;
    //     });
    //   }
    // });

    setState(() {
      numero = 75;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double porcentaje = numero / 255.0; // Calcula el porcentaje actual

    return Panel(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SfCircularChart(
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Container(
                    child: Text(
                      numero.toString(),
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              series: <CircularSeries>[
                RadialBarSeries<_ChartData, String>(
                  dataSource: <_ChartData>[
                    _ChartData('Numero', porcentaje)
                  ],
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y * 255.0,
                  maximumValue: 255.0,
                  innerRadius: '80%', // Ajusta el radio interno para que sea un arco
                  // startAngle: 270, // Ajusta el ángulo de inicio a 270 grados (parte inferior del círculo)
                  // endAngle: 270 + (porcentaje * 360), // Calcula el ángulo final basado en el porcentaje
                  trackColor: Colors.greenAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}



class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
