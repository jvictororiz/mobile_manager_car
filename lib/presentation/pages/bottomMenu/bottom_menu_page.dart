import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_manager_car/presentation/pages/home/home_page.dart';
import 'package:mobile_manager_car/presentation/pages/profile/profile_page.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import '../../res/strings.dart';
import '../car/list_car_page.dart';
import '../driver/list_driver_page.dart';

class BottomMenuPage extends StatefulWidget {
  const BottomMenuPage({Key? key}) : super(key: key);

  @override
  State<BottomMenuPage> createState() => BottomMenuPageState();
}

abstract class OnChangePage {
  onChangePage(int page);
}

class BottomMenuPageState extends State<BottomMenuPage> implements OnChangePage {
  int _indexPage = 0;


  @override
  Widget build(BuildContext context) {
    var items = [HomePage(listenerPage: this), const CarListPage(), const DriverListPage(), const ProfilePage()];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: items[_indexPage],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: CustomColors.primaryColor,
          currentIndex: _indexPage,
          onTap: (currentIndex) {
            setState(() {
              _indexPage = currentIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: Strings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.car, size: 18),
              label: Strings.car,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.personal_injury),
              label: Strings.driver,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp),
              label: Strings.profile,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_indexPage == 0) {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(Strings.alert),
              content: const Text(Strings.confirmAlertExit),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(Strings.no),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(Strings.yes),
                ),
              ],
            ),
          )) ??
          false;
    } else {
      setState(() {
        _indexPage = 0;
      });
      return false;
    }
  }

  @override
  onChangePage(int page) {
    setState(() {
      _indexPage = page;
    });
  }
}
