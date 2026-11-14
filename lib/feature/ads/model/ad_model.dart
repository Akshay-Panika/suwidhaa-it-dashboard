class AdModel {
  final int id;
  final String adImage;
  final String? title;
  final String? videoUrl;
  final bool isHome;
  final String createdAt;
  final String updatedAt;

  AdModel({
    required this.id,
    required this.adImage,
    this.title,
    this.videoUrl,
    required this.isHome,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] ?? 0,
      adImage: json['ad_image'] ?? '',
      title: json['title'],
      videoUrl: json['video_url'],
      isHome: json['is_home'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad_image': adImage,
      'title': title,
      'video_url': videoUrl,
      'is_home': isHome,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}