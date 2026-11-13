import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/banner_model.dart';

class BannerRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<BannerModel>> fetchBanners() async {
    final res = await _dio.get(ApiUrls.bannerList);
    final list = (res.data['data'] as List?) ?? [];
    return list
        .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BannerModel> fetchBannerDetail(int id) async {
    final res = await _dio.get(ApiUrls.bannerDetail(id));
    return BannerModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<BannerModel> createBanner({
    required Uint8List imageBytes,
    required String imageName,
    String? videoUrl,
  }) async {
    final form = FormData.fromMap({
      'banner_image': MultipartFile.fromBytes(imageBytes, filename: imageName),
      if (videoUrl != null && videoUrl.isNotEmpty) 'video_url': videoUrl,
    });
    final res = await _dio.post(ApiUrls.bannerCreate, data: form);
    return BannerModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  /// partial = false → PUT (image required by backend)
  /// partial = true  → PATCH (image optional, only fields you send update)
  Future<BannerModel> updateBanner({
    required int id,
    Uint8List? imageBytes,
    String? imageName,
    String? videoUrl,
    bool partial = true,
  }) async {
    final map = <String, dynamic>{};
    if (imageBytes != null && imageName != null) {
      map['banner_image'] =
          MultipartFile.fromBytes(imageBytes, filename: imageName);
    }
    if (videoUrl != null) map['video_url'] = videoUrl;

    final form = FormData.fromMap(map);
    final res = partial
        ? await _dio.patch(ApiUrls.bannerDetail(id), data: form)
        : await _dio.put(ApiUrls.bannerDetail(id), data: form);
    return BannerModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteBanner(int id) async {
    await _dio.delete(ApiUrls.bannerDetail(id));
  }
}