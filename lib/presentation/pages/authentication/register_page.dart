import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../component/custom_input.dart';
import '../../component/loading_button.dart';
import '../../component/message_util.dart';
import '../../component/password_field.dart';
import '../../res/custom_colors.dart';
import '../../res/strings.dart';
import '../bottomMenu/bottom_menu_page.dart';
import 'controller/register_controller.dart';
import 'event/register_event.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterController _controller = GetIt.I.get();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _fieldEmailController = TextEditingController();
  final TextEditingController _fieldPasswordController = TextEditingController();
  final TextEditingController _fieldConfirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _configObservers();
  }

  @override
  void dispose() {
    _fieldNameController.dispose();
    _fieldEmailController.dispose();
    _fieldPasswordController.dispose();
    _fieldConfirmPasswordController.dispose();
    _controller.state.dispose();
    _controller.action.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only( left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
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
                        hintText: Strings.name,
                        prefixIcon: const Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        controller: _fieldNameController,
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
                        hintText: Strings.email,
                        prefixIcon: const Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        controller: _fieldEmailController,
                      ),
                      const SizedBox(height: 16),
                      PasswordField(
                        controller: _fieldPasswordController,
                        hintText: Strings.password,
                      ),
                      const SizedBox(height: 16),
                      PasswordField(
                        onSubmitted: () => _register(),
                        controller: _fieldConfirmPasswordController,
                        hintText: Strings.confirmPassword,
                      ),
                      const SizedBox(height: 32),
                      LoadingButton(
                        loading: state.isLoading,
                        textButton: Strings.register,
                        onTap: () {
                          _register();
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BottomMenuPage()));
      }
    });
  }

  _register() {
    _controller.register(
        _fieldNameController.text.trim(),
        _fieldEmailController.text.trim(),
        _fieldPasswordController.text.trim(),
        _fieldConfirmPasswordController.text.trim()
    );
  }
}
