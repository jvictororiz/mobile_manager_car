import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/component/screen_builder_component.dart';
import 'package:mobile_manager_car/presentation/pages/home/state/home_state.dart';

import '../../../../domain/model/car.dart';
import '../../../component/button_action.dart';
import '../../../component/image_description_component.dart';
import '../../../res/images.dart';
import 'item_cart_component.dart';

class ListCarDriverComponent extends StatefulWidget {
  final String titlePage;
  final HomeCarState homeCarState;
  final VoidCallback onTapSeeAll;
  final Function(Car) onTapCar;
  final VoidCallback onRetry;

  const ListCarDriverComponent({Key? key, required this.titlePage, required this.onTapSeeAll, required this.homeCarState, required this.onRetry, required this.onTapCar}) : super(key: key);

  @override
  State<ListCarDriverComponent> createState() => _ListCarDriverComponentState();
}

class _ListCarDriverComponentState extends State<ListCarDriverComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(widget.titlePage, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ButtonAction(
                  onTap: () {
                    widget.onTapSeeAll.call();
                  },
                  text: "Ver todos",
                  icon: Icons.keyboard_arrow_right_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ScreenBuilderComponent(
            isLoading: widget.homeCarState.isLoading,
            isError: widget.homeCarState.isError,
            isSuccess: widget.homeCarState.isSuccess,
            isEmpty: widget.homeCarState.isEmpty,
            errorWidget: _buildError(),
            emptyWidget: _buildEmpty(),
            successWidget: _getSuccessList(widget.homeCarState.cars),
            loadingWidget: _buildLoading(),
          ),
        ],
      ),
    );
  }

  Padding _buildLoading() {
    return const Padding(
            padding: EdgeInsets.all(80.0),
            child: Center(child: CircularProgressIndicator()),
          );
  }

  Padding _buildEmpty() {
    return const Padding(
            padding: EdgeInsets.all(40.0),
            child: ImageDescriptionComponent(
              sizeImage: 60,
              sizeText: 14,
              description: "Nenhum veículo cadastrado ainda!",
              image: Images.icEmptyList,
            ),
          );
  }

  Padding _buildError() {
    return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ImageDescriptionComponent(
              sizeImage: 60,
              sizeText: 14,
              description: "Erro ao buscar os veículos, verifique a sua conexão e tente novamente.",
              image: Images.icErrorSorry,
              widgetBottom: ButtonAction(
                text: "Tentar novamente",
                onTap: () {
                  widget.onRetry.call();
                },
              ),
            ),
          );
  }

  Widget _getSuccessList(List<Car> cars) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        itemCount: cars.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var currentCar = cars[index];
          return InkWell(
            onTap: (){
              widget.onTapCar.call(currentCar);
            },
            child: ItemCartComponent(
              car: currentCar,
            ),
          );
        },
      ),
    );
  }
}
