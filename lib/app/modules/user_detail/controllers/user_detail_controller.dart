import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_admin/app/data/model/user_model.dart';
import '../../../data/service/api_service.dart';

class UserDetailController extends GetxController {
  var isLoading = false.obs;
  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var isSearching = false.obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();

    // Listen perubahan pada search controller
    searchController.addListener(() {
      filterUsers();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      final res = await ApiService.get(
        "users?fields=id,nama_lengkap,email,rt,rw,blok,role,desa_id,createdAt",
        auth: true,
      );

      if (res["success"] == true && res["data"] != null) {
        final List<dynamic> data = res["data"];
        users.value = data.map((u) => UserModel.fromJson(u)).toList();
        filteredUsers.value = users; // Set filteredUsers dengan data awal
        print("📋 Data user dari server:");
        for (final u in users) {
          print(" - ${u.name} (${u.email}) (${u.desa_id})");
        }
      } else {
        Get.snackbar("Error", res["message"] ?? "Gagal memuat data user");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterUsers() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users.where((user) {
        final name = user.name?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
    }
  }

  void closeSearch() {
    isSearching.value = false;
    searchController.clear();
  }
}
