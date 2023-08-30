import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/component/expand_painel.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import '../../../component/title_circle_graph.dart';
import '../../../res/strings.dart';
import '../../home/component/info_vertical_header_component.dart';

class CarMetrics extends StatelessWidget {
  final int carsRunning;
  final int carsInMaintenance;
  final int carsAvailable;
  final double percentRunning;
  const CarMetrics({Key? key, required this.carsRunning, required this.carsInMaintenance, required this.carsAvailable, required this.percentRunning}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpandablePanel(
          colorHeader: Colors.blue,
          round: 12,
          header: const Text(Strings.metrics, style: TextStyle(color: Colors.white, backgroundColor: Colors.transparent),),
          child:Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children:  [
                          const Divider(color: Colors.white),
                          Center(
                            child: InfoHeaderComponent(
                              color: Colors.lightBlueAccent,
                              title: Strings.rented,
                              icon: Icons.car_rental,
                              description: carsRunning.toString(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InfoHeaderComponent(
                            color: Colors.yellow,
                            title: Strings.notRented,
                            icon: Icons.car_rental,
                            description: carsAvailable.toString(),
                          ),
                          const SizedBox(height: 8),
                          InfoHeaderComponent(
                            color: Colors.red,
                            title: Strings.inMaintenance,
                            icon: Icons.car_rental,
                            description: carsInMaintenance.toString(),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 3,
                        child: TitleCircleGraph(title: Strings.carsRunner, value: percentRunning),
                      ),
                      const Expanded(flex: 1, child: SizedBox())
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
