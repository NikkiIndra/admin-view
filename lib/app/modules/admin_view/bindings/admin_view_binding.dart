import 'package:get/get.dart';

import '../controllers/admin_view_controller.dart';

class AdminViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminViewController>(
      () => AdminViewController(),
    );
  }
}
