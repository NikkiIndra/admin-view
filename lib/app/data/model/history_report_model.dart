class HistoryReportModel {
  int? id;
  String? description;
  String? category;
  String? ttsUrl;
  String? createdAt;
  double? latitude;
  double? longitude;
  String? namaLengkap;
  int? desa_id;
  DateTime? createdDate;

  HistoryReportModel({
    this.id,
    this.description,
    this.category,
    this.ttsUrl,
    this.createdAt,
    this.latitude,
    this.longitude,
    this.namaLengkap,
    this.desa_id,
    this.createdDate,
  });

  factory HistoryReportModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['created_at'] != null) {
      try {
        // PERBAIKAN: Coba parse string, dan konversi ke waktu lokal.
        // Ini akan mengatasi masalah jika timestamp server dikirim
        // tanpa indikator zona waktu yang benar.
        // Jika server mengirim UTC, Dart akan mengkonversinya dengan benar.
        // Kita HILANGKAN .toUtc().toLocal() yang bisa menyebabkan double konversi
        // jika string dari server sudah dianggap waktu lokal.
        parsedDate = DateTime.parse(
          json['created_at'],
        ).toLocal(); // Disederhanakan
      } catch (e) {
        print('Error parsing date: ${json['created_at']}');
      }
    }

    return HistoryReportModel(
      id: json['id'],
      description: json['description'],
      desa_id: json['desa_id'],
      category: json['category'],
      ttsUrl: json['tts_url_full'] ?? json['tts_url'],
      createdAt: json['created_at'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      namaLengkap: json['reporter']?['name'],
      createdDate: parsedDate,
    );
  }
}
