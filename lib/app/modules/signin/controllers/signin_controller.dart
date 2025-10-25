import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  final formKey = GlobalKey<FormState>();

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

  @override
  void onClose() {
    emailC.dispose();
    katasandiC.dispose();
    super.onClose();
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

      if (res["success"] == true && res["user"] != null) {
        final user = res["user"];

        print("🧾 Data user login: $user");

        // Ambil nilai dengan aman (pastikan tidak null dan dalam string)
        final adminId = (user["id"] ?? user["user_id"] ?? "").toString();
        final role = (user["role"] ?? "").toString();
        final desaId = (user["desa_id"] ?? user["desaId"] ?? "").toString();
        final email = (user["email"] ?? "").toString();

        // Cegah simpan kosong
        if (adminId.isEmpty || role.isEmpty) {
          Get.snackbar("Login Error", "Data user tidak lengkap dari server.");
          return;
        }

        // Simpan sesi
        await ApiService.saveAdminSession({
          "id": adminId,
          "role": role,
          "email": email,
          "desa_id": desaId,
        });
        // 🔍 VERIFIKASI: Cek session setelah disimpan
        final savedSession = await ApiService.getAdminSession();
        print("✅ Session setelah disimpan:");
        print("   - admin_id: ${savedSession['admin_id']}");
        print("   - role: ${savedSession['role']}");
        print("   - desa_id: ${savedSession['desa_id']}");
        final box = GetStorage();
        box.write('is_logged_in', true);
        box.write('user_role', role);

        print("✅ Session disimpan: id=$adminId, role=$role, desa=$desaId");

        // Arahkan sesuai role
        if (role == "admin") {
          print(
            "✅ Session benar-benar tersimpan: ${await ApiService.getAdminSession()}",
          );
          Get.offAllNamed(Routes.NAVBAR);
        }
      } else {
        Get.snackbar(
          "Login Gagal",
          res["message"] ?? "Email atau kata sandi salah",
        );
      }
    } catch (e, s) {
      loading.value = false;
      print("❌ Error saat login: $e");
      print(s);
      Get.snackbar("Error", "Tidak dapat terhubung ke server: $e");
    }
  }
}
