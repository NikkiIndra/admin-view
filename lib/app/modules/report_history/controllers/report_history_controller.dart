import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/history_report_model.dart';
import '../../../data/service/api_service.dart';

class ReportHistoryController extends GetxController {
  var isLoading = false.obs;
  var messages = <HistoryReportModel>[].obs;
  var filteredMessages = <HistoryReportModel>[].obs;
  var isSearching = false.obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchMessages();

    searchController.addListener(() {
      filterMessages();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final res = await ApiService.get(
        // '/messages',
        'messages?fields=m.id,m.description,m.category,m.tts_url,m.created_at,m.latitude,m.longitude,u.nama_lengkap,u.desa_id',
        auth: true,
      );

      if (res["success"] == true && res["data"] != null) {
        final List<dynamic> data = res["data"];
        messages.value = data
            .map((m) => HistoryReportModel.fromJson(m))
            .toList();
        // Di dalam fetchMessages, setelah messages.value = ...
        print("🔍 DEBUG - Struktur data pertama:");
        if (data.isNotEmpty) {
          print(data.first.keys.toList()); // Print semua keys
          print("Nama lengkap value: ${data.first['nama_lengkap']}");
        }
        filteredMessages.value = messages;
        print("📋 Data laporan dari server:");
        for (final msg in messages) {
          print(
            " - ${msg.namaLengkap} (${msg.category}) - Lat:${msg.latitude}, Long:${msg.longitude}",
          );
        }

        // Debug: print struktur data dari API
        print("🔍 Struktur data API:");
        if (data.isNotEmpty) {
          print(data.first);
        }
      } else {
        Get.snackbar("Error", "${res["message"]}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterMessages() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredMessages.value = messages;
    } else {
      filteredMessages.value = messages.where((message) {
        final nama = message.namaLengkap?.toLowerCase() ?? '';
        final category = message.category?.toLowerCase() ?? '';
        final description = message.description?.toLowerCase() ?? '';

        return nama.contains(query) ||
            category.contains(query) ||
            description.contains(query);
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
