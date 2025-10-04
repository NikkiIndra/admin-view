import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/service/api_service.dart';
import '../../../routes/app_pages.dart';

class SignUpController extends GetxController {
  var isChecked = false.obs;
  final emailC = TextEditingController();
  final katasandiC = TextEditingController();
  final konfir_katasandiC = TextEditingController();
  final code_desa = TextEditingController();
  var loading = false.obs;
  @override
  void onClose() {
    code_desa.dispose();
    emailC.dispose();
    katasandiC.dispose();
    konfir_katasandiC.dispose();
    super.onClose();
  }

  void signupAdmin() async {
    loading.value = true;
    final res = await ApiService.post("signup-admin", {
      "code_desa": code_desa.text,
      "email": emailC.text,
      "katasandi": katasandiC.text,
    });
    loading.value = false;

    if (res["success"] == true) {
      Get.snackbar("Sukses", res["message"] ?? "Admin berhasil dibuat");
      // setelah berhasil daftar admin → arahkan ke login
      Get.offAllNamed(Routes.SIGNIN);
    } else {
      Get.snackbar("Gagal", res["message"] ?? "Signup error");
    }
  }
}
