import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';

class AdRepository {
  final Dio _dio = ApiClient.dio;

  // Helper function to safely extract error messages
  String _getErrorMessage(DioException e, String defaultMsg) {
    if (e.response?.data is Map<String, dynamic>) {
      return e.response?.data['message'] ?? defaultMsg;
    } else if (e.response?.data is String && e.response!.data!.isNotEmpty) {
      // Kabhi kabhi Django HTML page return karta hai, toh usko handle karein
      return "Server Error: ${e.response?.statusCode}";
    }
    return defaultMsg;
  }

  // 1. GET ALL ADS
  Future<Response> getAds() async {
    try {
      return await _dio.get(ApiUrls.adList);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e, 'Failed to load ads'));
    }
  }

  // 2. CREATE AD (With FormData)
  Future<Response> createAd({
    required Uint8List imageBytes,
    required String imageName,
    String? title,
    String? videoUrl,
    bool isHome = false,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "ad_image": MultipartFile.fromBytes(
          imageBytes,
          filename: imageName,
        ),
        "title": title ?? '',
        "video_url": videoUrl ?? '',
        "is_home": isHome, // Boolean seedha bhejna best hai
      });

      return await _dio.post(ApiUrls.adCreate, data: formData);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e, 'Failed to create ad'));
    }
  }

  // 3. UPDATE AD (PATCH with FormData)
  Future<Response> updateAd({
    required int id,
    Uint8List? imageBytes,
    String? imageName,
    String? title,
    String? videoUrl,
    bool? isHome,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (imageBytes != null && imageName != null) {
        data["ad_image"] = MultipartFile.fromBytes(imageBytes, filename: imageName);
      }
      if (title != null) data["title"] = title;
      if (videoUrl != null) data["video_url"] = videoUrl;
      if (isHome != null) data["is_home"] = isHome;

      FormData formData = FormData.fromMap(data);

      return await _dio.patch(ApiUrls.adDetail(id), data: formData);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e, 'Failed to update ad'));
    }
  }

  // 4. DELETE AD
  Future<Response> deleteAd(int id) async {
    try {
      return await _dio.delete(ApiUrls.adDetail(id));
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e, 'Failed to delete ad'));
    }
  }
}