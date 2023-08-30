import 'package:flutter/material.dart';
import 'package:mobile_manager_car/domain/model/car.dart';

class TimelineHeaderCarComponent extends StatelessWidget {
  final Car car;

  const TimelineHeaderCarComponent({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Expanded(
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                car.getNameAndPlate(),
                style: TextStyle(color: Colors.white),
              ))),
    );
  }
}
