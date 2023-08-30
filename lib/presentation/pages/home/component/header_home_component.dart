import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/component/screen_builder_component.dart';
import '../../../component/button_action.dart';
import '../../../component/image_description_component.dart';

import '../../../component/title_circle_graph.dart';
import '../../../res/images.dart';
import '../state/home_state.dart';
import 'info_vertical_header_component.dart';

class HeaderHomeComponent extends StatelessWidget {
  final HomeMetricsState homeMetricsState;

  const HeaderHomeComponent({Key? key, required this.homeMetricsState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(45),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            elevation: 6,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: ScreenBuilderComponent(
                  isLoading: homeMetricsState.isLoading,
                  isSuccess: homeMetricsState.isSuccess,
                  isEmpty: homeMetricsState.isEmpty,
                  isError: homeMetricsState.isError,
                  errorWidget: _getLayoutError(),
                  emptyWidget: _getLayoutEmpty(),
                  loadingWidget: _getLoadingLayout(),
                  successWidget: _getSuccess(),
                )),
          ),
        ),
      ],
    );
  }

  Center _getLoadingLayout() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _getLayoutError() {
    return ImageDescriptionComponent(
      sizeImage: 90,
      description: "Erro ao buscar as métricas, tente novamente mais tarde",
      image: Images.icErrorSorry,
    );
  }

  _getLayoutEmpty() {
    return const ImageDescriptionComponent(
      sizeImage: 90,
      description: "Você ainda não possui métricas registradas",
      image: Images.icEmptyList,
    );
  }

  Widget _getSuccess() {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                Center(
                  child: InfoHeaderComponent(
                    color: Colors.lightBlueAccent,
                    title: "Lucro",
                    icon: Icons.monetization_on,
                    description: "RS ${homeMetricsState.positiveValue}",
                  ),
                ),
                SizedBox(height: 15),
                InfoHeaderComponent(
                  color: Colors.red,
                  title: "Prejuizo",
                  icon: Icons.money,
                  description: "RS  ${homeMetricsState.negativeValue}",
                ),
              ],
            ),
            Expanded(
                child: TitleCircleGraph(
                  title: "Recebimentos",
                  value: (homeMetricsState.positiveValue / (homeMetricsState.positiveValue + homeMetricsState.negativeValue)) * 100,
                ))
          ],
        ),
        SizedBox(height: 16),
        Divider(color: Colors.grey, height: 1),
      ],
    );
  }
}
