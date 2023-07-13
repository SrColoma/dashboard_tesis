import 'package:dashboard_tesis/components/Panel.dart';
import 'package:dashboard_tesis/graficos/NumeroDashboard.dart';
import 'package:dashboard_tesis/graficos/consumo.dart';
import 'package:dashboard_tesis/graficos/luces.dart';
import 'package:dashboard_tesis/graficos/temperatura.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Consumo()),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Luces(prendidos: 1,area: "Area 1",)
              ),
              Expanded(
                flex: 2,
                child: Luces(prendidos: 0,area: "Area 2",)
              ),


              // Expanded(
              //   flex: 2,
              //   child: Panel(
              //     child: Center(
              //       child: Text('Gay el que lo lea'),
              //     ),
              //   )
              // ),


              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Temperatura()
                    ),
                    Expanded(
                      flex: 1,
                      child: NumeroDashboard()
                    ),

                  ],
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
  //   return Wrap(
  //     crossAxisAlignment: WrapCrossAlignment.center,
  //     children: [
  //       Consumo(),
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Luces(),
  //           Expanded(child: Temperatura()),
  //           Expanded(child: NumeroDashboard()),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
