import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/component/screen_builder_component.dart';
import 'package:mobile_manager_car/presentation/pages/home/state/home_state.dart';

import '../../../../domain/model/historic_type.dart';
import '../../../component/button_action.dart';
import '../../../component/image_description_component.dart';
import '../../../res/images.dart';
import 'item_timeline_component.dart';

class TimelineComponent extends StatefulWidget {
  final bool isLoading;
  final bool isError;
  final bool isEmpty;
  final bool isSuccess;
  final List<HistoricType> list;
  final VoidCallback onRetry;
  final VoidCallback? onTapSeeAll;

  const TimelineComponent({super.key, required this.onRetry, required this.isLoading, required this.isError, required this.isEmpty, required this.isSuccess, required this.list,  this.onTapSeeAll});

  @override
  State<TimelineComponent> createState() => _TimelineComponentState();
}

class _TimelineComponentState extends State<TimelineComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Histórico", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                const Expanded(child: SizedBox()),
                widget.onTapSeeAll != null?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ButtonAction(
                    onTap: () {
                      widget.onTapSeeAll?.call();
                    },
                    text: "Ver todos",
                    icon: Icons.keyboard_arrow_right_rounded,
                  ),
                ): SizedBox()
              ],
            ),
            const SizedBox(height: 4),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ScreenBuilderComponent(
                  isLoading: widget.isLoading,
                  isError: widget.isError,
                  isSuccess: widget.isSuccess,
                  isEmpty: widget.isEmpty,
                  successWidget: _buildSuccess(widget.list),
                  loadingWidget: _buildLoading(),
                  emptyWidget: _buildEmptyLayout(),
                  errorWidget: _buildError(),
                ),
              ),
            ),
          ],
        ));
  }

  ImageDescriptionComponent _buildError() {
    return ImageDescriptionComponent(
      sizeImage: 60,
      sizeText: 14,
      description: "Erro ao buscar o histórico, verifique a sua conexão e tente novamente.",
      image: Images.icErrorSorry,
      widgetBottom: ButtonAction(
        text: "Tentar novamente",
        onTap: () {
          widget.onRetry.call();
        },
      ),
    );
  }

  Widget _buildEmptyLayout() {
    return ImageDescriptionComponent(
      sizeImage: 60,
      sizeText: 18,
      description: "Histórico vazio",
      image: Images.icEmptyList,
    );
  }

  Padding _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(80.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSuccess(List<HistoricType> items) {
    return Column(
      children: items.map((item) {
        var index = widget.list.indexOf(item);
        return TimelineItemWidget(
          item: item,
          isLastItem: items.length - 1 == index,
        );
      }).toList(growable: true),
    );
  }
}
