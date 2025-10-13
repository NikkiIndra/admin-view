import 'package:get/get.dart';

import '../controllers/news_uploads_controller.dart';

class NewsUploadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsUploadsController>(
      () => NewsUploadsController(),
    );
  }
}
