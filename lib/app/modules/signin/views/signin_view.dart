import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/textfromfield.dart';
import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 800;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: isSmallScreen
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Gambar pindah ke atas saat layar kecil
                          Image.asset(
                            "assets/images/pose2.png",
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(height: 20),
                          const _Logo(),
                          const SizedBox(height: 16),
                          const _FormContent(),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(32),
                        constraints: const BoxConstraints(
                          maxWidth: 900,
                          maxHeight: 600,
                        ),
                        child: Row(
                          children: [
                            // sisi kiri: logo
                            const Expanded(child: _Logo()),
                            const SizedBox(width: 20),
                            // sisi kanan: form + karakter
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  Obx(() {
                                    final bool shouldFloat =
                                        controller.isFieldActive.value;

                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      transform: Matrix4.translationValues(
                                        -100,
                                        shouldFloat ? 0 : -205,
                                        0,
                                      ),
                                      child: Image.asset(
                                        "assets/images/pose2.png",
                                        width: 250,
                                        height: 250,
                                      ),
                                    );
                                  }),
                                  const Center(child: _FormContent()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/logo.ico",
          width: isSmallScreen ? 100 : 200,
          height: isSmallScreen ? 100 : 200,
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Siskamling Digital!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.find<SigninController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => TextField(
                style: const TextStyle(color: Colors.white),
                controller: controller.emailC,
                focusNode: controller.emailFocus,
                decoration: InputDecoration(
                  hintText: "Username or Email",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  fillColor: Colors.white10,
                  filled: true,
                  errorText: controller.emailError.value.isEmpty
                      ? null
                      : controller.emailError.value,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextField(
                style: const TextStyle(color: Colors.white),
                controller: controller.katasandiC,
                focusNode: controller.passwordFocus,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  fillColor: Colors.white10,
                  filled: true,
                  errorText: controller.passwordError.value.isEmpty
                      ? null
                      : controller.passwordError.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    style: ButtonStyle(
                      iconColor: controller.isPasswordHidden.value
                          ? WidgetStatePropertyAll(Colors.black)
                          : WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () => controller.isPasswordHidden.toggle(),
                  ),
                ),
              ),
            ),

            _gap(),
            Obx(
              () => CheckboxListTile(
                value: controller.isChecked.value,
                onChanged: (value) {
                  controller.isChecked.value = value ?? false;
                },
                title: const Text('Remember me'),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: const EdgeInsets.all(0),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.login();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
