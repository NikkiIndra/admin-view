// navbar_view.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin_view/views/adminView.dart';
import '../controllers/navbar_controller.dart';
import '../../create_news/views/create_news_view.dart';
import '../../news_uploads/views/news_uploads_view.dart';
import '../../settings/views/settings_view.dart';

class AppColors {
  static const white35 = Color(0x59FFFFFF); // Transparan putih
  static const primaryBlue = Color(0xFF1E40AF); // Warna biru dari gambar
  static const darkBlue = Color(0xFF1E3A8A); // Warna biru gelap
}

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Content
          Row(
            children: [
              // Content Area
              Expanded(
                child: Container(
                  color: AppColors.white35,
                  child: Obx(() {
                    switch (controller.currentIndex.value) {
                      case 0:
                        return AdminMainView();
                      case 1:
                        return CreateNewsView();
                      case 2:
                        return NewsUploadsView();
                      case 3:
                        return SettingsView();
                      default:
                        return AdminMainView();
                    }
                  }),
                ),
              ),
            ],
          ),

          // Floating Navbar
          Positioned(
            left: 16, // Jarak dari kiri
            top: 16, // Jarak dari atas
            bottom: 16, // Jarak dari bawah
            child: Container(
              width: 64, // Lebar navbar lebih kecil seperti di gambar
              decoration: BoxDecoration(
                color: AppColors.white35, // Transparan putih
                borderRadius: BorderRadius.circular(20), // Sudut melengkung
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Header/Logo Navbar
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        // Logo/Gambar seperti di screenshot
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.white35,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image(
                            image: AssetImage("assets/images/logo.ico"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: Colors.grey[400]!.withOpacity(0.5),
                      thickness: 1,
                    ),
                  ),

                  // Menu Items - Vertikal seperti di gambar
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.navItems.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Material(
                              color: controller.currentIndex.value == index
                                  ? AppColors.primaryBlue.withOpacity(0.8)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () => controller.changePage(index),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 50,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Icon dengan ukuran lebih kecil
                                      Icon(
                                        _getIconForIndex(index),
                                        color:
                                            controller.currentIndex.value ==
                                                index
                                            ? Colors.white
                                            : AppColors.darkBlue.withOpacity(
                                                0.7,
                                              ),
                                        size: 20,
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom spacing
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0: // Dashboard
        return Icons.dashboard;
      case 1: // Create News
        return CupertinoIcons.create;
      case 2: // News Uploads
        return CupertinoIcons.collections;
      case 3: // Settings
        return CupertinoIcons.settings;
      default:
        return CupertinoIcons.circle;
    }
  }
}
