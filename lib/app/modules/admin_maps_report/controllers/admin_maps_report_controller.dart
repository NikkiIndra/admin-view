import 'dart:convert';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:multi_admin/app/data/model/report_model.dart';
import '../../../data/service/api_service.dart';

class AdminMapsReportController extends GetxController {
  var isLoading = false.obs;
  var activeReport = Rxn<Report>(); // ✅ hanya 1 laporan aktif
  var lastHandledReportId =
      0.obs; // ✅ simpan laporan terakhir yang sudah ditangani

  // posisi desa (koordinat pusat)
  var desaLat = (-6.714898).obs;
  var desaLon = (108.533614).obs;

  // polyline untuk menampilkan rute dari desa ke laporan
  var routePoints = <LatLng>[].obs;

  Future<void> fetchReport() async {
    try {
      isLoading.value = true;
      final res = await ApiService.get("/api/report/list/baru", auth: true);

      if (res["status"] == "success" && res["data"] != null) {
        final List<dynamic> data = res["data"];

        if (data.isNotEmpty) {
          final latest = Report.fromJson(data.first);

          // ✅ Cegah laporan yang sudah ditangani muncul lagi
          if (latest.id != lastHandledReportId.value) {
            activeReport.value = latest;
            print("🆕 Menampilkan laporan baru: ${latest.id}");
            await fetchRouteToReport(latest.latitude!, latest.longitude!);
          } else {
            print("ℹ️ Tidak ada laporan baru.");
          }
        } else {
          print("❌ Tidak ada laporan tersedia.");
        }
      } else {
        Get.snackbar("Error", res["message"] ?? "Gagal memuat data laporan");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRouteToReport(double targetLat, double targetLon) async {
    try {
      const apiKey =
          'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjIyZDBkZDY2M2JjZDRlMzA5NDI2Mzg5YWRmYmNkMzNlIiwiaCI6Im11cm11cjY0In0='; // ganti dengan API key kamu
      final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${desaLon.value},${desaLat.value}&end=$targetLon,$targetLat',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coords = data['features'][0]['geometry']['coordinates'] as List;
        routePoints.value = coords.map((c) => LatLng(c[1], c[0])).toList();

        print("🗺️ Rute berhasil dimuat (${routePoints.length} titik)");
      } else {
        print("⚠️ Gagal memuat rute: ${response.statusCode}");
        routePoints.clear();
      }
    } catch (e) {
      print("❌ Error ambil rute: $e");
      routePoints.clear();
    }
  }

  // ✅ Fungsi untuk menandai laporan selesai (klik tombol kembali)
  void markReportAsHandled() {
    if (activeReport.value != null) {
      lastHandledReportId.value = activeReport.value!.id ?? 0;
      print("✅ Laporan ${activeReport.value!.id} ditandai selesai");
      activeReport.value = null;
      routePoints.clear();
    }
  }

  void forceRefresh() {
    // Ini cara cepat buat trigger update manual pada UI tanpa fetch ulang
    isLoading.refresh();
    routePoints.refresh();
    activeReport.refresh();
    print("🔄 Map view di-refresh manual");
  }
}
