import 'package:get/get.dart';
import '../../../data/model/news_model.dart';
import '../../../data/service/api_service.dart';

class NewsUploadsController extends GetxController {
  final newsList = <NewsModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  /// Ambil semua berita yang sesuai dengan desa_id dari token JWT
  Future<void> fetchNews() async {
    try {
      isLoading.value = true;

      print('📡 Memanggil endpoint: /news');
      final response = await ApiService.get('news', auth: true);

      print('🧾 Response API: $response');

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        newsList.value = data.map((e) => NewsModel.fromJson(e)).toList();

        // Debug URL gambar
        for (var n in newsList) {
          print('🖼️ Gambar berita: ${n.imageUrl}');
        }
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Tidak ada berita ditemukan.',
        );
      }
    } catch (e) {
      print('❌ Error saat fetchNews: $e');
      Get.snackbar('Error', 'Gagal memuat berita: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
