import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/report_history_controller.dart';

class ReportHistoryView extends GetView<ReportHistoryController> {
  const ReportHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchMessages();

    return Scaffold(
      appBar: AppBar(title: Text("Daftar Laporan")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.messages.isEmpty) {
          return Center(child: Text("Belum ada laporan"));
        }
        return ListView.builder(
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final msg = controller.messages[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text(msg.category ?? "-"),
                subtitle: Column(
                  children: [
                    Text(msg.description ?? ""),
                    Text("Desa: ${msg.desa_id ?? '-'} "),
                  ],
                ),
                trailing: Text(msg.namaLengkap ?? "-"),
              ),
            );
          },
        );
      }),
    );
  }
}
