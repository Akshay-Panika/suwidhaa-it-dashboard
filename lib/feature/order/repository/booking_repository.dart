// lib/feature/booking/repository/booking_repository.dart

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../model/booking_model.dart';

class BookingRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<BookingModel>> fetchBookings() async {
    try {
      final response = await _dio.get(ApiUrls.bookingList);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Something went wrong. Please try again.',
      );
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}