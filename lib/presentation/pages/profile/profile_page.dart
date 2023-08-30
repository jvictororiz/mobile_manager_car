import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_manager_car/presentation/component/custom_input.dart';
import 'package:mobile_manager_car/presentation/pages/profile/state/profile_state.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import '../../component/message_util.dart';
import '../../res/strings.dart';
import 'controller/profile_controller.dart';
import 'event/profile_event.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePagePageState createState() => _ProfilePagePageState();
}

class _ProfilePagePageState extends State<ProfilePage> {
  final ProfileController _controller = GetIt.I.get();

  @override
  void initState() {
    _configObservers();
    _controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileState state = _controller.state.value;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.primaryColor,
        elevation: 0,
        title: const Text(Strings.myCars),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color:Colors.white,
              elevation: 8 ,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person_sharp, size: 60),
                    ),
                    SizedBox(height: 10),
                    Text(
                      state.nameUser,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      state.emailUser,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          Spacer(),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
               _controller.exit();
              },
              child: Text('Sair'),
            ),
          ),
        ],
      ),
    );
  }

  void _configObservers() {
    _controller.state.addListener(() {
      setState(() {});
    });
    _controller.action.addListener(() async {
      var action = _controller.action.value;
      if (action is ProfileEvent) {
        Navigator.pop(context);
      }
    });
  }
}
