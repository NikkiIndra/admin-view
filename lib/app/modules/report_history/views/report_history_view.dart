import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/styles/apps_style.dart';
import '../controllers/report_history_controller.dart';
import '../../../data/model/history_report_model.dart';

class ReportHistoryView extends GetView<ReportHistoryController> {
  const ReportHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallMobile = screenSize.width < 360;
    final isMobile = screenSize.width < 600;
    final isTablet = screenSize.width >= 600 && screenSize.width < 1024;
    final isDesktop = screenSize.width >= 1024;

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
                icon: Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: isDesktop
                      ? 28
                      : isTablet
                      ? 24
                      : 20,
                ),
                onPressed: () => Get.back(),
              ),
              actionsPadding: EdgeInsets.only(
                right: isDesktop
                    ? 32
                    : isTablet
                    ? 24
                    : 16,
              ),
              title: Obx(
                () => controller.isSearching.value
                    ? _buildSearchField(isMobile, isTablet, isDesktop)
                    : Text(
                        "History Laporan",
                        style: AppStyles.bodyTextWhite.copyWith(
                          fontSize: isDesktop
                              ? 20
                              : isTablet
                              ? 18
                              : 16,
                          fontWeight: FontWeight.w600,
                        ),
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
                    radius: isDesktop
                        ? 24
                        : isTablet
                        ? 22
                        : 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        controller.isSearching.value
                            ? Icons.close
                            : Icons.search,
                        color: Colors.black,
                        size: isDesktop
                            ? 22
                            : isTablet
                            ? 20
                            : 18,
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
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }

              if (controller.filteredMessages.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      controller.searchController.text.isEmpty
                          ? "Tidak ada data laporan"
                          : "Laporan tidak ditemukan",
                      style: AppStyles.bodyTextWhite.copyWith(
                        fontSize: isDesktop
                            ? 18
                            : isTablet
                            ? 16
                            : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.all(
                  isDesktop
                      ? 24
                      : isTablet
                      ? 16
                      : 12,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: isDesktop
                        ? 600
                        : isTablet
                        ? 500
                        : 400,
                    crossAxisSpacing: isDesktop
                        ? 20
                        : isTablet
                        ? 16
                        : 12,
                    mainAxisSpacing: isDesktop
                        ? 20
                        : isTablet
                        ? 16
                        : 12,
                    childAspectRatio: _getChildAspectRatio(
                      isMobile,
                      isTablet,
                      isDesktop,
                    ),
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final report = controller.filteredMessages[index];
                    return _buildReportCard(
                      context,
                      report,
                      isMobile,
                      isTablet,
                      isDesktop,
                    );
                  }, childCount: controller.filteredMessages.length),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(bool isMobile, bool isTablet, bool isDesktop) {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      style: TextStyle(
        color: Colors.white,
        fontSize: isDesktop
            ? 18
            : isTablet
            ? 16
            : 14,
      ),
      decoration: InputDecoration(
        hintText: "Cari berdasarkan nama, kategori, atau deskripsi...",
        hintStyle: TextStyle(
          color: Colors.white70,
          fontSize: isDesktop
              ? 18
              : isTablet
              ? 16
              : 14,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    HistoryReportModel report,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    final cardPadding = isDesktop
        ? 20.0
        : isTablet
        ? 16.0
        : 12.0;
    final borderRadius = isDesktop
        ? 20.0
        : isTablet
        ? 16.0
        : 12.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white30,
        boxShadow: [
          if (isDesktop)
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section - Reporter Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Avatar
                Container(
                  width: isDesktop
                      ? 60
                      : isTablet
                      ? 50
                      : 40,
                  height: isDesktop
                      ? 60
                      : isTablet
                      ? 50
                      : 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      isDesktop
                          ? 12
                          : isTablet
                          ? 10
                          : 8,
                    ),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: isDesktop
                        ? 24
                        : isTablet
                        ? 20
                        : 16,
                  ),
                ),
                SizedBox(
                  width: isDesktop
                      ? 16
                      : isTablet
                      ? 12
                      : 8,
                ),

                // Reporter Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.namaLengkap ?? "Tidak Diketahui",
                        style: AppStyles.bodyTextWhite.copyWith(
                          fontSize: isDesktop
                              ? 18
                              : isTablet
                              ? 16
                              : 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: isDesktop
                            ? 8
                            : isTablet
                            ? 6
                            : 4,
                      ),
                      Text(
                        _formatDate(report.createdAt),
                        style: AppStyles.bodyTextWhite.copyWith(
                          fontSize: isDesktop
                              ? 14
                              : isTablet
                              ? 12
                              : 10,
                          color: Colors.white70,
                        ),
                      ),
                      if (report.desa_id != null) ...[
                        SizedBox(
                          height: isDesktop
                              ? 4
                              : isTablet
                              ? 2
                              : 1,
                        ),
                        Text(
                          "Desa ID: ${report.desa_id}",
                          style: AppStyles.bodyTextWhite.copyWith(
                            fontSize: isDesktop
                                ? 12
                                : isTablet
                                ? 10
                                : 8,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(
              height: isDesktop
                  ? 16
                  : isTablet
                  ? 12
                  : 8,
            ),

            // Category Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop
                    ? 16
                    : isTablet
                    ? 12
                    : 8,
                vertical: isDesktop
                    ? 8
                    : isTablet
                    ? 6
                    : 4,
              ),
              decoration: BoxDecoration(
                color: _getCategoryColor(report.category),
                borderRadius: BorderRadius.circular(
                  isDesktop
                      ? 20
                      : isTablet
                      ? 16
                      : 12,
                ),
              ),
              child: Text(
                report.category ?? "Tidak Berkategori",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop
                      ? 14
                      : isTablet
                      ? 12
                      : 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(
              height: isDesktop
                  ? 16
                  : isTablet
                  ? 12
                  : 8,
            ),

            // Description
            Expanded(
              child: Text(
                report.description ?? "Tidak ada deskripsi",
                style: AppStyles.bodyTextWhite.copyWith(
                  fontSize: isDesktop
                      ? 16
                      : isTablet
                      ? 14
                      : 12,
                ),
                maxLines: isDesktop
                    ? 4
                    : isTablet
                    ? 3
                    : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(
              height: isDesktop
                  ? 16
                  : isTablet
                  ? 12
                  : 8,
            ),

            // Location and Actions Section
            Row(
              children: [
                // Location Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (report.latitude != null && report.longitude != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: isDesktop
                                  ? 16
                                  : isTablet
                                  ? 14
                                  : 12,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${report.latitude!.toStringAsFixed(4)}, ${report.longitude!.toStringAsFixed(4)}",
                                style: AppStyles.bodyTextWhite.copyWith(
                                  fontSize: isDesktop
                                      ? 12
                                      : isTablet
                                      ? 10
                                      : 8,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Action Buttons
                if (isTablet || isDesktop)
                  Row(
                    children: [
                      _buildActionButton(
                        "Audio",
                        Icons.audiotrack,
                        () {
                          _playAudio(report.ttsUrl);
                        },
                        isMobile,
                        isTablet,
                        isDesktop,
                      ),
                      SizedBox(width: 8),
                      _buildActionButton(
                        "Detail",
                        Icons.visibility,
                        () {
                          _showReportDetail(report);
                        },
                        isMobile,
                        isTablet,
                        isDesktop,
                      ),
                    ],
                  )
                else
                  _buildActionButton(
                    "Detail",
                    Icons.visibility,
                    () {
                      _showReportDetail(report);
                    },
                    isMobile,
                    isTablet,
                    isDesktop,
                  ),
              ],
            ),

            // Audio Button for Mobile (if not shown above)
            if (isMobile && report.ttsUrl != null) ...[
              SizedBox(height: 8),
              _buildActionButton(
                "Dengarkan Audio",
                Icons.audiotrack,
                () {
                  _playAudio(report.ttsUrl);
                },
                isMobile,
                isTablet,
                isDesktop,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: isDesktop
            ? 18
            : isTablet
            ? 16
            : 14,
      ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: isDesktop
              ? 14
              : isTablet
              ? 12
              : 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isDesktop
                ? 12
                : isTablet
                ? 10
                : 8,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop
              ? 16
              : isTablet
              ? 12
              : 8,
          vertical: isDesktop
              ? 10
              : isTablet
              ? 8
              : 6,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  double _getChildAspectRatio(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) return 1.2;
    if (isTablet) return 1.4;
    return 1.6; // Desktop
  }

  Color _getCategoryColor(String? category) {
    if (category == null) return Colors.grey;

    switch (category.toLowerCase()) {
      case 'darurat':
      case 'emergency':
        return Colors.red;
      case 'pengaduan':
      case 'complaint':
        return Colors.orange;
      case 'informasi':
      case 'information':
        return Colors.blue;
      case 'saran':
      case 'suggestion':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Tanggal tidak tersedia';

    try {
      final parsedDate = DateTime.parse(date).toLocal();
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return date;
    }
  }

  void _playAudio(String? ttsUrl) {
    if (ttsUrl == null || ttsUrl.isEmpty) {
      Get.snackbar(
        'Info',
        'Audio tidak tersedia',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      'Audio',
      'Memutar audio laporan',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    // Implement audio playback logic here
  }

  void _showReportDetail(HistoryReportModel report) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Detail Laporan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildDetailItem(
                  'Pelapor',
                  report.namaLengkap ?? 'Tidak Diketahui',
                ),
                _buildDetailItem(
                  'Kategori',
                  report.category ?? 'Tidak Berkategori',
                ),
                _buildDetailItem(
                  'Deskripsi',
                  report.description ?? 'Tidak ada deskripsi',
                ),
                _buildDetailItem('Tanggal', _formatDate(report.createdAt)),
                if (report.latitude != null && report.longitude != null)
                  _buildDetailItem(
                    'Lokasi',
                    '${report.latitude}, ${report.longitude}',
                  ),
                if (report.desa_id != null)
                  _buildDetailItem('Desa ID', report.desa_id.toString()),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Tutup'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }
}
