import 'package:get/get.dart';

import '../controller/ad_controller.dart';


class AdsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdController>(() => AdController());
  }
}