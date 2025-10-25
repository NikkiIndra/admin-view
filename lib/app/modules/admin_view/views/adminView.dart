import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/modules/admin_maps_report/views/admin_maps_report_view.dart';
import '../../admin_maps_report/controllers/admin_maps_report_controller.dart';
import '../controllers/admin_view_controller.dart';
import 'admin_view_view.dart';

class AdminMainView extends GetView<AdminController> {
  const AdminMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showMapView.value && controller.report.value != null) {
        Get.put(AdminMapsReportController());
        return const AdminMapsReportView();
      }

      // Jika tidak ada laporan aktif, tampilkan dashboard desa
      return AdminView();
    });
  }
}
