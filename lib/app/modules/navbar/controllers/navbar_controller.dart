// navbar_controller.dart
import 'package:get/get.dart';

class NavbarController extends GetxController {
  var currentIndex = 0.obs;

  final List<String> navItems = [
    'Dashboard',
    'Create News',
    'News Uploads',
    'Settings',
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
