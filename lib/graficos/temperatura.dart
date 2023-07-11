import 'package:dashboard_tesis/components/Panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class Temperatura extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Temperatura({Key? key}) : super(key: key);

  @override
  TemperaturaState createState() => TemperaturaState();
}

class TemperaturaState extends State<Temperatura> {
  double temperatura = 0.0;
  late DatabaseReference firebaseTemperatura;

  @override
  void initState() {
    firebaseTemperatura = FirebaseDatabase.instance.ref('dashboard/temperatura');

    firebaseTemperatura.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data is Map<String, dynamic>) {
        final temperaturaValue = data['valor'] as double?;
        if (temperaturaValue != null) {
          setState(() {
            temperatura = temperaturaValue;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              // width: 200,
              // height: 200,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${temperatura.toStringAsFixed(2)}°C',
                      style: TextStyle(fontSize: 48, color: Colors.white),
                    ),
                    Text(
                      "TEMPERATURA",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 20,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter, // Ajuste de alineación
              heightFactor: temperatura / 100,
              child: Container(
                decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

