import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:multi_admin/app/modules/tren_report_location/controllers/tren_report_location_controller.dart';
import 'package:multi_admin/app/routes/app_pages.dart';

import '../controllers/admin_view_controller.dart';

class AdminView extends GetView<AdminController> {
  AdminView({super.key});
  final controllerTrenreport = Get.find<TrenReportLocationController>();

  // Hapus late final dan gunakan GetX reactive approach
  // int get totalReports => controllerTrenreport.reportPoints.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0XFF0800FF), Color(0XFF444861)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 80),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    // KIRI (Ringkasan + tombol)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.search, size: 20),
                                filled: true,
                                fillColor: Colors.white30,
                                focusColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                prefixIconColor: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Kotak laporan utama
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: constraints.maxHeight * 0.35,
                                    decoration: BoxDecoration(
                                      color: Colors.white30,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Matikan interaksi map tapi tampilkan tampilannya
                                        IgnorePointer(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: FlutterMap(
                                              options: const MapOptions(
                                                initialCenter: LatLng(
                                                  -6.2088,
                                                  106.8456,
                                                ),
                                                initialZoom: 13,
                                              ),
                                              children: [
                                                TileLayer(
                                                  urlTemplate:
                                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                  userAgentPackageName:
                                                      'com.example.admin',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Lapisan klik di atas map
                                        Positioned.fill(
                                          child: GestureDetector(
                                            onTap: () async {
                                              await controllerTrenreport
                                                  .fetchTrenReport();
                                              Get.toNamed(
                                                Routes.TREN_REPORT_LOCATION,
                                              );
                                            },
                                            child: Container(
                                              color: Colors
                                                  .transparent, // penting biar bisa nangkep tap
                                            ),
                                          ),
                                        ),

                                        // PERBAIKAN: Gunakan Obx untuk reactive updates
                                        Center(
                                          child: Obx(() {
                                            final totalReports =
                                                controllerTrenreport
                                                    .reportPoints
                                                    .length;
                                            return Container(
                                              height: 100,
                                              width: 100,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withOpacity(0.85),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Total $totalReports\nlaporan masuk ',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: constraints.maxHeight * 0.17,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "data Pelapor",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              ElevatedButton(
                                                onPressed: () => Get.toNamed(
                                                  Routes.REPORT_HISTORY,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF2A36EE,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  "data",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: constraints.maxHeight * 0.16,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Detail Warga Terdaftar",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () => Get.toNamed(
                                                    Routes.USER_DETAIL,
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF2A36EE),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "lihat",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Ringkasan laporan
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      _ReportSummary(
                                        label: "Hari ini",
                                        value: "23",
                                      ),
                                      _ReportSummary(
                                        label: "Minggu-4",
                                        value: "120",
                                      ),
                                      _ReportSummary(
                                        label: "Bulan Juli",
                                        value: "254",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // KANAN (Grafik + Statistik)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Grafik tren waktu
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Grafik Tren Waktu",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Statistik total laporan
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  "Total Laporan Sepanjang Waktu",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportSummary extends StatelessWidget {
  final String label;
  final String value;

  const _ReportSummary({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
