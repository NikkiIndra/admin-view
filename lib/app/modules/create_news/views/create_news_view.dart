import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/styles/apps_style.dart';
import '../controllers/create_news_controller.dart';

class CreateNewsView extends GetView<CreateNewsController> {
  const CreateNewsView({super.key});

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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent.withOpacity(0.2),
              title: Text(
                'Buat Berita Baru',
                style: AppStyles.bodyTextWhite.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              centerTitle: true,
              floating: true,
              pinned: true,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian kiri (form)
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Judul'),
                          const SizedBox(height: 25),
                          _buildTextField('Isi Berita', maxLines: 15),
                          const SizedBox(height: 25),
                          _buildTextField('Penulis'),
                        ],
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Bagian kanan (unggah gambar)
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: [
                                  // Tampilkan gambar yang sudah dipilih
                                  for (
                                    int i = 0;
                                    i < controller.images.length;
                                    i++
                                  )
                                    Stack(
                                      children: [
                                        Container(
                                          height: 180,
                                          width: 180,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                            image: DecorationImage(
                                              image: FileImage(
                                                File(controller.images[i].path),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 5,
                                          top: 5,
                                          child: GestureDetector(
                                            onTap: () =>
                                                controller.removeImage(i),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  // Tombol tambah gambar (muncul kalau < 2)
                                  if (controller.images.length < 2)
                                    GestureDetector(
                                      onTap: controller.pickImages,
                                      child: Container(
                                        height: 180,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              CupertinoIcons
                                                  .camera_on_rectangle,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Unggah Gambar",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Tombol simpan di kanan bawah
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 180,
        height: 80,
        child: FloatingActionButton.extended(
          onPressed: () async {
            if (controller.titleC.text.isEmpty ||
                controller.descC.text.isEmpty) {
              Get.snackbar("Validasi", "Judul dan isi berita wajib diisi");
              return;
            }
            await controller.uploadNews();
          },
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          label: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.tray_arrow_up,
                color: Colors.black54,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Unggah',
                style: AppStyles.bodyTextWhite.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    final controllerMap = {
      'Judul': controller.titleC,
      'Isi Berita': controller.descC,
      'Penulis': controller.sourceC,
    };

    final textController = controllerMap[label]!;

    return TextFormField(
      controller: textController,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: label,
        labelStyle: AppStyles.bodyTextWhite.copyWith(
          color: Colors.white,
          fontSize: 18,
        ),
        filled: true,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.white54,
        focusColor: Colors.white,
      ),
    );
  }
}
