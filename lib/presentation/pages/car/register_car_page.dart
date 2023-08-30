import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/presentation/component/custom_input.dart';
import 'package:mobile_manager_car/presentation/component/loading_button.dart';
import 'package:mobile_manager_car/presentation/component/options_image_bottom_sheet.dart';
import 'package:mobile_manager_car/presentation/pages/car/component/car_multiples_images.dart';
import 'package:mobile_manager_car/presentation/pages/car/controller/register_car_controller.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import '../../../domain/model/car.dart';
import '../../component/message_util.dart';
import '../../component/select_image_bottom_sheet.dart';
import '../../res/images.dart';
import '../../res/strings.dart';
import 'event/register_car_event.dart';

class RegisterCarPage extends StatefulWidget {
  Car? car;

  RegisterCarPage({
    super.key,
    required this.car,
  });

  @override
  _RegisterCarPageState createState() => _RegisterCarPageState();
}

class _RegisterCarPageState extends State<RegisterCarPage> {
  bool updateBackScreen = false;
  final RegisterCarController _controller = GetIt.I.get();
  final TextEditingController _fieldModelController = TextEditingController();
  final TextEditingController _fieldValueDefaultController = TextEditingController();
  final TextEditingController _fieldYearController = TextEditingController();
  final TextEditingController _fieldKmController = TextEditingController();
  final TextEditingController _fieldPlateController = TextEditingController();
  final TextEditingController _fieldMaxKmController = TextEditingController();
  List<File> newImages = List.empty(growable: true);

  @override
  void initState() {
    _configObservers();
    _controller.init(widget.car);
    super.initState();
  }

  @override
  void dispose() {
    _fieldModelController.dispose();
    _fieldYearController.dispose();
    _fieldKmController.dispose();
    _fieldPlateController.dispose();
    _fieldMaxKmController.dispose();
    _fieldValueDefaultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state.value;
    if (state.car != null) {
      _setFields();
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, updateBackScreen);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: CustomColors.primaryColor,
            elevation: 0,
            title: Text(state.titleToolbar),
          ),
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              CarMultiplesImages(
                defaultImage: Images.defaultCar,
                images: state.car?.images,
                newImages: newImages,
                deleteIndexOrImage: (indexFile, idImage) {
                  _showBottomSheetOptionsImage(indexFile, idImage);
                },
                clickOnAddImage: () {
                  _showNewImage(context);
                },
              ),
              CustomInput(
                marginTop: 18,
                marginHorizontal: 16,
                hintText: Strings.model,
                prefixIcon: const Icon(Icons.car_crash_rounded),
                keyboardType: TextInputType.name,
                controller: _fieldModelController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CustomInput(
                        marginTop: 12,
                        marginHorizontal: 6,
                        mask: "####/####",
                        hintText: Strings.year,
                        prefixIcon: const Icon(Icons.car_crash_rounded),
                        keyboardType: TextInputType.number,
                        controller: _fieldYearController,
                      ),
                    ),
                    Expanded(
                      child: CustomInput(
                        isEnable: state.editKmEnable,
                        marginTop: 12,
                        marginHorizontal: 6,
                        hintText: Strings.km,
                        prefixIcon: const Icon(Icons.confirmation_num_sharp),
                        keyboardType: TextInputType.number,
                        controller: _fieldKmController,
                      ),
                    ),
                  ],
                ),
              ),
              CustomInput(
                marginTop: 12,
                marginHorizontal: 16,
                hintText: Strings.plate,
                prefixIcon: const Icon(Icons.abc),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.characters,
                controller: _fieldPlateController,
              ),
              CustomInput(
                marginTop: 12,
                marginHorizontal: 16,
                hintText: Strings.maxKm,
                prefixIcon: const Icon(Icons.confirmation_num_sharp),
                keyboardType: TextInputType.number,
                controller: _fieldMaxKmController,
              ),
              CustomInput(
                marginTop: 12,
                marginHorizontal: 16,
                hintText: Strings.valueDefault,
                prefixIcon: const Icon(Icons.monetization_on),
                keyboardType: TextInputType.number,
                controller: _fieldValueDefaultController,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: LoadingButton(
                    onTap: () {
                      _registerOrUpdate();
                    },
                    loading: state.isLoading,
                    textButton: Strings.save),
              )
            ],
          )),
    );
  }

  void _showNewImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return SelectImageBottomSheet(
          onTapCamera: () {
            _getFromCamera();
          },
          onTapGallery: () {
            _getFromGallery();
          },
        );
      },
    );
  }

  void _showBottomSheetOptionsImage(int? indexFile, String? urlImage) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return OptionsImageBottomSheet(
          onTapDelete: () {
            if (indexFile != null) {
              setState(() {
                newImages.removeAt(indexFile);
              });
            }
            if (urlImage != null) {
              updateBackScreen = true;
              _controller.deleteImageCar(urlImage);
            }
          },
          onTapDownload: () async {
            if (urlImage != null) {
              _controller.saveImageGallery(urlImage);
            }
          },
        );
      },
    );
  }

  _getFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      setState(() {
        updateBackScreen = true;
        newImages.addAll(images.toFiles());
      });
    } catch (error) {
      print(error);
    }
  }

  _getFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          updateBackScreen = true;
          newImages.add(image.toFile());
        });
      }
    } catch (error) {
      print("error: $error");
    }
  }

  void _setFields() {
    setState(() {
      var car = _controller.state.value.car;
      if (car != null) {
        _fieldModelController.text = car.model;
        _fieldMaxKmController.text = car.maxKm.toString();
        _fieldYearController.text = car.year;
        _fieldKmController.text = car.km.toString();
        _fieldPlateController.text = car.plate;
        _fieldValueDefaultController.text = car.valueDefaultRent.toString();
      }
    });
  }

  void _configObservers() {
    _controller.state.addListener(() {
      setState(() {});
    });
    _controller.action.addListener(() {
      var action = _controller.action.value;
      if (action is ShowNegativeMessage) {
        MessageUtil.showNegativeMessage(action.message, context);
      }
      if (action is ShowPositiveMessage) {
        MessageUtil.showPositiveMessage(action.message, context);
      }
      if (action is FinishScreen) {
        Navigator.pop(context, true);
      }
    });
  }

  void _registerOrUpdate() {
    var car = _controller.state.value.car;
    car ??= Car.empty();
    car.model = _fieldModelController.text.trim();
    car.valueDefaultRent = double.parse(_fieldValueDefaultController.text.trim());
    car.maxKm = double.parse(_fieldMaxKmController.text.trim());
    car.year = _fieldYearController.text.trim();
    car.km = double.parse(_fieldKmController.text.trim());
    car.plate = _fieldPlateController.text.trim();
    _controller.registerOrUpdate(car, newImages);
  }
}
