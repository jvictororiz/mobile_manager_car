import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_manager_car/presentation/pages/car/component/car_info_card.dart';
import 'package:mobile_manager_car/presentation/pages/home/component/timeline_component.dart';

import '../../../domain/model/car.dart';
import '../../component/message_util.dart';
import '../../res/custom_colors.dart';
import '../timelineCar/event/timeline_event.dart';
import 'add_timeline_page.dart';
import 'controller/timeline_controller.dart';

class TimelinePage extends StatefulWidget {
  final Car? car;

  const TimelinePage({Key? key, required this.car}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TimelineController _controller = GetIt.I.get();

  @override
  void initState() {
    _configObservers();
    _controller.init(widget.car);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = _controller.state.value;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: CustomColors.primaryColor,
          elevation: 0,
          title: Text(state.titlePage),
        ),
        floatingActionButton: state.showButtonAdd
            ? FloatingActionButton(
                backgroundColor: CustomColors.primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTimelinePage(car: state.car!)));
                },
              )
            : const SizedBox(),
        body: Column(
          children: [
            const SearchCard(),
            Expanded(
              child: SingleChildScrollView(
                  child: TimelineComponent(
                isLoading: state.isLoading,
                isSuccess: state.isSuccess,
                isError: state.isError,
                isEmpty: state.isEmpty,
                list: state.histories,
                onRetry: () {
                  _controller.refresh();
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _configObservers() {
    _controller.state.addListener(() {
      setState(() {});
    });
    _controller.action.addListener(() async {
      var action = _controller.action.value;
      if (action is ShowNegativeMessage) {
        MessageUtil.showNegativeMessage(action.message, context);
      }
      if (action is ShowPositiveMessage) {
        MessageUtil.showPositiveMessage(action.message, context);
      }
    });
  }
}
