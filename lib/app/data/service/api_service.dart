import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://192.168.0.99:5000',
  );
  static final _storage = FlutterSecureStorage();
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$_base/$endpoint");
    final headers = {"Content-Type": "application/json"};
    if (auth) {
      final token = await _storage.read(key: "access_token");
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    final resp = await http.get(url, headers: headers);
    return _handleResponse(resp);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final url = Uri.parse("$_base/$endpoint");
    final headers = {"Content-Type": "application/json"};
    if (auth) {
      final token = await _storage.read(key: "access_token");
      print("🔑 Token yg dikirim: $token"); // <-- tambahin debug ini
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    final resp = await http.post(url, headers: headers, body: jsonEncode(body));
    print("📡 Status: ${resp.statusCode}, Body: ${resp.body}"); // debug juga
    return _handleResponse(resp);
  }

  static Map<String, dynamic> _handleResponse(http.Response resp) {
    final text = resp.body;
    try {
      final json = jsonDecode(text);
      return json is Map<String, dynamic>
          ? json
          : Map<String, dynamic>.from(json as Map);
      // return json is Map ? json : {"success": false, "message": "Invalid response"};
    } catch (e) {
      return {
        "success": false,
        "message": "Non-JSON response: ${resp.statusCode}",
      };
    }
  }

  static Future<void> saveToken(String token) =>
      _storage.write(key: "access_token", value: token);
  static Future<void> clearToken() => _storage.delete(key: "access_token");
  static Future<String?> getToken() => _storage.read(key: "access_token");
}
