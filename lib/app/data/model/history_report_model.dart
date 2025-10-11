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
  });

  factory HistoryReportModel.fromJson(Map<String, dynamic> json) {
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
    );
  }
}
