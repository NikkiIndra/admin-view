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
  String? image;

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
    this.image,
  });

  factory HistoryReportModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['created_at'] != null) {
      try {
        parsedDate = DateTime.parse(json['created_at']).toLocal();
      } catch (e) {
        print('Error parsing date: ${json['created_at']}');
      }
    }

    // Handle konversi latitude dan longitude
    double? parseCoordinate(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    // Handle berbagai kemungkinan field name untuk nama lengkap
    String? getNameFromJson(Map<String, dynamic> json) {
      // Coba berbagai kemungkinan field name
      return json['nama_lengkap'] ??
          json['nama_lengkap'] ??
          json['name'] ??
          json['nama'] ??
          json['reporter_name'] ??
          json['user_name'] ??
          (json['reporter'] is Map ? json['reporter']['name'] : null) ??
          (json['user'] is Map ? json['user']['nama_lengkap'] : null);
    }

    return HistoryReportModel(
      id: json['id'],
      description: json['description'],
      desa_id: json['desa_id'],
      category: json['category'],
      ttsUrl: json['tts_url_full'] ?? json['tts_url'],
      createdAt: json['created_at'],
      latitude: parseCoordinate(json['latitude']),
      longitude: parseCoordinate(json['longitude']),
      namaLengkap: getNameFromJson(json), // Gunakan fungsi helper
      createdDate: parsedDate,
    );
  }
}
