// lib/app/modules/admin/controllers/admin_view_controller.dart
import 'dart:math';

import 'package:get/get.dart';
import '../../../data/service/admin_service.dart';

class AdminViewController extends GetxController {
  final AdminService adminService = Get.find<AdminService>();

  var loading = false.obs;
  var report = Rxn<Map<String, dynamic>>();
  var showMapView = false.obs;

  @override
  void onInit() {
    super.onInit();
    setupReactiveListener();
    fetchInitialData();
  }

  void setupReactiveListener() {
    // Listen to real-time reports from WebSocket
    ever(adminService.latestReport, (newReport) {
      if (newReport != null && newReport['type'] == 'new_report') {
        final reportData = newReport['data'];
        print('🎯 Processing new report: $reportData');

        // Update report data
        report.value = {
          'pelapor': reportData['pelapor'],
          'category': reportData['category'],
          'rt': reportData['rt'],
          'rw': reportData['rw'],
          'blok': reportData['blok'],
          'desa': reportData['desa'],
          'timestamp': reportData['timestamp'],
          // Tambahkan koordinat dummy (sesuaikan dengan data asli)
          'latitude':
              -6.2 + (Random().nextDouble() * 0.1 - 0.05), // Random coordinates
          'longitude': 106.8 + (Random().nextDouble() * 0.1 - 0.05),
        };

        showMapView.value = true; // Auto-switch to map view

        // Auto hide map view after 30 seconds
        Future.delayed(Duration(seconds: 30), () {
          if (report.value?['pelapor'] == reportData['pelapor']) {
            showMapView.value = false;
            report.value = null;
          }
        });
      }
    });
  }

  Future<void> fetchInitialData() async {
    // Only fetch initial data if no real-time data available
    if (report.value == null) {
      loading.value = true;
      final data = await AdminService.getLatestReport();
      loading.value = false;
      if (data != null) {
        report.value = data;
      }
    }
  }

  void switchToMapView() {
    showMapView.value = true;
  }

  void switchToListView() {
    showMapView.value = false;
  }

  void acknowledgeReport() {
    report.value = null;
    showMapView.value = false;
    Get.snackbar('Success', 'Laporan telah ditandai selesai');
  }
}
