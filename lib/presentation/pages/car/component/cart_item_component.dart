import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/car_driver.dart';
import 'package:mobile_manager_car/presentation/component/button_action.dart';
import 'package:mobile_manager_car/presentation/pages/car/component/car_driver.dart';
import 'package:mobile_manager_car/presentation/pages/car/component/multiples_images.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

import '../../../../domain/model/car.dart';
import '../../../component/expand_painel.dart';
import '../../../res/images.dart';
import '../../driver/register_driver_page.dart';
import '../register_car_page.dart';
import 'car_driver_empty.dart';

class CarItemComponent extends StatefulWidget {
  final Car car;
  final Function(Car)? onTap;
  final Function(Car)? onTapSeeHistory;
  final Function(Car)? onTapAddHistory;
  final VoidCallback onTapChangeDriver;
  final VoidCallback onTapRemoveDriver;
  final Function(String) onTapEditDriver;
  final VoidCallback onTapEmptyDriver;

  const CarItemComponent({super.key, required this.car, this.onTap, required this.onTapEmptyDriver, required this.onTapChangeDriver, required this.onTapRemoveDriver, required this.onTapEditDriver, this.onTapSeeHistory, this.onTapAddHistory});

  @override
  State<CarItemComponent> createState() => _CarItemComponentState();
}

class _CarItemComponentState extends State<CarItemComponent> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  CarDriver? carDriver;

  @override
  void initState() {
    carDriver = widget.car.carDriver;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CarDriver? carDriver = widget.car.carDriver;
    var borderRadiusDefault = const BorderRadius.only(
      topLeft: Radius.circular(6),
      topRight: Radius.circular(6),
      bottomRight: Radius.circular(6),
      bottomLeft: Radius.circular(6),
    );

    return InkWell(
      onTap: () {
        widget.onTap?.call(widget.car);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                MultiplesImages(
                  images: widget.car.images.toImageWidgetList(null, () {
                    widget.onTap?.call(widget.car);
                  }),
                  currentPageNotifier: _currentPageNotifier,
                  defaultImage: Images.defaultCar,
                  round: 12,
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: CirclePageIndicator(
                    size: 6.0,
                    selectedSize: 9.0,
                    dotColor: Colors.black,
                    selectedDotColor: Colors.blue,
                    itemCount: widget.car.images.length,
                    currentPageNotifier: _currentPageNotifier,
                  ),
                ),
                Positioned(
                  bottom: -17,
                  right: 0,
                  child: Card(
                    color: Colors.blue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ExpandablePanel(
                      iconHide: Icons.keyboard_arrow_up_sharp,
                      heightHeader: 20,
                      colorHeader: Colors.blue,
                      round: 12,
                      child: carDriver != null
                          ? CarDriverComponent(
                              urlDriver: carDriver.urlImage,
                              driverDocument: carDriver.cpf,
                              driverName: carDriver.name,
                              onTapDriver: () {
                                widget.onTapEditDriver.call(carDriver.id);
                              },
                              onRemoverDriver: () {
                                widget.onTapRemoveDriver.call();
                              },
                              onTap: () {
                                widget.onTapChangeDriver.call();
                              },
                            )
                          : CarDriverEmpty(
                              onTap: () {
                                widget.onTapEmptyDriver.call();
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.car.getName(), style: const TextStyle(fontFamily: "Roboto", fontSize: 20.0)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.car.plate, style: const TextStyle(fontSize: 12.0, color: Colors.white)),
                            ),
                          ),
                          SizedBox(width: 15),
                          Text("-   ${widget.car.km.toString()} KM", style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.blue)))),
                              onPressed: () {
                                widget.onTapAddHistory?.call(widget.car);
                              },
                              child: Text("Novo status", style: TextStyle(color: Colors.blue, fontSize: 12))),
                          SizedBox(width: 8),
                          TextButton(onPressed: () {
                            widget.onTapSeeHistory?.call(widget.car);
                          }, child: Text("Ver Histórico", style: TextStyle(color: Colors.blue, fontSize: 12))),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
