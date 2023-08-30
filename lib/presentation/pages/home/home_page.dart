import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_manager_car/presentation/component/week_component.dart';
import 'package:mobile_manager_car/presentation/pages/home/controller/home_controller.dart';
import 'package:week_of_year/week_of_year.dart';

import '../../component/message_util.dart';
import '../../res/custom_colors.dart';
import '../../res/strings.dart';
import '../bottomMenu/bottom_menu_page.dart';
import '../car/register_car_page.dart';
import '../home/event/home_event.dart';
import '../timelineCar/timeline_page.dart';
import 'component/alert_list_component.dart';
import 'component/header_home_component.dart';
import 'component/list_car_driver_component.dart';
import 'component/timeline_component.dart';

class HomePage extends StatefulWidget {
  final OnChangePage listenerPage;

  const HomePage({Key? key, required this.listenerPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  final HomeController _controller = GetIt.I.get();

  int weekYear = DateTime.now().weekOfYear;
  int year = DateTime.now().year;

  @override
  void initState() {
    _configObservers();
    _controller.init();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = _controller.state.value;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: CustomColors.primaryColor,
      ),
      child: SafeArea(
        child: Scaffold(
            body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: CustomColors.primaryColor,
              elevation: 0,
              snap: false,
              centerTitle: true,
              collapsedHeight: kToolbarHeight,
              expandedHeight: kToolbarHeight,
              excludeHeaderSemantics: true,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.all(15),
                title: Text("Home"),
                expandedTitleScale: 2,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    color: CustomColors.primaryColor,
                    child: WeekComponent(
                      onChangeWeekYear: (year, weekYear) {
                        this.year = year;
                        this.weekYear = weekYear;
                        _controller.refresh(year, weekYear);
                      },
                    ),
                  ),
                  HeaderHomeComponent(
                    homeMetricsState: state.homeMetricsState,
                  ),
                  AlertListComponent(
                    isLoading: state.homeReminderState.isLoading,
                    isSuccess: state.homeReminderState.isSuccess,
                    isError: state.homeReminderState.isError,
                    isEmpty: state.homeReminderState.isEmpty,
                    alerts: state.homeReminderState.reminders,
                    title: "Lembretes",
                  ),
                  ListCarDriverComponent(
                    titlePage: Strings.cars,
                    onTapSeeAll: () {
                      widget.listenerPage.onChangePage(1);
                    },
                    homeCarState: state.homeCarState,
                    onRetry: () {
                      _controller.getCarsByLimit(year, weekYear);
                    },
                    onTapCar: (car) async {
                      var update = await Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCarPage(car: car)));
                      if (update) {
                        _controller.getCarsByLimit(year, weekYear);
                      }
                    },
                  ),
                  TimelineComponent(
                    isLoading: state.homeHistoryState.isLoading,
                    isSuccess: state.homeHistoryState.isSuccess,
                    isError: state.homeHistoryState.isError,
                    isEmpty: state.homeHistoryState.isEmpty,
                    list: state.homeHistoryState.histories,
                    onRetry: () {
                      _controller.getCarsByLimit(year, weekYear);
                    },
                    onTapSeeAll: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TimelinePage(car: null)));
                    },
                  )
                ],
              ),
            )
          ],
        )),
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
