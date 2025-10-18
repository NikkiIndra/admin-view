import 'package:get/get.dart';
import '../data/service/api_service.dart';

class ChartController extends GetxController {
  var isLoading = false.obs;
  var chartData = <Map<String, dynamic>>[].obs;
  var totalReports = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    try {
      isLoading.value = true;

      final res = await ApiService.get("messages/chart-data", auth: true);

      if (res["success"] == true && res["data"] != null) {
        final List<dynamic> data = res["data"];
        chartData.value = data
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        // Hitung total laporan
        totalReports.value = chartData.fold(0, (sum, item) {
          return sum +
              (item['kemalingan'] as int) +
              (item['medis'] as int) +
              (item['kebakaran'] as int);
        });

        print("📊 Data chart loaded: ${chartData.length} bulan");
      } else {
        Get.snackbar("Error", res["message"] ?? "Gagal memuat data grafik");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk mendapatkan data dalam format yang sesuai untuk chart
  List<Map<String, dynamic>> getFormattedChartData() {
    return chartData.map((item) {
      return {
        'month': item['month'],
        'kemalingan': item['kemalingan'] ?? 0,
        'medis': item['medis'] ?? 0,
        'kebakaran': item['kebakaran'] ?? 0,
      };
    }).toList();
  }

  Future<void> chartRefresh() async {
    await fetchChartData();
  }
}
