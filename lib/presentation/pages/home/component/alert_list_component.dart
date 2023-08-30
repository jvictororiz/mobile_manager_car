import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/component/text_icon.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import '../../../component/button_action.dart';
import '../../../component/image_description_component.dart';
import '../../../component/screen_builder_component.dart';
import '../../../res/images.dart';

class AlertListComponent extends StatefulWidget {
  final String title;
  final bool isLoading;
  final bool isError;
  final bool isEmpty;
  final bool isSuccess;
  final List<String> alerts;

  const AlertListComponent({super.key, required this.title, required this.alerts, required this.isLoading, required this.isError, required this.isEmpty, required this.isSuccess});

  @override
  _AlertListComponentState createState() => _AlertListComponentState();
}

class _AlertListComponentState extends State<AlertListComponent> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ScreenBuilderComponent(
            isLoading: widget.isLoading,
            isSuccess: widget.isSuccess,
            isError: widget.isError,
            isEmpty: widget.isEmpty,
            successWidget: _getSuccess(),
            errorWidget: _buildError(),
            emptyWidget: _buildEmptyLayout(),
            loadingWidget: _buildLoading(),
          ),
        ),
      ),
    );
  }

  Widget _getSuccess() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: IconText(
            textStyle: const TextStyle(fontWeight: FontWeight.bold, color: CustomColors.primaryColor),
            icon: Icons.taxi_alert_rounded,
            sizeIcon: 14,
            text: widget.title,
          ),
        ),
        const Divider(color: Colors.grey, height: 1),
        SizedBox(
          height: 80,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.alerts.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    widget.alerts[index],
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.alerts.length, (int index) {
              return Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  ImageDescriptionComponent _buildError() {
    return ImageDescriptionComponent(
      sizeImage: 60,
      sizeText: 14,
      description: "Erro ao buscar os lembretes, verifique a sua conexão e tente novamente.",
      image: Images.icErrorSorry
    );
  }

  Widget _buildEmptyLayout() {
    return ImageDescriptionComponent(
      sizeImage: 60,
      sizeText: 18,
      description: "Sem lembretes",
      image: Images.icEmptyList,
    );
  }

  Padding _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(80.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
