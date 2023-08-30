import 'package:flutter/material.dart';

class MultiplesImages extends StatefulWidget {
  final List<Widget> images;
  final String defaultImage;
  final double heightImage;
  final double round;
  final ValueNotifier<int> currentPageNotifier;

  const MultiplesImages({Key? key, required this.images, required this.currentPageNotifier, required this.defaultImage, this.round = 0, this.heightImage = 200}) : super(key: key);

  @override
  State<MultiplesImages> createState() => _MultiplesImagesState();
}

class _MultiplesImagesState extends State<MultiplesImages> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: widget.heightImage,
      child: widget.images.isNotEmpty
          ? PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                var image = widget.images[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(widget.round),
                  child: image,
                );
              },
              itemCount: widget.images.length,
              pageSnapping: true,
              onPageChanged: (int index) {
                setState(() {
                  widget.currentPageNotifier.value = index;
                });
              },
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset(widget.defaultImage, opacity: const AlwaysStoppedAnimation(.5)),
            ),
    );
  }
}
