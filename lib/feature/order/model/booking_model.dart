// lib/feature/booking/model/booking_model.dart

class BookingModel {
  final int id;
  final int userId;
  final int service;
  final ServiceDetail serviceDetail;
  final String fullName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.service,
    required this.serviceDetail,
    required this.fullName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      service: json['service'] as int,
      serviceDetail:
      ServiceDetail.fromJson(json['service_detail'] as Map<String, dynamic>),
      fullName: json['full_name'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service': service,
      'service_detail': serviceDetail.toJson(),
      'full_name': fullName,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ServiceDetail {
  final int id;
  final String title;
  final String description;
  final String price;
  final String oldPrice;
  final String image;
  final List<String> techStack;
  final Category category;

  ServiceDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.techStack,
    required this.category,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      oldPrice: json['old_price'] as String,
      image: json['image'] as String,
      techStack: List<String>.from(json['tech_stack'] as List),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'old_price': oldPrice,
      'image': image,
      'tech_stack': techStack,
      'category': category.toJson(),
    };
  }
}

class Category {
  final int id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}