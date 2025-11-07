import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:multi_admin/app/modules/admin_maps_report/views/admin_maps_report_view.dart';
import 'package:multi_admin/app/modules/navbar/views/navbar_view.dart';
import 'package:multi_admin/app/modules/tren_report_location/controllers/tren_report_location_controller.dart';
import 'package:multi_admin/app/routes/app_pages.dart';
import 'package:multi_admin/app/styles/apps_style.dart';

import '../../../controller/chart_controller.dart';
import '../../../controller/report_summary_controller.dart';
import '../../../widgets/grafik_multiline.dart';
import '../../../widgets/report_summary.dart';
import '../controllers/admin_view_controller.dart';

class AdminView extends GetView<AdminController> {
  AdminView({super.key});
  late final controllerTrenreport = Get.find<TrenReportLocationController>();
  late final controllerR = Get.find<ReportSummaryController>();
  late final trenMapsC = Get.find<TrenReportLocationController>();
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
                                    height: constraints.maxHeight * 0.45,
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
                                        Positioned(
                                          top: 5,
                                          left: 5,
                                          right: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.60,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            height:
                                                constraints.maxHeight * 0.05,
                                            width: constraints.maxWidth,
                                            child: Center(
                                              child: Text(
                                                "Tren Lokasi Laporan Emergency",
                                                style: AppStyles.bodyTextWhite
                                                    .copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
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
                                              height: 120,
                                              width: 130,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withOpacity(0.55),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text.rich(
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Total ',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '$totalReports',
                                                        style: const TextStyle(
                                                          color: Colors
                                                              .yellowAccent,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text:
                                                            ' tombol emergency digunakan',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: constraints.maxHeight * 0.25,
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBlue,
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
                                                "detail warga yang menggunakan tombol emergency",
                                                textAlign: TextAlign.center,
                                                style: AppStyles.authText
                                                    .copyWith(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              SizedBox(height: 50),
                                              ElevatedButton(
                                                onPressed: () => Get.toNamed(
                                                  Routes.REPORT_HISTORY,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.deepPurpleAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  elevation: 3,
                                                  shadowColor: Colors.black,
                                                ),
                                                child: Text(
                                                  "Lihat Data Pelapor",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Container(
                                        height: constraints.maxHeight * 0.16,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBlue,
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
                                                "Warga yang sudah terdaftar",
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
                                                        Colors.deepPurpleAccent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "lihat data warga",
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
                              child: Obx(() {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ringkasan Laporan Dalam Bulan Ini",
                                      style: AppStyles.bodyTextWhite,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ReportSummary(
                                          label: "Hari ini",
                                          value: controllerR.isLoading.value
                                              ? "0"
                                              : controllerR.todayCount.value
                                                    .toString(),
                                          isLoading:
                                              controllerR.isLoading.value,
                                        ),
                                        ReportSummary(
                                          label: controllerR.currentWeek.value,
                                          value: controllerR.isLoading.value
                                              ? "0"
                                              : controllerR.weekCount.value
                                                    .toString(),
                                          isLoading:
                                              controllerR.isLoading.value,
                                        ),
                                        ReportSummary(
                                          label:
                                              "Bulan ${controllerR.currentMonth.value}",
                                          value: controllerR.isLoading.value
                                              ? "0"
                                              : controllerR.monthCount.value
                                                    .toString(),
                                          isLoading:
                                              controllerR.isLoading.value,
                                        ),
                                        ReportSummary(
                                          label:
                                              "Tahun ${controllerR.currentYear.value}",
                                          value: controllerR.isLoading.value
                                              ? "0"
                                              : controllerR.yearTotal.value
                                                    .toString(),
                                          isLoading:
                                              controllerR.isLoading.value,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
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
                          children: [
                            // Grafik tren waktu
                            GetBuilder<ChartController>(
                              init: ChartController(),
                              builder: (controller) {
                                return const TimeTrendChart();
                              },
                            ),
                            const SizedBox(height: 16),
                            // Statistik total laporan
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.ADMIN_MAPS_REPORT);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 65),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    clipBehavior: Clip
                                        .antiAlias, // biar radiusnya nge-clip
                                    child: Stack(
                                      children: [
                                        // langsung tampilkan peta mini di dalam container
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: AdminMapsReportView(
                                            isPreview: true,
                                          ),
                                        ),

                                        // overlay teks di tengah
                                        Positioned(
                                          top: 10,
                                          left: 20,
                                          right: 20,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.05,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.3,
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "klik untuk memperbesar peta",
                                              style: AppStyles.authText
                                                  .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = Get.find<ChartController>();
          await controllerR.refreshSummary();
          await controller.chartRefresh();
          await trenMapsC.refreshMap();
          // Force UI update
          controller.update();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
