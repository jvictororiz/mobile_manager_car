import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_manager_car/presentation/component/drivers_bottom_sheet.dart';
import 'package:mobile_manager_car/presentation/pages/car/controller/list_car_controller.dart';
import 'package:mobile_manager_car/presentation/pages/car/register_car_page.dart';
import 'package:mobile_manager_car/presentation/pages/car/state/list_car_state.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import '../../../domain/model/car.dart';
import '../../../domain/model/driver.dart';
import '../../component/button_action.dart';
import '../../component/message_util.dart';
import '../../component/screen_builder_component.dart';
import '../../res/images.dart';
import '../../res/strings.dart';
import '../driver/register_driver_page.dart';
import '../timelineCar/add_timeline_page.dart';
import '../timelineCar/timeline_page.dart';
import 'component/car_info_card.dart';
import 'component/cars_metric.dart';
import 'component/cart_item_component.dart';
import '../../component/image_description_component.dart';
import 'event/list_car_event.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  final ListCarController _controller = GetIt.I.get();
  final GlobalKey<DriversBottomSheetState> _bottomSheetKey = GlobalKey();

  @override
  void initState() {
    _configObservers();
    _controller.getAllCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListCarState state = _controller.state.value;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.primaryColor,
          elevation: 0,
          title: const Text(Strings.myCars),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.primaryColor,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async  {
        var update = await Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCarPage(car: null)));
        if (update) {
        _controller.getAllCars();
        }
          },
        ),
        body: ScreenBuilderComponent(
          isLoading: state.isLoading,
          isSuccess: state.showSuccess,
          isEmpty: state.isEmpty,
          isError: state.showError,
          errorWidget: _getLayoutError(),
          emptyWidget: _getLayoutEmpty(),
          successWidget: _getListLayout(state),
          loadingWidget: _getLoadingLayout(),
        ));
  }

  ListView _getListLayout(ListCarState state) {
    return ListView.builder(
      reverse: false,
      itemCount: state.cars.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SearchCard();
        }
        if (index == 1) {
          return CarMetrics(
            carsRunning: state.carsRunning,
            carsInMaintenance: state.carsInMaintenance,
            carsAvailable: state.carsAvailable,
            percentRunning: state.percentRunning,
          );
        }
        var car = state.cars[index - 2];
        return CarItemComponent(
          car: car,
          onTapAddHistory: (car) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTimelinePage(car: car)));
          },
          onTapSeeHistory: (car) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TimelinePage(car: car)));
          },
          onTapRemoveDriver: () {
            _controller.unlinkDriverInCar(car);
          },
          onTapChangeDriver: () {
            _controller.showModalListDrivers(car);
          },
          onTapEmptyDriver: () {
            _controller.showModalListDrivers(car);
          },
          onTap: (car) async {
            var update = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterCarPage(car: car)),
            );
            if (update) {
              _controller.getAllCars();
            }
          },
          onTapEditDriver: (idDriver) {
            _controller.tapOnEditDriver(idDriver);
          },
        );
      },
    );
  }

  Center _getLoadingLayout() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _getLayoutError() {
    return ImageDescriptionComponent(
      description: "Erro ao buscar os veículos, verifique a sua conexão.",
      image: Images.icErrorSorry,
      widgetBottom: ButtonAction(
        text: "Tentar novamente",
        onTap: () {
          _controller.getAllCars();
        },
      ),
    );
  }

  _getLayoutEmpty() {
    return const ImageDescriptionComponent(
      description: "Você ainda não cadastrou nenhum veículo",
      image: Images.icEmptyList,
    );
  }

  _showBottomSheetDrivers(Car car) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: DriversBottomSheet(
                key: _bottomSheetKey,
                car: car,
                onTapRegisterDriver: (car, driver, dayPayment, valueRent) {
                  _controller.linkDriverInCar(car, driver, dayPayment, valueRent);
                },
                onTapChangeDriver: (car, driver, dayPayment, valueRent) {
                  _controller.changeDriverInCar(car, driver, dayPayment, valueRent);
                },
                registerNewDriver: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterDriverPage(driver: null)));
                },
                onRetry: () {
                  _controller.loadAvailableDrivers();
                },
              ),
            ),
          ),
        );
      },
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
      if (action is OpenDriversModal) {
        _showBottomSheetDrivers(action.car);
      }
      if (action is OpenEditDriver) {
        var update = await Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterDriverPage(driver: action.driver)));
        if (update) {
          _controller.getAllCars();
        }
      }
      if (action is ChangeStatusDriversModal) {
        _bottomSheetKey.currentState?.changeStatus(action.drivers, action.isSuccess, action.isLoading, action.isError, action.isEmpty);
      }
    });
  }
}
