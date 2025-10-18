import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controller/chart_controller.dart';

class TimeTrendChart extends GetView<ChartController> {
  const TimeTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Berikan height tetap
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.chartData.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada data grafik",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final chartData = controller.getFormattedChartData();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Gunakan MainAxisSize.min
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan total laporan
              _buildHeader(controller.totalReports.value),
              const SizedBox(height: 8),

              // Legend
              _buildLegend(),
              const SizedBox(height: 16),

              // Chart dengan height tetap
              SizedBox(
                height: 180, // Height tetap untuk chart
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: _getMaxY(chartData) / 5,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white.withOpacity(0.1),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.white.withOpacity(0.1),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < chartData.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  chartData[index]['month'],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: _getMaxY(chartData) / 5,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    minX: 0,
                    maxX: (chartData.length - 1).toDouble(),
                    minY: 0,
                    maxY: _getMaxY(chartData),
                    lineBarsData: [
                      // Line Kemalingan
                      LineChartBarData(
                        spots: _getSpots(chartData, 'kemalingan'),
                        isCurved: true,
                        color: const Color(0xFFFF6B6B),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // Line Medis
                      LineChartBarData(
                        spots: _getSpots(chartData, 'medis'),
                        isCurved: true,
                        color: const Color(0xFF4ECDC4),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // Line Kebakaran
                      LineChartBarData(
                        spots: _getSpots(chartData, 'kebakaran'),
                        isCurved: true,
                        color: const Color(0xFFFFD166),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(int totalReports) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Grafik Tren Laporan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Total: $totalReports",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem("Kemalingan", const Color(0xFFFF6B6B)),
        _buildLegendItem("Medis", const Color(0xFF4ECDC4)),
        _buildLegendItem("Kebakaran", const Color(0xFFFFD166)),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  List<FlSpot> _getSpots(List<Map<String, dynamic>> data, String category) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return FlSpot(index.toDouble(), (item[category] as int).toDouble());
    }).toList();
  }

  double _getMaxY(List<Map<String, dynamic>> data) {
    int maxValue = 0;
    for (var item in data) {
      final total =
          (item['kemalingan'] as int) +
          (item['medis'] as int) +
          (item['kebakaran'] as int);
      if (total > maxValue) maxValue = total;
    }
    // Tambahkan margin 20% di atas nilai maksimum
    return (maxValue * 1.2).ceilToDouble();
  }
}
