import 'package:get/get.dart';

import '../../../data/model/history_report_model.dart';
import '../../../data/service/api_service.dart';

class ReportHistoryController extends GetxController {
  var isLoading = false.obs;
  var messages = <HistoryReportModel>[].obs;

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final res = await ApiService.get(
        'messages?fields=m.id,m.description,m.category,m.tts_url,m.created_at,u.nama_lengkap,u.desa_id',
        auth: true,
      );

      if (res["success"] == true && res["data"] != null) {
        final List<dynamic> data = res["data"];
        messages.value = data
            .map((m) => HistoryReportModel.fromJson(m))
            .toList();
      } else {
        Get.snackbar("Error", "${res["message"]}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
