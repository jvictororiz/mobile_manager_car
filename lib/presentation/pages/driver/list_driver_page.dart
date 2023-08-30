import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_manager_car/presentation/pages/driver/register_driver_page.dart';
import 'package:mobile_manager_car/presentation/pages/driver/state/list_driver_state.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import '../../../domain/model/driver.dart';
import '../../component/button_action.dart';
import '../../component/image_description_component.dart';
import '../../component/message_util.dart';
import '../../component/screen_builder_component.dart';
import '../../res/images.dart';
import '../../res/strings.dart';
import '../car/component/car_info_card.dart';
import 'component/item_driver_component.dart';
import 'controller/list_driver_controller.dart';
import 'event/list_driver_event.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({super.key});

  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  final ListDriverController _controller = GetIt.I.get();

  @override
  void initState() {
    _configObservers();
    _controller.getAllDrivers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListDriverState state = _controller.state.value;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: CustomColors.primaryColor,
          elevation: 0,
          title: const Text(Strings.drivers),
          actions: [
            IconButton(
              onPressed: () async {
                await _startRegisterOrUpdateDriver(context, null);
              },
              icon: const Icon(Icons.add),
            )
          ],
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

  Future<void> _startRegisterOrUpdateDriver(BuildContext context, Driver? driver) async {
    var update = await Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterDriverPage(driver: driver)));
    if (update) {
      _controller.getAllDrivers();
    }
  }

  Widget _getListLayout(ListDriverState state) {
    return Column(
      children: [
        SearchCard(),
        Expanded(
          child: GridView.count(
            mainAxisSpacing: 50,
            crossAxisCount:  2,
            children: List.generate(state.drivers.length, (index) {
              var driver = state.drivers[index];
              return ItemDriverComponent(
                driver: driver,
                onTap: () async {
                  await _startRegisterOrUpdateDriver(context, driver);
                },
              );
            }),
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
      description: "Erro ao buscar os motoristas, verifique a sua conexão.",
      image: Images.icErrorSorry,
      widgetBottom: ButtonAction(
        text: "Tentar novamente",
        onTap: () {
          _controller.getAllDrivers();
        },
      ),
    );
  }

  _getLayoutEmpty() {
    return Column(
      children: const [
        SizedBox(height: 60),
        ImageDescriptionComponent(
          description: "Você ainda não cadastrou nenhum motorista",
          image: Images.icEmptyList,
        ),
      ],
    );
  }

  void _configObservers() {
    _controller.state.addListener(() {
      setState(() {});
    });
    _controller.action.addListener(() {
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
