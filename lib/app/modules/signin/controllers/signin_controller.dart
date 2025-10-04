import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/service/api_service.dart';

class SigninController extends GetxController {
  var isChecked = false.obs;
  var isPasswordHidden = true.obs;
  var loading = false.obs;

  final emailC = TextEditingController();
  final katasandiC = TextEditingController();

  @override
  void onClose() {
    emailC.dispose();
    katasandiC.dispose();
    super.onClose();
  }

  void login() async {
    loading.value = true;
    final res = await ApiService.post("login", {
      "email": emailC.text,
      "katasandi": katasandiC.text,
    });
    loading.value = false;

    if (res["success"] == true && res["access_token"] != null) {
      await ApiService.saveToken(res["access_token"]);

      final user = res["user"];
      if (user["role"] == "admin") {
        Get.offAllNamed("/admin-view", arguments: user);
      } else {
        Get.offAllNamed("/user-view", arguments: user);
      }
    } else {
      Get.snackbar("Gagal", res["message"] ?? "Login error");
    }
  }
}
