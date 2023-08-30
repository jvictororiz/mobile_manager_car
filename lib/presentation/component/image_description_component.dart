import 'package:flutter/material.dart';

class ImageDescriptionComponent extends StatelessWidget {
  final String image;
  final String description;
  final Widget? widgetBottom;
  final double? sizeImage;
  final double sizeText;

  const ImageDescriptionComponent({Key? key, required this.image, required this.description, this.widgetBottom, this.sizeImage, this.sizeText = 18}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.0),
              child: Image.asset(image, width: sizeImage, height: sizeImage,),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle( fontSize: sizeText, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 15),
          widgetBottom ?? const SizedBox(),
        ],
      ),
    );
  }
}
