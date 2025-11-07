import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/service/api_service.dart';
import '../../news_uploads/controllers/news_uploads_controller.dart';

class CreateNewsController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  final titleC = TextEditingController();
  final descC = TextEditingController();
  final sourceC = TextEditingController(text: 'Admin Desa');

  final isLoading = false.obs;
  final images = <XFile>[].obs;

  void clear() {
    titleC.clear();
    descC.clear();
    sourceC.text = 'Admin Desa';
    images.clear();
    isLoading.value = false;
  }

  Future<void> uploadNews() async {
    if (titleC.text.isEmpty || descC.text.isEmpty) {
      Get.snackbar("Peringatan", "Judul dan deskripsi tidak boleh kosong");
      return;
    }

    final session = await ApiService.getAdminSession();
    print("🔍 Session Check:");
    print("   - admin_id: ${session['admin_id']}");
    print("   - role: ${session['role']}");
    print("   - desa_id: ${session['desa_id']}");

    if (session['admin_id']!.isEmpty || session['role']!.isEmpty) {
      Get.snackbar("Error", "Session tidak valid. Silakan login ulang.");
      return;
    }
    isLoading.value = true;
    // 🔍 DEBUG: Cek session sebelum upload
    try {
      // 🔹 Siapkan data form
      final fields = {
        'title': titleC.text.trim(),
        'description': descC.text.trim(),
        'source': sourceC.text.trim(),
      };

      // 🔹 Konversi XFile → File
      final files = images.map((x) => File(x.path)).toList();

      print("📤 Upload ke server:");
      print("   Fields: $fields");
      print("   Jumlah gambar: ${files.length}");

      // 🔹 Kirim ke server (multipart)
      // final response = await ApiService.uploadMultipart(
      //   "upload-news-with-image",
      //   fields,
      //   files,
      //   auth: true, // agar otomatis kirim X-User-Id & X-User-Role
      //   fileField: "image", // sesuaikan nama field di backend
      // );
      final response = await ApiService.uploadMultipart(
        "upload-news-with-image",
        fields,
        files,
        auth: true,
        fileField: "image",
      );

      isLoading.value = false;
      print("📡 Response dari server: $response");

      // 🔹 Validasi hasil response
      if (response["success"] == true ||
          response["status"] == 201 ||
          response["message"]?.toString().toLowerCase().contains("berhasil") ==
              true) {
        Get.snackbar("✅ Berhasil", "Berita berhasil diunggah ke server.");
        clear();

        // 🔁 Refresh daftar berita kalau controller-nya aktif
        if (Get.isRegistered<NewsUploadsController>()) {
          Get.find<NewsUploadsController>().fetchNews();
        }
      } else {
        final msg = response["message"] ?? "Gagal mengupload berita.";
        Get.snackbar("Gagal", msg.toString());
      }
    } catch (e) {
      isLoading.value = false;
      print("❌ Error upload: $e");
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }

  Future<void> pickImages() async {
    if (images.length >= 2) {
      Get.snackbar(
        "Batas Gambar",
        "Maksimal hanya 2 gambar yang dapat diunggah.",
      );
      return;
    }

    final List<XFile> picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      final newList = [...images, ...picked];
      images.value = newList.take(2).toList(); // batasi 2 gambar saja
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }
}
