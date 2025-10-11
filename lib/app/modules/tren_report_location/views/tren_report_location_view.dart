import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';

import '../controllers/tren_report_location_controller.dart';

class TrenReportLocationView extends GetView<TrenReportLocationController> {
  const TrenReportLocationView({super.key});
  @override
  Widget build(BuildContext context) {
    // Ambil data laporan
    controller.fetchTrenReport();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tren Laporan Lokasi'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final points = controller.reportPoints;
        if (points.isEmpty) {
          return const Center(child: Text("Tidak ada laporan tersedia."));
        }

        final clusters = controller.clusterPoints(points, radius: 100);

        return FlutterMap(
          options: MapOptions(
            initialCenter: controller.mapCenter,
            initialZoom: 16,
            minZoom: 10,
            maxZoom: 18,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.multi_admin',
            ),

            /// 🔥 Circle heat area
            CircleLayer(
              circles: clusters.map((c) {
                final count = c.points.length;
                final color = count >= 5
                    ? Colors.red.withOpacity(0.4)
                    : count >= 3
                    ? Colors.orange.withOpacity(0.4)
                    : Colors.yellow.withOpacity(0.3);
                return CircleMarker(
                  point: c.center,
                  color: color,
                  borderStrokeWidth: 0,
                  useRadiusInMeter: true,
                  radius: 100,
                );
              }).toList(),
            ),

            /// 📍 Label jumlah laporan di tengah cluster
            MarkerLayer(
              markers: clusters.map((c) {
                return Marker(
                  point: c.center,
                  width: 60,
                  height: 60,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${c.points.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }),
    );
  }
}
