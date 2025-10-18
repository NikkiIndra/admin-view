import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const _base = String.fromEnvironment(
    'API_BASE',
    // defaultValue: 'http://10.192.167.57:5000',
    defaultValue: 'http://192.168.0.99:5000',
  );

  static final _storage = const FlutterSecureStorage();

  // ============================================================
  // ================ SESSION STORAGE UTILITIES =================
  // ============================================================

  static Future<void> saveAdminSession(Map<String, dynamic> admin) async {
    await _storage.write(key: "admin_id", value: admin["id"].toString());
    await _storage.write(key: "role", value: admin["role"]);
    await _storage.write(key: "email", value: admin["email"]);
    if (admin.containsKey("desa_id")) {
      await _storage.write(key: "desa_id", value: admin["desa_id"].toString());
    }
  }

  static Future<Map<String, String>> getAdminSession() async {
    final id = await _storage.read(key: "admin_id") ?? "";
    final role = await _storage.read(key: "role") ?? "";
    final desaId = await _storage.read(key: "desa_id") ?? "";
    final email = await _storage.read(key: "email") ?? "";
    return {"admin_id": id, "role": role, "desa_id": desaId, "email": email};
  }

  static Future<void> clearAdminSession() async {
    await _storage.delete(key: "admin_id");
    await _storage.delete(key: "role");
    await _storage.delete(key: "desa_id");
    await _storage.delete(key: "email");
  }

  // ============================================================
  // ==================== HTTP REQUESTS =========================
  // ============================================================

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$_base/$endpoint");
    final headers = {
      "Content-Type": "application/json",
      "Cache-Control": "no-cache, no-store, must-revalidate",
      "Pragma": "no-cache",
      "Expires": "0",
    };

    if (auth) {
      final session = await getAdminSession();
      if (session["admin_id"]!.isNotEmpty) {
        headers["X-User-Id"] = session["admin_id"]!;
        headers["X-User-Role"] = session["role"]!;
        headers["X-Desa-Id"] = session["desa_id"]!;
      }
      print("🧩 getAdminSession() = ${await _storage.readAll()}");
    }

    try {
      final resp = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      print("📡 [GET] $url → ${resp.statusCode}");
      return _handleResponse(resp);
    } on SocketException {
      return {"success": false, "message": "Tidak bisa terhubung ke server."};
    } on TimeoutException {
      return {"success": false, "message": "Waktu koneksi habis (timeout)."};
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$_base/$endpoint");
    final headers = {"Content-Type": "application/json"};

    if (auth) {
      final session = await getAdminSession();
      if (session["admin_id"]!.isNotEmpty) {
        headers["X-User-Id"] = session["admin_id"]!;
        headers["X-User-Role"] = session["role"]!;
        headers["X-Desa-Id"] = session["desa_id"]!;
      }
      print("🧩 getAdminSession() = ${await _storage.readAll()}");
    }

    try {
      final resp = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      print("📡 [POST] $url → ${resp.statusCode}");
      return _handleResponse(resp);
    } on SocketException {
      return {"success": false, "message": "Tidak bisa terhubung ke server."};
    } on TimeoutException {
      return {"success": false, "message": "Waktu koneksi habis (timeout)."};
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$_base/$endpoint");
    final headers = {"Content-Type": "application/json"};

    if (auth) {
      final session = await getAdminSession();
      if (session["admin_id"]!.isNotEmpty) {
        headers["X-User-Id"] = session["admin_id"]!;
        headers["X-User-Role"] = session["role"]!;
        headers["X-Desa-Id"] = session["desa_id"]!;
      }
      print("🧩 getAdminSession() = ${await _storage.readAll()}");
    }

    try {
      final resp = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      print("📡 [PUT] $url → ${resp.statusCode}");
      return _handleResponse(resp);
    } on SocketException {
      return {"success": false, "message": "Tidak bisa terhubung ke server."};
    } on TimeoutException {
      return {"success": false, "message": "Waktu koneksi habis (timeout)."};
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  // ============================================================
  // ==================== RESPONSE HANDLER ======================
  // ============================================================

  static Map<String, dynamic> _handleResponse(http.Response resp) {
    try {
      final decoded = jsonDecode(resp.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {"success": false, "message": "Response tidak valid"};
    } catch (e) {
      return {"success": false, "message": "Response tidak valid: $e"};
    }
  }

  static Future<Map<String, dynamic>> uploadMultipart(
    String endpoint,
    Map<String, String> fields,
    List<File> files, {
    bool auth = false,
    String fileField = 'image',
  }) async {
    final url = Uri.parse("$_base/$endpoint");
    final request = http.MultipartRequest("POST", url);

    // Ambil session dan tambahkan header jika auth diaktifkan
    if (auth) {
      final session = await getAdminSession();

      print("🔐 Auth Headers:");
      print("   - X-User-Id: ${session['admin_id']}");
      print("   - X-User-Role: ${session['role']}");
      print("   - X-Desa-Id: ${session['desa_id']}");
      if (session["admin_id"]!.isNotEmpty) {
        request.headers.addAll({
          "X-User-Id": session["admin_id"]!,
          "X-User-Role": session["role"]!,
          "X-Desa-Id": session["desa_id"]!,
        });
      } else {
        return {
          "success": false,
          "message": "Session tidak valid. Silakan login ulang.",
        };
      }
    }

    // Tambahkan field biasa (misalnya title, description, source)
    request.fields.addAll(fields);

    // Tambahkan file (kalau ada)
    for (final file in files) {
      final multipartFile = await http.MultipartFile.fromPath(
        fileField,
        file.path,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    try {
      // Kirim request
      final streamedResponse = await request.send();
      final respBody = await streamedResponse.stream.bytesToString();

      print("📡 [UPLOAD] $url → ${streamedResponse.statusCode}");
      print("📦 Response body: $respBody");

      // Parse hasil response
      try {
        final decoded = jsonDecode(respBody);
        return decoded is Map<String, dynamic>
            ? decoded
            : {"success": false, "message": "Response tidak valid"};
      } catch (e) {
        return {"success": false, "message": "Gagal decode response: $e"};
      }
    } on SocketException {
      return {"success": false, "message": "Tidak bisa terhubung ke server."};
    } on TimeoutException {
      return {"success": false, "message": "Waktu koneksi habis (timeout)."};
    } catch (e) {
      return {"success": false, "message": "Error upload: $e"};
    }
  }

  // Tambahkan method alternatif di ApiService
  static Future<Map<String, dynamic>> uploadMultipartWithQueryAuth(
    String endpoint,
    Map<String, String> fields,
    List<File> files, {
    String fileField = 'image',
  }) async {
    final session = await getAdminSession();

    // Tambahkan auth data ke fields
    final authFields = {
      ...fields,
      'user_id': session['admin_id']!,
      'role': session['role']!,
      'desa_id': session['desa_id']!,
    };

    return await uploadMultipart(
      endpoint,
      authFields,
      files,
      auth: false, // tidak pakai header
      fileField: fileField,
    );
  }
}
