import 'dart:math';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:multi_admin/app/data/service/api_service.dart';
import '../../../data/model/history_report_model.dart';

class TrenReportLocationController extends GetxController {
  var isLoading = false.obs;
  var reports = <HistoryReportModel>[].obs;
  var isMapInitializing = true.obs;
  // HAPUS BARIS INI: var reportPoint = <ReportPoints>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      isMapInitializing(true);
      await fetchTrenReport();
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      print('❌ Map initialization error: $e');
    } finally {
      isMapInitializing(false);
    }
  }

  /// Titik laporan valid
  List<LatLng> get reportPoints => reports
      .where((r) => r.latitude != null && r.longitude != null)
      .map((r) => LatLng(r.latitude!, r.longitude!))
      .toList();

  /// Dapatkan titik tengah otomatis
  LatLng get mapCenter {
    final pts = reportPoints;
    if (pts.isEmpty) return const LatLng(-6.2, 106.816666);
    final avgLat =
        pts.map((e) => e.latitude).reduce((a, b) => a + b) / pts.length;
    final avgLng =
        pts.map((e) => e.longitude).reduce((a, b) => a + b) / pts.length;
    return LatLng(avgLat, avgLng);
  }

  Future<void> fetchTrenReport() async {
    try {
      isLoading.value = true;
      final token = await ApiService.getToken();
      print("🧩 Token dikirim ke API: $token");

      final res = await ApiService.get("messages/coords", auth: true);
      if (res["success"] == true && res["data"] != null) {
        final List<dynamic> data = res["data"];
        reports.value = data
            .map((u) => HistoryReportModel.fromJson(u))
            .toList();

        print("📊 Data koordinat dari server:");
        for (final u in reports) {
          print(" - ${u.id} - ${u.latitude}, ${u.longitude}");
        }
      } else {
        Get.snackbar("Error", res["message"] ?? "Gagal memuat data koordinat");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Cluster laporan dengan radius meter
  List<Cluster> clusterPoints(List<LatLng> points, {double radius = 100}) {
    final clusters = <Cluster>[];
    for (var point in points) {
      Cluster? found;
      for (var cluster in clusters) {
        final dist = distanceInMeters(
          cluster.center.latitude,
          cluster.center.longitude,
          point.latitude,
          point.longitude,
        );
        if (dist <= radius) {
          found = cluster;
          break;
        }
      }

      if (found != null) {
        found.points.add(point);
        // update posisi tengah cluster
        final avgLat =
            found.points.map((p) => p.latitude).reduce((a, b) => a + b) /
            found.points.length;
        final avgLng =
            found.points.map((p) => p.longitude).reduce((a, b) => a + b) /
            found.points.length;
        found.center = LatLng(avgLat, avgLng);
      } else {
        clusters.add(Cluster(point, [point]));
      }
    }
    return clusters;
  }

  double distanceInMeters(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // meter
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }
}

class Cluster {
  LatLng center;
  final List<LatLng> points;
  Cluster(this.center, this.points);
}
