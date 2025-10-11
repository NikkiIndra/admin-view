import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_detail_controller.dart';

class UserDetailView extends GetView<UserDetailController> {
  const UserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchUsers(); // ambil data saat pertama kali tampil

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar User")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.users.isEmpty) {
          return const Center(child: Text("Belum ada user."));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchUsers,
          child: ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final u = controller.users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(u.name?.substring(0, 1).toUpperCase() ?? "?"),
                  ),
                  title: Text(u.name ?? "Tanpa Nama"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.email ?? "-"),
                      Text(
                        "RT ${u.rt ?? '-'} / RW ${u.rw ?? '-'} • Blok ${u.blok ?? '-'}",
                      ),
                      Text(
                        "Role : ${u.role ?? '-'} || ${'desa id : ${u.desa_id ?? '-'}'}",
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
