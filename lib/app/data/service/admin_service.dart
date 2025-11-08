import 'package:get/get.dart';
import 'package:multi_admin/app/data/model/report_model.dart';
import 'package:multi_admin/app/modules/admin_maps_report/controllers/admin_maps_report_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'api_service.dart';

class AdminService extends GetxService {
  static AdminService get instance => Get.find<AdminService>();

  IO.Socket? socket;
  var isConnected = false.obs;
  var latestReport = Rxn<Map<String, dynamic>>();

  
  late final AdminMapsReportController mapController; 

  @override
  void onInit() {
    super.onInit();
    // Jangan langsung initSocket() di sini, biarkan dipanggil setelah login.
    mapController = Get.find<AdminMapsReportController>();
    print("🟡 AdminService siap, menunggu login...");
  }

  /// Dipanggil dari SigninController setelah login sukses
  Future<void> initSocket() async {
    try {
      final session = await ApiService.getAdminSession();

      final userId = session['id'] ?? session['admin_id'];
      final desaId = session['desa_id'] ?? session['desaId'];
      final role = session['role'] ?? session['user_role'];
      final token = session['access_token'];

      if (userId == null || desaId == null) {
        print("⚠️ Tidak bisa inisialisasi socket: user belum login");
        print("📋 Session detail: $session");
        return;
      }

      // Jika sudah ada koneksi lama, putus dulu
      if (socket != null && socket!.connected) {
        print(
          "🔌 Socket lama ditemukan, memutus koneksi sebelum membuat baru...",
        );
        socket!.disconnect();
      }

      print(
        "⚙️ Membuat koneksi socket untuk user=$userId desa=$desaId role=$role",
      );

      socket = IO.io(
        'http://192.168.137.1:5000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({
              'token': token,
              'user_id': userId.toString(),
              'desa_id': desaId.toString(),
              'role': role,
            })
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(2000)
            .build(),
      );

      // --- EVENT LISTENER ---
      socket!.onConnect((_) {
        isConnected.value = true;
        print('✅ Socket terhubung untuk admin desa $desaId');
        socket!.emit('join_room', {'desa_id': desaId, 'user_id': userId});
        print('🟢 Joined room desa_$desaId');
      });

      socket!.onReconnect((_) {
        print('♻️ Reconnected ke server');
        socket!.emit('join_room', {'desa_id': desaId, 'user_id': userId});
      });

      socket!.onDisconnect((_) {
        isConnected.value = false;
        print('🔴 Socket terputus');
      });

      socket!.onConnectError((err) => print('❌ Connect error: $err'));
      socket!.onError((err) => print('⚠️ Socket error: $err'));

      // Event laporan baru
      socket!.on('new_report', (data) {
        try {
          final parsed = Map<String, dynamic>.from(data);
          latestReport.value = parsed;

          // ✅ Pastikan model benar-benar diubah dan memicu UI
          final reportModel = ReportModel.fromJson(parsed);
          mapController.activeReport.value = reportModel;

                    // ✅ Tambahkan marker baru di peta
          mapController.addReportMarker(reportModel);

          Get.snackbar(
            '📢 Laporan Baru',
            '${parsed['nama_pelapor']} - ${parsed['jenis_laporan']}',
            duration: const Duration(seconds: 3),
          );

          print('📡 [SOCKET] Laporan baru diterima: $parsed');
        } catch (e) {
          print("⚠️ Gagal parsing event 'new_report': $e");
        }
      });

      socket!.connect();
    } catch (e) {
      print('💥 Error initializing WebSocket: $e');
      Future.delayed(const Duration(seconds: 3), () async {
        print("🔁 Coba ulang initSocket setelah 3 detik...");
        await initSocket();
      });
    }
  }

  // Ambil laporan lewat HTTP (fallback)
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

  void clearReport() {
    latestReport.value = null;
  }

  @override
  void onClose() {
    socket?.disconnect();
    print("🛑 Socket ditutup oleh AdminService");
    super.onClose();
  }
}
