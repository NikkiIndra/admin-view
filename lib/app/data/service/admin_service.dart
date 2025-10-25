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
    initSocket();
  }

  Future<void> initSocket() async {
    try {
      final user = await ApiService.getAdminSession();
      final userId = user['id'];
      final desaId = user['desa_id'];
      final role = user['role'];

      // Cegah connect kalau data user belum lengkap
      if (userId == null || desaId == null) {
        print("⚠️ Tidak bisa inisialisasi socket: user belum login");
        return;
      }

      socket = IO.io(
        'http://192.168.137.146:5000?user_id=$userId&desa_id=$desaId&role=$role',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection() // 🔁 aktifkan auto reconnect
            .setReconnectionAttempts(10)
            .setReconnectionDelay(2000)
            .build(),
      );

      socket.onConnect((_) {
        isConnected.value = true;
        print('✅ SOCKET CONNECTED');

        // Join ke room sesuai desa admin
        socket.emit('join_room', {'desa_id': desaId, 'user_id': userId});
        print('🟢 Joined room desa_$desaId');
      });

      socket.onReconnect((_) {
        print('♻️ Reconnected ke server');
        socket.emit('join_room', {'desa_id': desaId, 'user_id': userId});
      });

      socket.onDisconnect((_) {
        isConnected.value = false;
        print('🔴 Socket disconnected');
      });

      socket.onConnectError((err) => print('❌ Connect error: $err'));
      socket.onError((err) => print('⚠️ Socket error: $err'));

      // 🔔 Event laporan baru dari server
      socket.on('new_report', (data) {
        try {
          final parsed = Map<String, dynamic>.from(data);
          latestReport.value = parsed;

          Get.snackbar(
            '📢 Laporan Baru',
            '${parsed['nama_pelapor']} - ${parsed['jenis_laporan']}',
            duration: const Duration(seconds: 3),
          );
        } catch (e) {
          print("⚠️ Gagal parsing event 'new_report': $e");
        }
      });
    } catch (e) {
      print('💥 Error initializing WebSocket: $e');
      // 🔁 Coba lagi 3 detik kemudian
      Future.delayed(const Duration(seconds: 3), initSocket);
    }
  }

  // Fallback HTTP fetch (ambil laporan terbaru)
  Future<List<Map<String, dynamic>>> fetchReports({
    String status = 'baru',
  }) async {
    final resp = await ApiService.get('api/report/list/$status', auth: true);
    if (resp['status'] == 'success') {
      final data = resp['data'] as List;
      return data
          .map<Map<String, dynamic>>(
            (e) => {
              'id': e['id'],
              'jenis_laporan': e['jenis_laporan'],
              'nama_pelapor': e['nama_pelapor'],
              'alamat': e['alamat'],
              'deskripsi': e['deskripsi'],
              'latitude': double.tryParse(e['latitude'].toString()) ?? 0.0,
              'longitude': double.tryParse(e['longitude'].toString()) ?? 0.0,
              'status': e['status'],
              'created_at': e['created_at'],
            },
          )
          .toList();
    }
    return [];
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
