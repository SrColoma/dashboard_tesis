import 'package:dashboard_tesis/components/Panel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class Luces extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Luces({Key? key}) : super(key: key);

  @override
  LucesState createState() => LucesState();
}

class LucesState extends State<Luces> {
  List<LuzData> luzDataList = [];
  late DatabaseReference firebaseLuces;

  @override
  void initState() {
    firebaseLuces = FirebaseDatabase.instance.ref('dashboard/luces');

    firebaseLuces.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      final newDataList = (data as List<dynamic>).map((e) => LuzData.fromJson(e)).toList();
      setState(() {
        luzDataList = newDataList;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          
          children: [
            ...luzDataList.map((luzData) {
              double progress = luzData.luminosidad / 100.0;
              return Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: 190, // Tamaño fijo de 200
                  child: Container(
                    decoration: BoxDecoration(
                      color: luzData.estado == 1 ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.lightbulb, color: luzData.estado == 1 ? Colors.yellow : Colors.white,),
                              Text('LED ${luzData.id}', style: TextStyle(color: Colors.white, fontSize: 16)),
                              SizedBox(width: 30),
                              Text('Contador:'),
                              Text('${luzData.contador}', style: TextStyle(color: Colors.white,fontSize: 20)),
                            ],
                          ),
                          SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          SizedBox(height: 10),
                          Text('${luzData.luminosidad}%', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }


}

class LuzData {
  final int estado;
  final int id;
  final int contador;
  final int luminosidad;

  LuzData({
    required this.estado,
    required this.id,
    required this.contador,
    required this.luminosidad,
  });

  factory LuzData.fromJson(Map<String, dynamic> json) {
    return LuzData(
      estado: json['Estado'] as int,
      id: json['ID_Luz'] as int,
      contador: json['contador'] as int,
      luminosidad: json['luminosidad'] as int,
    );
  }
}
