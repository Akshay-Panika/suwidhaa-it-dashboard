import 'package:get/get.dart';
import '../../feature/ads/controller/ad_controller.dart';
import '../../feature/banner/controller/banner_controller.dart';
import '../../feature/category/controller/category_controller.dart';
import '../../feature/order/controller/booking_controller.dart';
import '../../feature/service/controller/service_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent — available app-wide from startup
    Get.put<CategoryController>(CategoryController(), permanent: true);
    Get.put<ServiceController>(ServiceController(), permanent: true);
    Get.put<BannerController>(BannerController(), permanent: true);
    Get.put<AdController>(AdController(), permanent: true);
    Get.put<BookingController>(BookingController(), permanent: true);
  }
}