import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/model/report_model.dart';
import '../../../data/service/admin_service.dart';
import '../../../data/service/api_service.dart';
import '../../admin_maps_report/controllers/admin_maps_report_controller.dart';

class AdminController extends GetxController {
  final AdminService adminService = Get.find<AdminService>();
  final AdminMapsReportController adminMaps = Get.put(
    AdminMapsReportController(),
  );

  var loading = false.obs;
  var showMapView = false.obs;

  /// Sekarang pakai model `Report` agar rapi
  var report = Rxn<Report>();

  var mapController = Rxn<GoogleMapController>();
  final markers = <Marker>{}.obs;

  final adminLocation = LatLng(-6.200, 106.816);

  /// ID laporan terakhir yang sudah ditangani
  int? lastHandledReportId;

  @override
  void onInit() {
    super.onInit();
    setupReactiveListener();
    fetchInitialData();
  }

  // ✅ Cek laporan baru dari API (manual polling)
  Future<void> checkForNewReports() async {
    final res = await ApiService.get('/api/report/list/baru', auth: true);

    if (res['status'] == 'success' && res['data'] != null) {
      final List data = res['data'];

      if (data.isNotEmpty) {
        final latest = data.first;
        final latestId = latest['id'];

        // 🚫 Jangan tampilkan kalau sudah pernah ditangani
        if (lastHandledReportId != latestId) {
          report.value = Report.fromJson(latest);
          showMapView.value = true;
          updateMarkers();
          print("🆕 Ada laporan baru ID: $latestId");
        } else {
          print("ℹ️ Laporan ID $latestId sudah ditangani.");
        }
      }
    }
  }

  // ✅ Dengarkan laporan baru dari socket
  void setupReactiveListener() {
    ever(adminService.latestReport, (newReport) {
      if (newReport != null) {
        final newId = newReport['id'];
        if (lastHandledReportId != newId) {
          report.value = Report.fromJson(newReport);
          showMapView.value = true;
          updateMarkers();
          print("📡 Realtime: menampilkan laporan ID $newId");
        } else {
          print("ℹ️ Laporan realtime ID $newId diabaikan (sudah ditangani).");
        }
      }
    });
  }

  // ✅ Fetch laporan awal ketika app dibuka
  Future<void> fetchInitialData() async {
    loading.value = true;
    final latest = await adminService.fetchReports(status: 'baru');
    loading.value = false;

    if (latest.isNotEmpty) {
      final first = latest.first;
      final id = first['id'];

      if (lastHandledReportId != id) {
        report.value = Report.fromJson(first);
        showMapView.value = true;
        updateMarkers();
        print("📍 Initial laporan ID: $id");
      }
    }
  }

  // ✅ Update posisi marker di peta
  void updateMarkers() {
    markers.clear();

    // Marker admin
    markers.add(
      Marker(
        markerId: const MarkerId('admin_location'),
        position: adminLocation,
        infoWindow: const InfoWindow(title: 'Bale Desa (Admin)'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Marker laporan
    if (report.value != null) {
      final r = report.value!;
      markers.add(
        Marker(
          markerId: const MarkerId('report_location'),
          position: LatLng(r.latitude ?? 0, r.longitude ?? 0),
          infoWindow: InfoWindow(
            title: r.jenisLaporan ?? '-',
            snippet: r.namaPelapor ?? '-',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  // ✅ Tombol "Kembali ke Dashboard"
  void acknowledgeReport() {
    if (report.value != null) {
      lastHandledReportId = report.value!.id;
    }

    // Reset tampilan
    report.value = null;
    showMapView.value = false;
    markers.clear();

    Get.snackbar(
      'Selesai',
      'Laporan ditandai selesai dan dashboard ditampilkan.',
    );
  }

  // ✅ Reset penuh cache
  void resetCache() {
    report.value = null;
    showMapView.value = false;
    lastHandledReportId = null;
    markers.clear();
  }
}
