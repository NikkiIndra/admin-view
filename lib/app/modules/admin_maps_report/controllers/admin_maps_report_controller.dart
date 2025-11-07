import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:multi_admin/app/data/model/report_model.dart';
import '../../../data/service/api_service.dart';
import '../../admin_view/controllers/admin_view_controller.dart';

class AdminMapsReportController extends GetxController {
  var isLoading = false.obs;
  var activeReport = Rxn<ReportModel>(); // ✅ hanya 1 laporan aktif
  var lastHandledReportId =
      0.obs; // ✅ simpan laporan terakhir yang sudah ditangani
  final storage = GetStorage();
  // posisi desa (koordinat pusat)
  var desaLat = (-6.714898).obs;
  var desaLon = (108.533614).obs;
  var latestReport = Rxn<ReportModel>();
  // polyline untuk menampilkan rute dari desa ke laporan
  var routePoints = <LatLng>[].obs;

  // daftar marker (laporan) yang aktif di peta
  var reportMarkers = <LatLng>[].obs; // ✅ baru
  @override
  void onInit() {
    ever(activeReport, (r) {
      print("🔥 activeReport berubah: $r");
    });
    super.onInit();
  }

  Future<void> fetchReport() async {
    try {
      isLoading.value = true;
      final res = await ApiService.get("/api/report/list/baru", auth: true);

      if (res["status"] == "success" && res["data"] != null) {
        final List<dynamic> data = res["data"];

        if (data.isNotEmpty) {
          final latest = ReportModel.fromJson(data.first);

          print("🧩 lastHandledReportId: ${lastHandledReportId.value}");
          print("🧩 latest.id: ${latest.id}");
          // ✅ Cegah laporan yang sudah ditangani muncul lagi
          if (latest.id != lastHandledReportId.value) {
            activeReport.value = latest;
            print("🆕 Menampilkan laporan baru: ${latest.id}");
            Get.find<AdminController>().report.value = latest;
            Get.find<AdminController>().showMapView.value = true;
            await fetchRouteToReport(latest.latitude!, latest.longitude!);

            // ✅ tampilkan marker baru di peta
            addReportMarker(latest);
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

  /// ✅ Tambahkan marker baru ke daftar peta
  void addReportMarker(ReportModel report) {
    final marker = LatLng(report.latitude ?? 0, report.longitude ?? 0);
    reportMarkers.add(marker);

    print(
      "📍 Marker laporan baru ditambahkan (${report.latitude}, ${report.longitude})",
    );
  }

  Future<void> fetchRouteToReport(double targetLat, double targetLon) async {
    try {
      const apiKey =
          'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjIyZDBkZDY2M2JjZDRlMzA5NDI2Mzg5YWRmYmNkMzNlIiwiaCI6Im11cm11cjY0In0='; // ganti dengan API key kamu
      final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${desaLon.value},${desaLat.value}&end=$targetLon,$targetLat',
      );

      final response = await http.get(url);
      print("🔗 URL: $url");
      print("📦 Response body: ${response.body}");
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
  // void markReportAsHandled() {
  //   if (activeReport.value != null) {
  //     lastHandledReportId.value = activeReport.value!.id ?? 0;
  //     print("✅ Laporan ${activeReport.value!.id} ditandai selesai");

  //     // Tutup map dan kembali ke dashboard
  //     Get.find<AdminController>().showMapView.value = false;
  //     Get.find<AdminController>().report.value = null;

  //     activeReport.value = null;
  //     routePoints.clear();
  //   }
  // }

Future<void> fetchLatestReport() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.137.1:5000/api/report/latest'), // sesuaikan IP server kamu
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      latestReport.value = ReportModel.fromJson(data['data']);
    } else {
      latestReport.value = null;
    }
  } catch (e) {
    print("Error fetch latest report: $e");
  }
}

  Future<void> markReportAsHandled() async {
    final id = activeReport.value?.id;
    if (id != null) {
      await ApiService.post("/api/report/mark_handled/$id", {}, auth: true);
      lastHandledReportId.value = id;
      storage.write('lastHandledReportId', id); // ✅ simpan persist

      Get.find<AdminController>().showMapView.value = false;
      Get.find<AdminController>().report.value = null;

      activeReport.value = null;
      routePoints.clear();
    }
  }

  // void markReportAsHandled() {
  //   if (activeReport.value != null) {
  //     lastHandledReportId.value = activeReport.value!.id ?? 0;
  //     print("✅ Laporan ${activeReport.value!.id} ditandai selesai");
  //     // Jangan hapus dari tampilan — biarkan tetap muncul
  //     routePoints.clear();
  //   }
  // }

  void forceRefresh() {
    isLoading.refresh();
    routePoints.refresh();
    activeReport.refresh();
    reportMarkers.refresh();
    print("🔄 Map view di-refresh manual");
  }
}
