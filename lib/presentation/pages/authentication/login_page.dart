import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:mobile_manager_car/presentation/pages/bottomMenu/bottom_menu_page.dart';

import '../../component/custom_input.dart';
import '../../component/loading_button.dart';
import '../../component/message_util.dart';
import '../../component/password_field.dart';
import '../../res/custom_colors.dart';
import '../../res/strings.dart';
import 'controller/login_controller.dart';
import 'event/login_event.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = GetIt.I.get();
    _controller.verifyIfShowAuthenticateBiometrics();
    _configObservers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.action.dispose();
    _controller.state.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _controller.verifyIfShowAuthenticateBiometrics();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final state = _controller.state.value;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: const Text(Strings.appName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white, border: Border.all(width: 1, color: Colors.grey)),
              child: const Icon(
                Icons.person_sharp,
                size: 100,
                color: CustomColors.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 54),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomInput(
                      hintText: Strings.email,
                      prefixIcon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      controller: _loginController,
                    ),
                    const SizedBox(height: 16),
                    PasswordField(
                      onSubmitted: () => _controller.doLogin(_loginController.text, _passwordController.text),
                      controller: _passwordController,
                      hintText: Strings.password,
                    ),
                    const SizedBox(height: 32),
                    LoadingButton(
                      loading: state.isLoading,
                      textButton: Strings.login,
                      onTap: () {
                        _controller.doLogin(_loginController.text.trim(), _passwordController.text.trim());
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: state.showBiometric,
                      child: InkWell(
                        onTap: () async {
                          final LocalAuthentication localAuth = LocalAuthentication();
                          bool authenticated = await localAuth.authenticate(
                            localizedReason: Strings.biometricText,
                              options: const AuthenticationOptions(biometricOnly: true),
                              authMessages: const <AuthMessages>[
                                AndroidAuthMessages(
                                  biometricHint: Strings.verifyIdenty,
                                  signInTitle: Strings.authenticationBiometric,

                                  cancelButton: Strings.cancel,
                                ),
                                IOSAuthMessages(
                                  cancelButton: Strings.cancel,
                                ),
                              ]
                          );
                          _controller.doLoginBiometric(authenticated);
                        },
                        child: const Icon(
                          Icons.fingerprint,
                          size: 50,
                          color: CustomColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: const Text(Strings.textRegister),
                    ),
                  ],
                ),
              ),
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

    _controller.action.addListener(() {
      var action = _controller.action.value;
      if (action is ShowNegativeMessage) {
        MessageUtil.showNegativeMessage(action.message, context);
      }

      if (action is GoToHome) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BottomMenuPage()));
      }
    });
  }
}
