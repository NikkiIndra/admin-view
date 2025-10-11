import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportScreen extends StatefulWidget {
  final String token; // JWT token setelah login
  const ReportScreen({super.key, required this.token});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final baseUrl = "http://192.168.0.99:5000/report"; // ganti sesuai IP server
  String result = "";

  Future<void> sendQuick(String category) async {
    final url = Uri.parse("$baseUrl/sirine/quick");
    final resp = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode({"category": category}),
    );
    setState(() => result = resp.body);
  }

  Future<void> sendManual(
    String category,
    String name,
    String rt,
    String rw,
    String blok,
  ) async {
    final url = Uri.parse("$baseUrl/sirine/manual");
    final resp = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode({
        "category": category,
        "reported_name": name,
        "reported_rt": rt,
        "reported_rw": rw,
        "reported_blok": blok,
      }),
    );
    setState(() => result = resp.body);
  }

  Future<void> sendHelp(
    String category,
    double lat,
    double lng,
    String desc,
  ) async {
    final url = Uri.parse("$baseUrl/help");
    final resp = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode({
        "category": category,
        "lat": lat,
        "lng": lng,
        "description": desc,
      }),
    );
    setState(() => result = resp.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Menu")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => sendQuick("kebakaran"),
              child: const Text("Sirine Cepat - Kebakaran"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  sendManual("pencurian", "Pak Budi", "01", "02", "A3"),
              child: const Text("Sirine Manual - Pencurian"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => sendHelp(
                "kebutuhan_medis",
                -6.2,
                106.8,
                "Ibu hamil butuh ambulan",
              ),
              child: const Text("Help Request - Medis"),
            ),
            const SizedBox(height: 20),
            Text("Response:\n$result", style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
