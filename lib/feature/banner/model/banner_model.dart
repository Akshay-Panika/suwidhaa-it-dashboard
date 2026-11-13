class BannerModel {
  final int id;
  final String bannerImage;
  final String? videoUrl;
  final String createdAt;
  final String updatedAt;

  BannerModel({
    required this.id,
    required this.bannerImage,
    this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      bannerImage: (json['banner_image'] ?? '').toString(),
      videoUrl: json['video_url']?.toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      updatedAt: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'banner_image': bannerImage,
    'video_url': videoUrl,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  BannerModel copyWith({
    int? id,
    String? bannerImage,
    String? videoUrl,
    String? createdAt,
    String? updatedAt,
  }) {
    return BannerModel(
      id: id ?? this.id,
      bannerImage: bannerImage ?? this.bannerImage,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}