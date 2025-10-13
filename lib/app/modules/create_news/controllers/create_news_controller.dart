import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../news_uploads/controllers/news_uploads_controller.dart';

class CreateNewsController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final titleC = TextEditingController();
  final descC = TextEditingController();
  final sourceC = TextEditingController(text: 'Admin Desa');

  final isLoading = false.obs;
  final images = <XFile>[].obs;
  final storage = const FlutterSecureStorage();

  void clear() {
    titleC.clear();
    descC.clear();
    sourceC.text = 'Admin Desa';
    images.clear();
    isLoading.value = false;
  }

  Future<void> uploadNews() async {
    try {
      isLoading.value = true;

      final token = await storage.read(key: "access_token");
      final uri = Uri.parse("http://192.168.0.99:5000/upload-news-with-image");

      var request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['title'] = titleC.text;
      request.fields['description'] = descC.text;
      request.fields['source'] = sourceC.text;

      // Jika ada gambar
      for (var i = 0; i < images.length && i < 2; i++) {
        final file = images[i];
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

      final resp = await request.send();
      final respBody = await resp.stream.bytesToString();
      print("📡 Response: ${resp.statusCode} => $respBody");

      isLoading.value = false;

      if (resp.statusCode == 201) {
        Get.snackbar("✅ Berhasil", "Berita berhasil disimpan ke messages");

        // 🔹 Kosongkan field & gambar
        clear();

        // 🔹 Refresh daftar berita realtime
        if (Get.isRegistered<NewsUploadsController>()) {
          Get.find<NewsUploadsController>().fetchNews();
        }
      } else {
        Get.snackbar("Gagal", "Gagal mengupload berita: $respBody");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Server error: $e");
    }
  }

  Future<void> pickImages() async {
    // Batasi maksimal 2 gambar
    if (images.length >= 2) {
      Get.snackbar(
        'Batas Gambar',
        'Maksimal hanya 2 gambar yang dapat diunggah.',
      );
      return;
    }

    final List<XFile> picked = await _picker.pickMultiImage(imageQuality: 80);

    if (picked.isNotEmpty) {
      // Gabungkan dengan yang sudah ada tapi batasi maksimal 2
      final newList = [...images, ...picked];
      images.value = newList.take(2).toList();
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }
}
