import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_manager_car/presentation/component/scroll_behavior.dart';
import 'package:mobile_manager_car/presentation/pages/authentication/login_page.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import 'core/di/module.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Module.init();
  runApp(const RentCar());
}

class RentCar extends StatelessWidget {
  const RentCar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: CustomColors.primaryColor,
        brightness: Brightness.light,
        dividerColor: Colors.white54,
        colorScheme: const ColorScheme.light(primary: CustomColors.primaryColor),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Manager Car',
      home: const SafeArea(child: LoginPage()),
    );
  }
}
