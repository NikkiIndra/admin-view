// lib/app/modules/admin/views/admin_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/service/admin_report_view.dart';
import '../controllers/admin_view_controller.dart';

class AdminView extends GetView<AdminViewController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.showMapView.value ? 'Peta Laporan' : 'Dashboard Admin',
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          Obx(
            () => controller.report.value != null
                ? IconButton(
                    icon: Badge(
                      child: Icon(Icons.notifications_active),
                      isLabelVisible: true,
                    ),
                    onPressed: () => controller.acknowledgeReport(),
                    tooltip: 'Ada laporan baru - Klik untuk menutup',
                  )
                : SizedBox(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.showMapView.value && controller.report.value != null) {
          return _buildMapView();
        } else {
          return _buildDashboardView();
        }
      }),
      floatingActionButton: Obx(() {
        if (controller.report.value != null && !controller.showMapView.value) {
          return FloatingActionButton(
            onPressed: () => controller.switchToMapView(),
            child: Icon(Icons.map),
            tooltip: 'Lihat Peta Laporan',
          );
        }
        return SizedBox();
      }),
    );
  }

  Widget _buildMapView() {
    final report = controller.report.value!;

    // Gunakan koordinat dari report atau default
    final userLat = report['latitude'] ?? -6.2;
    final userLon = report['longitude'] ?? 106.8;

    return AdminReportView(
      desaLat: -6.2088, // Koordinat kantor desa
      desaLon: 106.8456,
      userLat: userLat,
      userLon: userLon,
      kategori: report['category'] ?? 'Laporan Darurat',
      namaPelapor: report['pelapor'] ?? 'Unknown',
      alamatPelapor:
          'RT ${report['rt']}/RW ${report['rw']}, Blok ${report['blok']}',
      orsKey: 'your_openrouteservice_api_key', // Ganti dengan API key Anda
    );
  }

  Widget _buildDashboardView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Connection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Obx(
                    () => Icon(
                      controller.adminService.isConnected.value
                          ? Icons.wifi
                          : Icons.wifi_off,
                      color: controller.adminService.isConnected.value
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  SizedBox(width: 8),
                  Obx(
                    () => Text(
                      controller.adminService.isConnected.value
                          ? 'Terhubung ke Server'
                          : 'Koneksi Terputus',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.adminService.isConnected.value
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Info Laporan Terbaru
          Obx(() {
            if (controller.report.value != null) {
              final report = controller.report.value!;
              return Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Laporan Terbaru',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Pelapor: ${report['pelapor']}'),
                      Text('Kategori: ${report['category']}'),
                      Text('Lokasi: RT ${report['rt']}/RW ${report['rw']}'),
                      Text('Waktu: ${_formatTime(report['timestamp'])}'),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => controller.switchToMapView(),
                        child: Text('Lihat di Peta'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.dashboard, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Menunggu Laporan',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sistem akan otomatis menampilkan peta\nketika ada laporan masuk dari warga',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),

          Spacer(),

          // Manual Refresh Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () => controller.fetchInitialData(),
              icon: Icon(Icons.refresh),
              label: Text('Refresh Manual'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return 'Baru saja';
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) return 'Baru saja';
      if (difference.inMinutes < 60)
        return '${difference.inMinutes} menit lalu';
      if (difference.inHours < 24) return '${difference.inHours} jam lalu';
      return '${difference.inDays} hari lalu';
    } catch (e) {
      return timestamp;
    }
  }
}
