import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/category_model.dart';

class CategoryRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<CategoryModel>> getCategories() async {
    final res = await _dio.get(ApiUrls.categoryList);
    final data = _asMap(res.data);
    if (data['success'] == true) {
      final raw = (data['data'] as List?) ?? const [];
      return raw
          .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw Exception(_extractError(data));
  }

  Future<CategoryModel> createCategory({
    required String name,
    required Uint8List imageBytes,
    required String imageFilename,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'image': MultipartFile.fromBytes(imageBytes, filename: imageFilename),
    });
    final res = await _dio.post(ApiUrls.categoryCreate, data: formData);
    final data = _asMap(res.data);
    if (data['success'] == true) {
      return CategoryModel.fromJson(Map<String, dynamic>.from(data['data']));
    }
    throw Exception(_extractError(data));
  }

  Future<CategoryModel> updateCategory({
    required int id,
    required String name,
    Uint8List? imageBytes,
    String? imageFilename,
  }) async {
    final map = <String, dynamic>{'name': name};
    if (imageBytes != null) {
      map['image'] = MultipartFile.fromBytes(
        imageBytes,
        filename: imageFilename ?? 'image.jpg',
      );
    }
    final res = await _dio.patch(
      ApiUrls.categoryDetail(id),
      data: FormData.fromMap(map),
    );
    final data = _asMap(res.data);
    if (data['success'] == true) {
      return CategoryModel.fromJson(Map<String, dynamic>.from(data['data']));
    }
    throw Exception(_extractError(data));
  }

  Future<void> deleteCategory(int id) async {
    final res = await _dio.delete(ApiUrls.categoryDetail(id));
    final data = _asMap(res.data);
    if (data['success'] != true) {
      throw Exception(_extractError(data));
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return {'success': false, 'message': 'Invalid response'};
  }

  String _extractError(dynamic data) {
    if (data is Map) {
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        return first.toString();
      }
      return data['message']?.toString() ?? 'Something went wrong';
    }
    return 'Something went wrong';
  }
}