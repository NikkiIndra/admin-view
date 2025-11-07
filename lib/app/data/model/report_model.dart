class ReportModel {
  final int? id;
  final String? jenisLaporan;
  final String? namaPelapor;
  final String? alamat;
  final String? deskripsi;
  final double? latitude;
  final double? longitude;
  final String? tanggal;
  final String? fotoUrl;
  final String? status;
  final double? similarityScore;
  final String? createdAt;

  ReportModel({
    this.id,
    this.jenisLaporan,
    this.namaPelapor,
    this.alamat,
    this.deskripsi,
    this.latitude,
    this.longitude,
    this.tanggal,
    this.fotoUrl,
    this.status,
    this.similarityScore,
    this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json["id"],
      jenisLaporan: json["jenis_laporan"],
      namaPelapor: json["nama_pelapor"],
      alamat: json["alamat"],
      deskripsi: json["deskripsi"],
      latitude: (json["latitude"] is String)
          ? double.tryParse(json["latitude"])
          : json["latitude"],
      longitude: (json["longitude"] is String)
          ? double.tryParse(json["longitude"])
          : json["longitude"],
      tanggal: json["tanggal"],
      fotoUrl: json["foto_url"],
      status: json["status"],
      similarityScore: (json["similarity_score"] ?? 0).toDouble(),
      createdAt: json["created_at"],
    );
  }
}
