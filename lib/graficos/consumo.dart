import 'package:dashboard_tesis/components/Panel.dart';
import 'package:dashboard_tesis/graficos/NumeroDashboard.dart';
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
  double numero = 0;
  double porcentaje = 0;

  List<SumDataPoint> sumdata = [];

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
        startDate = newData.first.date;
        endDate = newData.last.date;
        data = newData;
        numero = endDate!.difference(startDate!).inDays.toDouble() * 0.19;
        porcentaje = numero / 255.0;
        // numero = widget.numDias.toDouble() * 0.19;
        sumdata = [
          SumDataPoint('Costo', data.fold(0.0, (p, e) => p + e.dinero),Colors.blue,"\$"), // Ejemplo de costo Kw/h
          SumDataPoint('Kw/h', data.fold(0.0, (p, e) => p + e.kwh),Colors.amber,"kW/h"), // Ejemplo de valor Kw/h
          SumDataPoint('O3', data.fold(0.0, (p, e) => p + e.ozono),Colors.green,"O3"), // Ejemplo de valor O3
        ];
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
        sumdata = [
          SumDataPoint('Costo', data.fold(0.0, (p, e) => p + e.dinero),Colors.blue,"\$"), // Ejemplo de costo Kw/h
          SumDataPoint('Kw/h', data.fold(0.0, (p, e) => p + e.kwh),Colors.amber,"kW/h"), // Ejemplo de valor Kw/h
          SumDataPoint('O3', data.fold(0.0, (p, e) => p + e.ozono),Colors.green,"O3"), // Ejemplo de valor O3
        ];
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
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Text(
                    //   'Consumo Total',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 30,
                    //   ),
                    // ),
                    // Text(
                    //   '\$ ${data.fold(0.0, (p, e) => p + e.dinero).toStringAsFixed(2)}',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 30,
                    //   ),
                    // ),
                    // Text(
                    //   ' ${data.fold(0.0, (p, e) => p + e.kwh).toStringAsFixed(2)}  Kw/h',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 30,
                    //   ),
                    // ),
                    // Text(
                    //   '${data.fold(0.0, (p, e) => p + e.ozono).toStringAsFixed(2)}  O3 ',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 30,
                    //   ),
                    // ),
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

                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(numberFormat: NumberFormat.decimalPattern()), // Formato de números con separadores de miles
                      series: <ChartSeries>[
                        ColumnSeries<SumDataPoint, String>(
                          dataSource: sumdata,
                          xValueMapper: (SumDataPoint sumdata, _) => sumdata.category,
                          yValueMapper: (SumDataPoint sumdata, _) => sumdata.value,
                          color: Colors.blue, // Color por defecto para todas las barras
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          dataLabelMapper: (SumDataPoint data, _) => '${data.simbolo} ${data.value.toStringAsFixed(2)}', // Agregar signo de dolar
                          pointColorMapper: (SumDataPoint sumdata, _) => sumdata.color,
                        ),
                      ],
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

        // NumeroDashboard(
        //   numDias: endDate!.difference(startDate!).inDays.toDouble(),
        // ),

        Panel(
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
        )





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
                                  numero = endDate!.difference(startDate!).inDays.toDouble() * 0.19;
                                  porcentaje = numero / 255.0;


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


class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class SumDataPoint {
  final String category;
  final double value;
  final Color color;
  final String simbolo;

  SumDataPoint(this.category, this.value, this.color, this.simbolo);
}