import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';

import '../../../../domain/model/car.dart';
import '../../../component/diagonal_widget.dart';
import '../../../component/text_icon.dart';
import '../../../res/images.dart';

class ItemCartComponent extends StatelessWidget {
  final Car car;

  const ItemCartComponent({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    var imageUrl = car.images.isNotEmpty ? car.images.first : null;

    return Stack(
      children: [
        SizedBox(
          width: 175,
          child: Card(
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(25),
                  ),
                  child: Container(
                    height: 80,
                    color: Colors.grey,
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.fitWidth,
                          )
                        : Image.asset(
                            Images.defaultCar,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconText(
                        text: car.getName(),
                        icon: Icons.car_rental_sharp,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      IconText(
                        icon: FontAwesomeIcons.vrCardboard,
                        text: car.plate,
                        textStyle: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      IconText(
                        icon: Icons.account_circle_sharp,
                        text: car.carDriver?.name ?? "Sem motorista",
                        textStyle: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: DiagonalWidget(
            color: car.getColorTicket(),
            text: car.getStatus(),
          ),
        )
      ],
    );
  }
}
