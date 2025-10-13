import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/routes/app_pages.dart';
import '../../../data/service/api_service.dart';

class SigninController extends GetxController {
  var isChecked = false.obs;
  var isPasswordHidden = true.obs;
  var loading = false.obs;
  var isFieldActive = false.obs;

  final emailC = TextEditingController();
  final katasandiC = TextEditingController();

  @override
  void onClose() {
    emailC.dispose();
    katasandiC.dispose();
    super.onClose();
  }

  Future<void> login() async {
    try {
      loading.value = true;

      final res = await ApiService.post("login", {
        "email": emailC.text.trim(),
        "katasandi": katasandiC.text,
      });

      loading.value = false;

      if (res["success"] == true && res["access_token"] != null) {
        final token = res["access_token"];
        print("✅ Token diterima dari server: $token");

        // simpan token ke secure storage
        await ApiService.saveToken(token);
        print("🔐 Token disimpan ke secure storage");

        // ambil data user dari response
        final user = res["user"];
        print("👤 Login sebagai: ${user["nama_lengkap"]} (${user["role"]})");

        // arahkan halaman sesuai role
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
      print("Stack trace: $s");
      Get.snackbar("Error", "Server sedang tidur: $e");
    }
  }
}
