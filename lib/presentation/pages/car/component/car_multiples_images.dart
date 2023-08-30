import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/presentation/component/button_action.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../../../res/images.dart';
import '../../../res/strings.dart';
import 'multiples_images.dart';

class CarMultiplesImages extends StatefulWidget {
  final List<String>? images;
  final List<File>? newImages;
  final String defaultImage;
  final VoidCallback? clickOnAddImage;
  final Function(int?, String?)? deleteIndexOrImage;

  const CarMultiplesImages({Key? key, required this.images, required this.newImages, this.clickOnAddImage, required this.defaultImage, this.deleteIndexOrImage}) : super(key: key);

  @override
  State<CarMultiplesImages> createState() => _CarMultiplesImagesState();
}

class _CarMultiplesImagesState extends State<CarMultiplesImages> {
  final currentPageNotifier = ValueNotifier<int>(0);
  final List<Widget> images = [];

  @override
  Widget build(BuildContext context) {
    var oldImages = widget.images?.map((e) => e.toImageWidget((idImage) {
      widget.deleteIndexOrImage?.call(null, idImage);
    }, null)) ?? [];
    var newImages = widget.newImages?.map((e) => e.toImageWidget((file){
      widget.deleteIndexOrImage?.call(widget.newImages!.indexOf(file), null);
    })) ?? [];
    images.clear();
    images.addAll(oldImages);
    images.addAll(newImages);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 6,
          child: Stack(
            children: [
              MultiplesImages(
                images: images,
                defaultImage: widget.defaultImage,
                currentPageNotifier: currentPageNotifier,
                round: 12,
              ),
              Positioned(
                left: 0,
                bottom: 5,
                right: 0,
                child: CirclePageIndicator(
                  size: 6.0,
                  selectedSize: 9.0,
                  dotColor: Colors.black,
                  selectedDotColor: Colors.blue,
                  itemCount:images.length,
                  currentPageNotifier: currentPageNotifier,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ButtonAction(
            text: Strings.addImage,
            icon: Icons.add,
            onTap: () {
              widget.clickOnAddImage?.call();
            })
      ],
    );
  }
}
