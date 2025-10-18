// // lib/data/service/admin_service.dart
// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'api_service.dart';

// class AdminService extends GetxService {
//   static AdminService get instance => Get.find<AdminService>();

//   late IO.Socket socket;
//   var isConnected = false.obs;
//   var latestReport = Rxn<Map<String, dynamic>>();

//   @override
//   void onInit() {
//     super.onInit();
//     initSocket(); // Akan auto dipanggil ketika service di-init
//   }

//   Future<void> initSocket() async {
//     try {
//       // Get token dari secure storage
//       final token = await ApiService.getToken();
//       print('🔑 Token for WebSocket: $token');

//       socket = IO.io(
//         'http://192.168.0.99:5000',
//         // 'http://10.192.167.57:5000',
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .enableAutoConnect()
//             .setExtraHeaders({'Authorization': 'Bearer $token'})
//             .build(),
//       );

//       socket.onConnect((_) {
//         print('✅ Admin WebSocket connected');
//         isConnected.value = true;
//       });

//       socket.onDisconnect((_) {
//         print('❌ Admin WebSocket disconnected');
//         isConnected.value = false;
//       });

//       // Listen untuk event new_report dari server
//       socket.on('new_report', (data) {
//         print('📢 New report received: $data');
//         if (data is Map<String, dynamic>) {
//           latestReport.value = data;

//           // Show notification
//           Get.snackbar(
//             'Laporan Baru',
//             '${data['data']['pelapor']} - ${data['data']['category']}',
//             duration: Duration(seconds: 10),
//             snackPosition: SnackPosition.TOP,
//           );
//         }
//       });

//       socket.onError((error) => print('WebSocket error: $error'));
//     } catch (e) {
//       print('Error initializing WebSocket: $e');
//     }
//   }

//   // Method untuk fetch data awal (fallback)
//   static Future<Map<String, dynamic>?> getLatestReport() async {
//     final res = await ApiService.get("laporan-terbaru", auth: true);
//     if (res["success"] == true) {
//       return res["report"];
//     }
//     return null;
//   }

//   @override
//   void onClose() {
//     socket.disconnect();
//     super.onClose();
//   }
// }
// lib/data/service/admin_service.dart
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'api_service.dart';

class AdminService extends GetxService {
  static AdminService get instance => Get.find<AdminService>();

  late IO.Socket socket;
  var isConnected = false.obs;
  var latestReport = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    initSocket(); // Akan auto dipanggil ketika service di-init
  }

  Future<void> initSocket() async {
    try {
      // Jika tidak pakai token, langsung connect saja
      socket = IO.io(
        'http://192.168.0.99:5000', // ganti IP sesuai server Flask kamu
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build(),
      );

      socket.onConnect((_) {
        print('✅ Admin WebSocket connected');
        isConnected.value = true;
      });

      socket.onDisconnect((_) {
        print('❌ Admin WebSocket disconnected');
        isConnected.value = false;
      });

      // Listen event laporan baru dari server
      socket.on('new_report', (data) {
        print('📢 New report received: $data');
        if (data is Map<String, dynamic>) {
          latestReport.value = data;

          // Tampilkan notifikasi snackbar
          Get.snackbar(
            'Laporan Baru',
            '${data['data']['pelapor']} - ${data['data']['category']}',
            duration: const Duration(seconds: 10),
            snackPosition: SnackPosition.TOP,
          );
        }
      });

      socket.onError((error) => print('WebSocket error: $error'));
    } catch (e) {
      print('Error initializing WebSocket: $e');
    }
  }

  // Fetch fallback data (tanpa token)
  static Future<Map<String, dynamic>?> getLatestReport() async {
    final res = await ApiService.get("laporan-terbaru"); // auth: true dihapus
    if (res["success"] == true) {
      return res["report"];
    }
    return null;
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
