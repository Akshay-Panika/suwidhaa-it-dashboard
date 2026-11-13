class ServiceModel {
  final int id;
  final String title;
  final String description;
  final String price;
  final String oldPrice;
  final String imageUrl;
  final List<String> techStack;
  final String createdAt;
  final String updatedAt;
  final CategoryDetail? categoryDetail;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.techStack,
    required this.createdAt,
    required this.updatedAt,
    this.categoryDetail,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      oldPrice: json['old_price']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
      techStack: (json['tech_stack'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      categoryDetail: json['category_detail'] != null
          ? CategoryDetail.fromJson(Map<String, dynamic>.from(json['category_detail']))
          : null,
    );
  }
}

class CategoryDetail {
  final int id;
  final String name;
  final String imageUrl;

  const CategoryDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
    );
  }
}