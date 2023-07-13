import 'package:dashboard_tesis/components/Panel.dart';
import 'package:dashboard_tesis/graficos/TimeSeriesChart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';


class Consumo extends StatefulWidget {
  const Consumo({Key? key}) : super(key: key);

  @override
  _ConsumoState createState() => _ConsumoState();
}

class _ConsumoState extends State<Consumo> {
  List<DataPoint> data = [];
  late TooltipBehavior _tooltip;
  late DatabaseReference firebaseConsumo;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    endDate = DateTime.now();
    firebaseConsumo = FirebaseDatabase.instance.ref('dashboard/consumo');
    _tooltip = TooltipBehavior(enable: true);

    _listenToDataChanges();

    super.initState();
  }

  void _listenToDataChanges() {
    firebaseConsumo.onValue.listen((DatabaseEvent event) {
      final consumo = event.snapshot.value as Map<dynamic, dynamic>;
      final newData = consumo.entries.map((e) {
        final date = DateTime.parse(e.key);
        final dataPoint = DataPoint(
          date,
          e.value['Dinero'] as double,
          e.value['kwh'] as double,
          e.value['ozono'] as double,
        );

        return dataPoint;
      }).toList();

      setState(() {
        data = newData;
      });
    });
  }

  Future<void> _fetchDataInRange() async {
    if (startDate == null || endDate == null) {
      return;
    }

    final startAt = startDate!.toUtc().toIso8601String();
    final endAt = endDate!.toUtc().toIso8601String();

    final query = firebaseConsumo.orderByKey().startAt(startAt).endAt(endAt);
    final snapshot = await query.once();

    if (snapshot.snapshot.value != null) {
      final consumo = Map<String, dynamic>.from(snapshot.snapshot.value as Map<dynamic, dynamic>);
      final newData = consumo.entries.map((e) {
        final date = DateTime.parse(e.key);
        final dataPoint = DataPoint(
          date,
          e.value['Dinero'] as double,
          e.value['kwh'] as double,
          e.value['ozono'] as double,
        );

        return dataPoint;
      }).toList();

      setState(() {
        data = newData;
      });
    } else {
      setState(() {
        data = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Panel(
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Container(
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
                      '\$ ${data.fold(0.0, (p, e) => p + e.dinero).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Kw/h ${data.fold(0.0, (p, e) => p + e.kwh).toStringAsFixed(2)}',
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
                          Container(
                            width: 12,
                            height: 12,
                            color: Colors.green,
                          ),
                          Text('ozono', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    DateRangePicker(context),
                    SizedBox(height: 5),
                    Text(
                      startDate != null && endDate != null
                          ? 'Desde: ${DateFormat('dd/MM/yyyy').format(startDate!)} hasta: ${DateFormat('dd/MM/yyyy').format(endDate!)}'
                          : 'Desde: el principio',
                      style: TextStyle(color: Colors.white),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),

        TimeSeriesChart(
          dataPoints: data,
        ),
      ],
    );
  }

  Container DateRangePicker(BuildContext context) {
    return Container(
        child: ElevatedButton(
          onPressed: () async {
            DateTime? pickedStartDate = startDate;
            DateTime? pickedEndDate = endDate;

            showModalBottomSheet(
              // Centrado en la pantalla
              constraints: BoxConstraints(maxHeight: 900),
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Fecha inicial',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: CalendarDatePicker(
                            initialDate: pickedStartDate ?? startDate ?? DateTime.now(),
                            firstDate: DateTime(2021),
                            lastDate: DateTime.now(),
                            onDateChanged: (pickedDate) {
                              pickedStartDate = pickedDate;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Fecha final',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: CalendarDatePicker(
                            initialDate: pickedEndDate ?? endDate ?? DateTime.now(),
                            firstDate: pickedStartDate ?? startDate ?? DateTime(2021),
                            lastDate: DateTime.now(),
                            onDateChanged: (pickedDate) {
                              pickedEndDate = pickedDate;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (pickedEndDate != null && pickedEndDate!.isAfter(pickedStartDate!)) {
                                Navigator.of(context).pop();
                                setState(() {
                                  startDate = pickedStartDate;
                                  endDate = pickedEndDate;
                                  _fetchDataInRange();
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Rango inválido'),
                                      content: Text('por favor, seleccione un rango válido'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text('Filtrar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text('Rango de Fechas'),
        ),
      );
  }
}