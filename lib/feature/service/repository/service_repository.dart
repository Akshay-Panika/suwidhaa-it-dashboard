import 'dart:convert'; // 🔥 Add this for jsonEncode
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/service_model.dart';

class ServiceRepository {
  final Dio _dio = ApiClient.dio;

  // ── GET LIST ──
  Future<List<ServiceModel>> getServices({required int categoryId}) async {
    final res = await _dio.get(ApiUrls.serviceList(categoryId));
    final data = res.data;

    if (data is Map && data['success'] == true) {
      final raw = (data['data'] as List?) ?? [];
      return raw.map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    throw Exception("Failed to load services");
  }

  // ── CREATE ──
  Future<void> createService({
    required int categoryId,
    required String title,
    required String description,
    required String price,
    required String oldPrice,
    required List<String> techStack,
    Uint8List? imageBytes,
    String? imageFilename,
  }) async {
    final map = <String, dynamic>{
      'category': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'old_price': oldPrice,
      'tech_stack': jsonEncode(techStack), // Backend expects JSON string
    };

    if (imageBytes != null) {
      map['image'] = MultipartFile.fromBytes(imageBytes, filename: imageFilename ?? 'image.jpg');
    }

    final res = await _dio.post(ApiUrls.serviceCreate, data: FormData.fromMap(map));
    final data = res.data;

    if (data is! Map || data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to create service');
    }
  }

  // ── UPDATE (PATCH) ──
  Future<void> updateService({
    required int id,
    required int categoryId,
    required String title,
    required String description,
    required String price,
    required String oldPrice,
    required List<String> techStack,
    Uint8List? imageBytes,
    String? imageFilename,
  }) async {
    final map = <String, dynamic>{
      'category': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'old_price': oldPrice,
      'tech_stack': jsonEncode(techStack),
    };

    if (imageBytes != null) {
      map['image'] = MultipartFile.fromBytes(imageBytes, filename: imageFilename ?? 'image.jpg');
    }

    final res = await _dio.patch(ApiUrls.serviceDetail(id), data: FormData.fromMap(map));
    final data = res.data;

    if (data is! Map || data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to update service');
    }
  }

  // ── DELETE ──
  Future<void> deleteService(int id) async {
    final res = await _dio.delete(ApiUrls.serviceDetail(id));
    final data = res.data;

    if (data is! Map || data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to delete service');
    }
  }
}