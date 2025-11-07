import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/styles/apps_style.dart';
import '../controllers/user_detail_controller.dart';

class UserDetailView extends GetView<UserDetailController> {
  const UserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0XFF0800FF).withOpacity(0.8),
              const Color(0XFF444861),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Icon(CupertinoIcons.back, color: Colors.white),
                color: Colors.white,
                onPressed: () => Get.back(),
              ),
              actionsPadding: const EdgeInsets.only(right: 16),
              title: Obx(
                () => controller.isSearching.value
                    ? _buildSearchField()
                    : const Text(
                        "Detail User Terdaftar",
                        style: AppStyles.bodyTextWhite,
                      ),
              ),
              floating: true,
              pinned: true,
              backgroundColor: Colors.white30,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0XFF0800FF).withOpacity(0.9),
                      const Color(0XFF444861),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              actions: [
                Obx(
                  () => CircleAvatar(
                    radius: 20,
                    child: IconButton(
                      icon: Icon(
                        controller.isSearching.value
                            ? Icons.close
                            : Icons.search,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (controller.isSearching.value) {
                          controller.closeSearch();
                        } else {
                          controller.toggleSearch();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.filteredUsers.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      controller.searchController.text.isEmpty
                          ? "Tidak ada data user"
                          : "User tidak ditemukan",
                      style: AppStyles.bodyTextWhite,
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: _getChildAspectRatio(context),
                    mainAxisExtent: _getMainAxisExtent(context),
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final u = controller.filteredUsers[index];
                    return _buildUserCard(context, u);
                  }, childCount: controller.filteredUsers.length),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Cari berdasarkan nama...",
        hintStyle: const TextStyle(color: Colors.white70),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, dynamic u) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    final bool isVerySmallScreen = MediaQuery.of(context).size.width < 400;

    final String phoneNumber = _getPhoneNumber(u);
    final String displayName = u.name ?? "Tanpa Nama";
    final String rt = u.rt?.toString() ?? '-';
    final String rw = u.rw?.toString() ?? '-';
    final String blok = u.blok ?? '-';
    final String role = u.role ?? '-';
    final String joinDate = u.createdAt ?? '-';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white30,
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bagian atas dengan foto dan info user
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Foto profil
                    Container(
                      height: isVerySmallScreen ? 45 : 55,
                      width: isVerySmallScreen ? 50 : 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Image.asset(
                        "assets/images/pose2.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),

                    // Info user - menggunakan Expanded agar tidak overflow
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName,
                            style: AppStyles.bodyTextWhite.copyWith(
                              fontSize: isVerySmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          _buildInfoRow("Rt/Rw: $rt/$rw", isVerySmallScreen),
                          _buildInfoRow("Blok: $blok", isVerySmallScreen),
                          _buildInfoRow(
                            "Gabung: ${_formatDate(joinDate)}",
                            isVerySmallScreen,
                          ),
                        ],
                      ),
                    ),

                    // Role badge untuk layar yang cukup lebar
                    if (!isVerySmallScreen && constraints.maxWidth > 200) ...[
                      const SizedBox(width: 8),
                      Container(
                        height: 30,
                        width: isSmallScreen ? 70 : 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [Color(0XFF5340E1), Color(0XFF12B9F5)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            role,
                            style: AppStyles.bodyTextWhite.copyWith(
                              fontSize: isSmallScreen ? 10 : 12,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Role badge untuk layar sangat kecil atau jika di atas tidak muat
                if (isVerySmallScreen || constraints.maxWidth <= 200) ...[
                  const SizedBox(height: 8),
                  Container(
                    height: 28,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0XFF5340E1), Color(0XFF12B9F5)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        role,
                        style: AppStyles.bodyTextWhite.copyWith(fontSize: 11),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Bagian telepon - menggunakan Flexible untuk menghindari overflow
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 24, 24, 54),
                          Color(0XFF0800FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 12 : 16,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Telp: $phoneNumber",
                            style: AppStyles.bodyTextWhite.copyWith(
                              fontSize: isSmallScreen ? 11 : 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: phoneNumber != '-'
                              ? () {
                                  _makePhoneCall(phoneNumber);
                                }
                              : null,
                          icon: Icon(
                            Icons.phone,
                            size: isSmallScreen ? 12 : 14,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Hubungi",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 6 : 8,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 6 : 10,
                              vertical: isSmallScreen ? 4 : 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String text, bool isVerySmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: AppStyles.bodyTextWhite.copyWith(
          fontSize: isVerySmallScreen ? 9 : 11,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    return date.length > 10 ? date.substring(0, 10) : date;
  }

  String _getPhoneNumber(dynamic user) {
    if (user.phone != null) return user.phone!;

    return '-';
  }

  void _makePhoneCall(String phoneNumber) {
    if (phoneNumber != '-') {
      Get.snackbar(
        'Panggilan',
        'Memanggil $phoneNumber',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return 1.6; // Lebih kecil untuk layar kecil
    if (width < 600) return 1.8;
    if (width < 900) return 2.0;
    return 2.2;
  }

  double _getMainAxisExtent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return 240; // Sedikit lebih tinggi untuk layar kecil
    if (width < 600) return 220;
    if (width < 900) return 210;
    return 200;
  }
}
