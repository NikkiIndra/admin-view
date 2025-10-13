import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/modules/navbar/views/navbar_view.dart';
import 'package:multi_admin/app/modules/news_uploads/views/news_detail_view.dart';
import '../../../data/model/news_model.dart';
import '../controllers/news_uploads_controller.dart';

class NewsUploadsView extends GetView<NewsUploadsController> {
  const NewsUploadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0XFF0800FF), Color(0XFF444861)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 100, right: 20, top: 20),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.newsList.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada berita untuk desa ini.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final news = controller.newsList;
            final mainNews = news.first;
            final subNews = news.length > 3 ? news.sublist(1, 3) : [];
            final rightNews = news.length > 3
                ? news.sublist(3, 9)
                : news.skip(1).toList();
            final gridNews = news.length > 9
                ? news.sublist(9)
                : []; // sisanya di bawah

            return SingleChildScrollView(
              child: Column(
                children: [
                  // 🔹 Bagian atas: berita utama + grid kanan
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kiri
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildMainNewsCard(mainNews),
                            const SizedBox(height: 16),
                            if (subNews.isNotEmpty)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.3,
                                    ),
                                itemCount: subNews.length,
                                itemBuilder: (context, index) =>
                                    _buildSmallNewsCard(subNews[index]),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Kanan
                      Expanded(
                        flex: 5,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.1,
                              ),
                          itemCount: rightNews.length,
                          itemBuilder: (context, index) =>
                              _buildSmallNewsCard(rightNews[index]),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Bagian bawah: grid 5 kolom scrollable
                  if (gridNews.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Berita Lainnya",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: gridNews.length,
                      itemBuilder: (context, index) =>
                          _buildSmallNewsCard(gridNews[index]),
                    ),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // 🔹 Card Berita Utama
  Widget _buildMainNewsCard(NewsModel news) {
    return GestureDetector(
      onTap: () => Get.to(() => const NewsDetailView(), arguments: news),
      child: Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent.withOpacity(0.2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 6,
                  child: (news.imageUrl != null && news.imageUrl!.isNotEmpty)
                      ? Image.network(
                          news.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              Container(color: Colors.grey[800]),
                        )
                      : _buildImagePlaceholder(),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(color: AppColors.white35),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              news.title ?? '(Tanpa Judul)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              news.description ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 🔹 Tombol titik tiga
            Positioned(right: 8, top: 8, child: _buildPopupMenu(news)),
          ],
        ),
      ),
    );
  }

  // 🔹 Card Berita Kecil
  Widget _buildSmallNewsCard(NewsModel news) {
    return GestureDetector(
      onTap: () => Get.to(() => const NewsDetailView(), arguments: news),
      child: Container(
        decoration: BoxDecoration(
          // color: AppColors.darkBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Isi card
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 7,
                  child: (news.imageUrl != null && news.imageUrl!.isNotEmpty)
                      ? Image.network(
                          news.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImagePlaceholder(),
                        )
                      : _buildImagePlaceholder(),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    child: Text(
                      news.title ?? '(Tanpa Judul)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),

            // 🔹 Tombol titik 3 di kanan atas
            Positioned(right: 4, top: 4, child: _buildPopupMenu(news)),
          ],
        ),
      ),
    );
  }

  /// 🔹 Placeholder jika tidak ada gambar
  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white30,
          size: 40,
        ),
      ),
    );
  }

  /// 🔹 Widget popup menu (Edit & Delete)
  Widget _buildPopupMenu(NewsModel news) {
    return PopupMenuButton<String>(
      color: const Color(0xFF1E215A),
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'edit') {
          Get.snackbar('Edit', 'Fitur edit untuk "${news.title}"');
          // TODO: Navigasi ke halaman edit, misalnya:
          // Get.toNamed('/edit-news', arguments: news);
        } else if (value == 'delete') {
          _showDeleteConfirmation(news);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.white70, size: 18),
              SizedBox(width: 8),
              Text('Edit', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
              SizedBox(width: 8),
              Text('Hapus', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 Konfirmasi hapus
  void _showDeleteConfirmation(NewsModel news) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E215A),
        title: const Text(
          'Konfirmasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Yakin ingin menghapus berita "${news.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // tutup dialog
              // TODO: Panggil fungsi delete ke API di sini
              Get.snackbar('Hapus', 'Berita "${news.title}" dihapus.');
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
