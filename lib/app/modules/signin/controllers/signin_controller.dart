import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/api_service.dart';
import '../../../routes/app_pages.dart';

class SigninController extends GetxController {
  var isChecked = false.obs;
  var isPasswordHidden = true.obs;
  var loading = false.obs;

  final isFieldActive = false.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;

  final emailC = TextEditingController();
  final katasandiC = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();

    // Bersihkan error saat mengetik
    emailC.addListener(() {
      if (emailError.isNotEmpty) emailError.value = '';
    });
    katasandiC.addListener(() {
      if (passwordError.isNotEmpty) passwordError.value = '';
    });

    // Bersihkan error saat field di-klik
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) emailError.value = '';
    });
    passwordFocus.addListener(() {
      if (passwordFocus.hasFocus) passwordError.value = '';
    });
  }

  bool validateFields() {
    bool valid = true;

    if (emailC.text.isEmpty) {
      emailError.value = "Please enter your email";
      valid = false;
    } else if (!RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
    ).hasMatch(emailC.text)) {
      emailError.value = "Please enter a valid email";
      valid = false;
    }

    if (katasandiC.text.isEmpty) {
      passwordError.value = "Please enter your password";
      valid = false;
    } else if (katasandiC.text.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
      valid = false;
    }

    return valid;
  }

  Future<void> login() async {
    if (!validateFields()) return;

    try {
      loading.value = true;

      final res = await ApiService.post("login", {
        "email": emailC.text.trim(),
        "katasandi": katasandiC.text,
      });

      loading.value = false;

      if (res["success"] == true && res["access_token"] != null) {
        final token = res["access_token"];
        await ApiService.saveToken(token);
        final user = res["user"];

        if (user["role"] == "admin") {
          Get.offAllNamed(Routes.NAVBAR, arguments: user);
        } else {
          Get.offAllNamed("/user-view", arguments: user);
        }
      } else {
        Get.snackbar("Gagal", res["message"] ?? "Login error");
      }
    } catch (e, s) {
      loading.value = false;
      print("❌ Error saat login: $e");
      print(s);
      Get.snackbar("Error", "Server sedang tidur: $e");
    }
  }
}
