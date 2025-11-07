import 'package:get/get.dart';
import '../data/service/api_service.dart';

class ChartController extends GetxController {
  var isLoading = false.obs;
  var chartData = <Map<String, dynamic>>[].obs;
  var totalReports = 0.obs;

  final List<String> allMonths = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "Mei",
    "Jun",
    "Jul",
    "Agu",
    "Sep",
    "Okt",
    "Nov",
    "Des",
  ];

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
          final kemalingan = (item['kemalingan'] ?? 0) as num;
          
          final kebakaran = (item['kebakaran'] ?? 0) as num;
          return sum + kemalingan.toInt() + kebakaran.toInt();
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

  // --- Perbaikan di sini ---
  List<Map<String, dynamic>> getFormattedChartData() {
    final dataMap = <String, Map<String, dynamic>>{
      for (var m in allMonths)
        m: {'month': m, 'kemalingan': 0, 'kebakaran': 0},
    };

    for (var item in chartData) {
      final monthFull = item['month'] ?? '';
      // Ambil 3 huruf pertama saja agar cocok: "Okt 2025" -> "Okt"
      final month = monthFull.split(' ').first;

      if (dataMap.containsKey(month)) {
        dataMap[month]!['kemalingan'] = item['kemalingan'] ?? 0;
        
        dataMap[month]!['kebakaran'] = item['kebakaran'] ?? 0;
      }
    }

    return dataMap.values.toList();
  }

  Future<void> chartRefresh() async {
    await fetchChartData();
  }
}
