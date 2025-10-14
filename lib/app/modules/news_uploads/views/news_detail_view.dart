import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/modules/navbar/views/navbar_view.dart';
import '../../../data/model/news_model.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsModel? news = Get.arguments as NewsModel?;

    if (news == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Tidak ada data berita yang dikirim.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white35,
        title: const Text('Detail Berita'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0XFF0800FF), Color(0XFF444861)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Gambar utama (aman jika null atau 404)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: (news.imageUrl != null && news.imageUrl!.isNotEmpty)
                    ? Image.network(
                        news.imageUrl!,
                        width: 400,
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) =>
                            const SizedBox(),
                      )
                    : const SizedBox(
                        height: 200,
                        width: 400,
                      ), // 🔹 jika tidak ada gambar, kosong saja
              ),

              const SizedBox(height: 20),

              // 🔹 Judul
              Text(
                news.title ?? '(Tanpa Judul)',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // 🔹 Info meta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Author : ${news.source ?? 'Admin Desa'}   ",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Create at : ${news.createdAt?.toLocal().toString().split(' ').first ?? '-'}   ",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Visitor : ${news.visitors ?? '0'} Views",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 🔹 Deskripsi panjang
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    news.description ?? '(Tidak ada deskripsi)',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
