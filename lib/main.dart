import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/data/service/admin_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services - TIDAK PERLU await untuk GetxService
  Get.put(AdminService());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
