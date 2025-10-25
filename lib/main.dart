import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/data/global_bindings/global_bindings.dart';
import 'app/data/service/admin_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AdminService());
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: GlobalBindings(),
    ),
  );
}
