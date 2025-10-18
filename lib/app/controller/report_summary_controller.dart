import 'package:get/get.dart';
import '../data/service/api_service.dart';

class ReportSummaryController extends GetxController {
  var isLoading = false.obs;
  var todayCount = 0.obs;
  var weekCount = 0.obs;
  var monthCount = 0.obs;
  var currentWeek = "".obs;
  var currentMonth = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchReportSummary();
  }

  Future<void> fetchReportSummary() async {
    try {
      isLoading.value = true;

      // Tambahkan timestamp untuk prevent caching
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final res = await ApiService.get(
        "messages/summary?_t=$timestamp", // Tambahkan parameter anti-cache
        auth: true,
      );

      if (res["success"] == true && res["data"] != null) {
        final data = res["data"];
        todayCount.value = data['today'] ?? 0;
        weekCount.value = data['week'] ?? 0;
        monthCount.value = data['month'] ?? 0;
        currentWeek.value = data['current_week'] ?? "Minggu-1";
        currentMonth.value = data['current_month'] ?? "Januari";

        print(
          "📊 Summary data loaded: Today: ${todayCount.value}, Week: ${weekCount.value}, Month: ${monthCount.value}",
        );
      } else {
        Get.snackbar(
          "Error",
          res["message"] ?? "Gagal memuat ringkasan laporan",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk refresh data
  Future<void> refreshSummary() async {
    await fetchReportSummary();
  }
}
