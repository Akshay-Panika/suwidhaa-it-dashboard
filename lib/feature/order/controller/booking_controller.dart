// lib/feature/booking/controller/booking_controller.dart

import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/booking_model.dart';
import '../repository/booking_repository.dart';

class BookingController extends GetxController {
  final BookingRepository _repository = BookingRepository();

  // Observable state
  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings({bool showLoader = true}) async {
    if (showLoader) {
      isLoading.value = true;
      errorMessage.value = '';
    }

    try {
      final result = await _repository.fetchBookings();
      bookings.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Optional: retry method for error state
  void retry() => fetchBookings();
}