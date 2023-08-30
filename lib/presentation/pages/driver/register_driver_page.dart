import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/presentation/component/custom_input.dart';
import 'package:mobile_manager_car/presentation/component/loading_button.dart';
import 'package:mobile_manager_car/presentation/component/options_image_bottom_sheet.dart';
import 'package:mobile_manager_car/presentation/pages/car/component/car_multiples_images.dart';
import 'package:mobile_manager_car/presentation/pages/driver/controller/register_driver_controller.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import '../../../domain/model/driver.dart';
import '../../component/message_util.dart';
import '../../component/select_image_bottom_sheet.dart';
import '../../res/images.dart';
import '../../res/strings.dart';
import 'event/register_driver_event.dart';

class RegisterDriverPage extends StatefulWidget {
  Driver? driver;

  RegisterDriverPage({
    super.key,
    required this.driver,
  });

  @override
  _RegisterDriverPageState createState() => _RegisterDriverPageState();
}

class _RegisterDriverPageState extends State<RegisterDriverPage> {
  bool updateBackScreen = false;
  final RegisterDriverController _controller = GetIt.I.get();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _fieldCpfController = TextEditingController();
  final TextEditingController _fieldPhoneNumberController = TextEditingController();
  List<File> newImages = List.empty(growable: true);

  @override
  void initState() {
    _configObservers();
    _controller.init(widget.driver);
    super.initState();
  }

  @override
  void dispose() {
    _fieldNameController.dispose();
    _fieldCpfController.dispose();
    _fieldPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state.value;
    if (state.driver != null) {
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
                defaultImage: Images.icDriverDefault,
                images: state.driver?.images,
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
                hintText: Strings.name,
                prefixIcon: const Icon(Icons.person),
                keyboardType: TextInputType.name,
                controller: _fieldNameController,
              ),
              CustomInput(
                marginTop: 12,
                marginHorizontal: 16,
                mask: "###.###.###-##",
                hintText: Strings.cpf,
                prefixIcon: const Icon(Icons.key),
                keyboardType: TextInputType.number,
                controller: _fieldCpfController,
              ),
              CustomInput(
                marginTop: 12,
                marginHorizontal: 16,
                mask: "(##) # ####-####",
                hintText: Strings.phoneNumber,
                prefixIcon: const Icon(Icons.phone_android),
                keyboardType: TextInputType.number,
                controller: _fieldPhoneNumberController,
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
      var driver = _controller.state.value.driver;
      if (driver != null) {
        _fieldNameController.text = driver.name;
        _fieldCpfController.text = driver.cpf;
        _fieldPhoneNumberController.text = driver.phoneNumber;
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
    var driver = _controller.state.value.driver;
    driver ??= Driver.empty();
    driver.name = _fieldNameController.text;
    driver.cpf = _fieldCpfController.text;
    driver.phoneNumber = _fieldPhoneNumberController.text;
    _controller.registerOrUpdate(driver, newImages);
  }
}
