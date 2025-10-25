import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../routes/app_pages.dart';
import '../../admin_view/controllers/admin_view_controller.dart';
import '../controllers/admin_maps_report_controller.dart';

class AdminMapsReportView extends StatelessWidget {
  const AdminMapsReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final mapController = Get.put(AdminMapsReportController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Masuk (OpenStreetMap)"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (mapController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final desaLat = mapController.desaLat.value;
        final desaLon = mapController.desaLon.value;
        final report = mapController.activeReport.value;

        // --- Tentukan titik yang akan ditampilkan di peta ---
        final allPoints = <LatLng>[LatLng(desaLat, desaLon)];
        if (report != null &&
            report.latitude != null &&
            report.longitude != null) {
          allPoints.add(LatLng(report.latitude!, report.longitude!));
        }

        // --- Buat marker untuk laporan (jika ada) ---
        final List<Marker> markers = [
          Marker(
            point: LatLng(desaLat, desaLon),
            width: 40,
            height: 40,
            child: const Icon(Icons.home, color: Colors.blueAccent, size: 36),
          ),
          if (report != null)
            Marker(
              point: LatLng(report.latitude ?? 0, report.longitude ?? 0),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showDetail(context, report),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 36,
                ),
              ),
            ),
        ];

        // --- Render peta utama ---
        return Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _calculateCenter(allPoints),
                  initialZoom: _calculateZoomLevel(allPoints),
                  maxZoom: 18.0,
                  minZoom: 5.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.siskamling_digital',
                  ),
                  MarkerLayer(markers: markers),
                  if (mapController.routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: mapController.routePoints,
                          strokeWidth: 4.5,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // --- Panel laporan tunggal ---
            Positioned(
              bottom: 10,
              right: 10,
              left: 10,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: report == null
                    ? const Center(
                        child: Text(
                          "Belum ada laporan baru.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: const Icon(
                            Icons.report,
                            color: Colors.redAccent,
                          ),
                          title: Text(report.jenisLaporan ?? "Tidak diketahui"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pelapor: ${report.namaPelapor ?? '-'}"),
                              Text(
                                "Status: ${report.status ?? 'Belum diproses'}",
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await mapController.fetchRouteToReport(
                              report.latitude!,
                              report.longitude!,
                            );
                            _showDetail(context, report);
                          },
                        ),
                      ),
              ),
            ),

            // --- Tombol kembali ke dashboard ---
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  mapController.markReportAsHandled();
                  final adminController = Get.find<AdminController>();
                  adminController.lastHandledReportId =
                      adminController.report.value?.id;
                  adminController.showMapView.value = false;
                  mapController.markReportAsHandled();
                  Get.toNamed(Routes.NAVBAR);
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.arrow_back),
              ),
            ),

            // --- Tombol reset view ke semua marker ---
            if (allPoints.length > 1)
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.my_location),
                  onPressed: () => mapController.forceRefresh(),
                ),
              ),
          ],
        );
      }),
    );
  }

  // === Helper untuk menghitung center map ===
  LatLng _calculateCenter(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(-6.2088, 106.8456);
    double totalLat = 0;
    double totalLon = 0;
    for (final p in points) {
      totalLat += p.latitude;
      totalLon += p.longitude;
    }
    return LatLng(totalLat / points.length, totalLon / points.length);
  }

  // === Helper zoom level berdasarkan jarak antar titik ===
  double _calculateZoomLevel(List<LatLng> points) {
    if (points.length <= 1) return 15.0;
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLon = points.first.longitude;
    double maxLon = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLon) minLon = p.longitude;
      if (p.longitude > maxLon) maxLon = p.longitude;
    }

    final latDiff = maxLat - minLat;
    final lonDiff = maxLon - minLon;
    final maxDiff = latDiff > lonDiff ? latDiff : lonDiff;

    if (maxDiff < 0.001) return 18.0;
    if (maxDiff < 0.005) return 16.0;
    if (maxDiff < 0.01) return 14.0;
    if (maxDiff < 0.05) return 12.0;
    if (maxDiff < 0.1) return 10.0;
    return 8.0;
  }

  // === Popup detail laporan ===
  void _showDetail(BuildContext context, report) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(report.jenisLaporan ?? "Detail Laporan"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama Pelapor: ${report.namaPelapor ?? '-'}"),
              Text("Alamat: ${report.alamat ?? '-'}"),
              Text("Deskripsi: ${report.deskripsi ?? '-'}"),
              Text("Tanggal: ${report.tanggal ?? '-'}"),
              Text("Status: ${report.status ?? '-'}"),
              if (report.latitude != null && report.longitude != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Koordinat: ${report.latitude!.toStringAsFixed(6)}, ${report.longitude!.toStringAsFixed(6)}",
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Tutup")),
        ],
      ),
    );
  }
}
