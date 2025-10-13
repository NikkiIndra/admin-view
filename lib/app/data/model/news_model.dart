class NewsModel {
  String? id;
  String? title;
  String? description;
  String? image;
  String? imageUrl;
  String? source;
  DateTime? createdAt;
  String? visitors;
  String? desaId;

  NewsModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.imageUrl,
    this.source,
    this.createdAt,
    this.visitors,
    this.desaId,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final imageName = json['image'];
    final baseUrl = 'http://192.168.0.99:5000/uploads/news_images/';

    final rawImage = json['image_url'] ?? json['image'];
    String? fullImageUrl;

    if (rawImage != null && rawImage.toString().isNotEmpty) {
      // jika belum ada prefix "http", tambahkan base URL
      fullImageUrl = rawImage.toString().startsWith('http')
          ? rawImage
          : '$baseUrl$rawImage';
    }
    return NewsModel(
      id: json['id']?.toString(),
      title: json['title'],
      description: json['description'],
      image: json['image'],
      imageUrl: json['image_url'] != null
          ? (json['image_url'].startsWith('http')
                ? json['image_url']
                : 'http://192.168.0.99:5000/uploads/${json['image_url']}')
          : null,
      source: json['source'],
      visitors: json['visitors']?.toString(),
      desaId: json['desa_id']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
