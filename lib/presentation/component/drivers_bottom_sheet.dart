import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/component/screen_builder_component.dart';
import '../../domain/model/car.dart';
import '../../domain/model/driver.dart';
import '../res/images.dart';
import '../res/strings.dart';
import 'button_action.dart';
import 'custom_input.dart';
import 'day_week_spinner.dart';
import 'image_description_component.dart';

class DriversBottomSheet extends StatefulWidget {
  final Function(Car, Driver, int, double) onTapChangeDriver;
  final Function(Car, Driver, int, double) onTapRegisterDriver;
  final Car car;
  final VoidCallback onRetry;
  final VoidCallback registerNewDriver;

  const DriversBottomSheet({super.key, required this.onTapChangeDriver, required this.onRetry, required this.registerNewDriver, required this.car, required this.onTapRegisterDriver});

  @override
  State<DriversBottomSheet> createState() => DriversBottomSheetState();
}

class DriversBottomSheetState extends State<DriversBottomSheet> {
  List<Driver> drivers = List.empty(growable: true);
  int daySelected = 1;
  bool isLoading = true;
  bool isEmpty = false;
  bool isSuccess = false;
  bool isError = false;
  final TextEditingController _fieldValueRent = TextEditingController();

  @override
  void initState() {
    _fieldValueRent.text = widget.car.valueDefaultRent.toString();
    super.initState();
  }

  @override
  void dispose() {
    _fieldValueRent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBuilderComponent(
      isLoading: isLoading,
      isSuccess: isSuccess,
      isEmpty: isEmpty,
      isError: isError,
      loadingWidget: Padding(
        padding: const EdgeInsets.all(80.0),
        child: const Center(child: CircularProgressIndicator()),
      ),
      successWidget: _getSuccess(),
      errorWidget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ImageDescriptionComponent(
          sizeImage: 200,
          description: "Erro ao buscar os motoristas, verifique a sua conexão.",
          image: Images.icErrorSorry,
          widgetBottom: ButtonAction(
            text: "Tentar novamente",
            onTap: () {
              widget.onRetry.call();
            },
          ),
        ),
      ),
      emptyWidget: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ImageDescriptionComponent(
          sizeImage: 200,
          description: "Nenhum motorista disponível",
          image: Images.icEmptyList,
          widgetBottom: ButtonAction(
            text: "Cadastrar novo",
            onTap: () {
              Navigator.pop(context);
              widget.registerNewDriver.call();
            },
          ),
        ),
      ),
    );
  }

  Widget _getImage(List<String> images) {
    var first = images.isNotEmpty ? images.first : "";
    return first.isNotEmpty
        ? ClipOval(
            child: Image.network(
              first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        : ClipOval(
            child: Image.asset(
              Images.icDriverDefault,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          );
  }

  _getSuccess() {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 64,
              height: 1,
              color: Colors.black38,
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Motoristas disponíveis:", style: TextStyle(fontFamily: "Roboto", fontSize: 16)),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.black54),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: drivers.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: CustomInput(
                                marginHorizontal: 16,
                                hintText: Strings.valueRentDefault,
                                prefixIcon: const Icon(Icons.monetization_on),
                                keyboardType: TextInputType.number,
                                controller: _fieldValueRent,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: DayOfWeekSpinner(onDaySelected: (currentDay) {
                                daySelected = currentDay;
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    var item = drivers[index - 1];
                    return Column(
                      children: [
                        const Divider(color: Colors.black54, height: 1),
                        SizedBox(height: 8),
                        ListTile(
                          leading: _getImage(item.images),
                          title: Text(item.name),
                          onTap: () {
                            Navigator.pop(context);
                            if (widget.car.carDriver == null) {
                              widget.onTapRegisterDriver.call(widget.car, item, daySelected, double.parse(_fieldValueRent.text));
                            } else {
                              widget.onTapChangeDriver.call(widget.car, item, daySelected, double.parse(_fieldValueRent.text));
                            }
                          },
                        ),
                        SizedBox(height: 8),
                        const Divider(color: Colors.black54, height: 1),
                      ],
                    );
                  }
                }),
          )
        ],
      ),
    );
  }

  void changeStatus(List<Driver> drivers, bool isSuccess, bool isLoading, bool isError, bool isEmpty) {
    setState(() {
      this.isEmpty = isEmpty;
      this.isSuccess = isSuccess;
      this.isLoading = isLoading;
      this.isError = isError;
      this.drivers = drivers;
    });
  }
}
