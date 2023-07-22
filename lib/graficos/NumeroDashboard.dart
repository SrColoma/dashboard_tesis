import 'package:dashboard_tesis/components/Panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NumeroDashboard extends StatefulWidget {
  double numDias = 0;
  NumeroDashboard({
    Key? key,
    required this.numDias,
  }) : super(key: key);
  @override
  _NumeroDashboardState createState() => _NumeroDashboardState();
}

class _NumeroDashboardState extends State<NumeroDashboard> {
  late DatabaseReference firebaseNumero;
  double numero = 0;

  @override
  void initState() {
    // firebaseNumero = FirebaseDatabase.instance.ref('dashboard/Ahorro');

    // firebaseNumero.onValue.listen((DatabaseEvent event) {
    //   final data = event.snapshot.value as Map<dynamic, dynamic>;
    //   if (data != null) {
    //     setState(() {
    //       numero = data["valor"].toDouble() as double;
    //     });
    //   }
    // });
    setState(() {
      numero = widget.numDias.toDouble() * 0.19;
    });

    // setState(() {
    //   numero = 75;
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double porcentaje = numero / 255.0; // Calcula el porcentaje actual
    // double porcentaje = numero / 255.0; // Calcula el porcentaje actual

    return Panel(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ahorro',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
