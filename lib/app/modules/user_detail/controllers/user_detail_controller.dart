import 'package:get/get.dart';
import 'package:multi_admin/app/data/model/user_model.dart';

import '../../../data/service/api_service.dart';

class UserDetailController extends GetxController {
  var isLoading = false.obs;
  var users = <UserModel>[].obs;

  // coba dulu lalu
  // var isLoading akan di set true supaya bisa menampilkan laoding nantinya
  // kita buat var response utnukmendapatkan feedback dari server
  // jika value dari response itu success maka kita akan memasukan data dari response ke var list data
  // value user di isis valible data yang typenya list tadi
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      // pastikan token tersimpan
      final token = await ApiService.getToken();
      print("🧩 Token dari storage: $token");

      final res = await ApiService.get(
        "users?fields=id,nama_lengkap,email,rt,rw,blok,role,desa_id",
        auth: true,
      );

      if (res["success"] == true && res["data"] != null) {
        final List<dynamic> data = res["data"];
        users.value = data.map((u) => UserModel.fromJson(u)).toList();
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
}
