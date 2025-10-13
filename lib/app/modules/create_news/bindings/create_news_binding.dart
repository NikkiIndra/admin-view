import 'package:get/get.dart';

import '../controllers/create_news_controller.dart';

class CreateNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateNewsController>(
      () => CreateNewsController(),
    );
  }
}
