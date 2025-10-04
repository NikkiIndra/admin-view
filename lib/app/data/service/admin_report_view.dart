import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

double haversine(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371; // radius bumi km
  final dLat = (lat2 - lat1) * pi / 180;
  final dLon = (lon2 - lon1) * pi / 180;

  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) *
          cos(lat2 * pi / 180) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

Future<List<LatLng>> getRouteORS(
  double startLat,
  double startLon,
  double endLat,
  double endLon,
  String apiKey,
) async {
  final url = Uri.parse(
    "https://api.openrouteservice.org/v2/directions/driving-car"
    "?api_key=$apiKey&start=$startLon,$startLat&end=$endLon,$endLat",
  );

  final res = await http.get(url);
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    final coords = data["features"][0]["geometry"]["coordinates"] as List;
    return coords.map((c) => LatLng(c[1], c[0])).toList();
  } else {
    throw Exception("Gagal ambil rute: ${res.body}");
  }
}

class AdminReportView extends StatefulWidget {
  final double desaLat;
  final double desaLon;
  final double userLat;
  final double userLon;
  final String kategori;
  final String namaPelapor;
  final String alamatPelapor;
  final String orsKey;

  const AdminReportView({
    super.key,
    required this.desaLat,
    required this.desaLon,
    required this.userLat,
    required this.userLon,
    required this.kategori,
    required this.namaPelapor,
    required this.alamatPelapor,
    required this.orsKey,
  });

  @override
  State<AdminReportView> createState() => _AdminReportViewState();
}

class _AdminReportViewState extends State<AdminReportView> {
  List<LatLng> route = [];
  double distance = 0;
  int etaMinutes = 0;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final r = await getRouteORS(
      widget.desaLat,
      widget.desaLon,
      widget.userLat,
      widget.userLon,
      widget.orsKey,
    );

    setState(() {
      route = r;
      distance = haversine(
        widget.desaLat,
        widget.desaLon,
        widget.userLat,
        widget.userLon,
      );
      etaMinutes = (distance / 40 * 60).round(); // rata2 40 km/h
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.green,
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          child: Text(
            widget.kategori,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Distance: ${distance.toStringAsFixed(2)} km"),
              Text("ETA: $etaMinutes menit"),
              const SizedBox(height: 10),
              Text("Pelapor: ${widget.namaPelapor}"),
              Text(widget.alamatPelapor),
            ],
          ),
        ),
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(widget.desaLat, widget.desaLon),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.desaLat, widget.desaLon),
                    child: const Icon(Icons.home, color: Colors.blue, size: 40),
                  ),
                  Marker(
                    point: LatLng(widget.userLat, widget.userLon),
                    child: const Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
              if (route.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(points: route, color: Colors.blue, strokeWidth: 4),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
