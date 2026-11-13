import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../category/controller/category_controller.dart';
import '../model/service_model.dart';
import '../repository/service_repository.dart';

class ServiceController extends GetxController {
  final ServiceRepository _repo = ServiceRepository();

  late final CategoryController categoryCtrl;

  final RxList<ServiceModel> services = <ServiceModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;

  final Rx<ServiceModel?> selectedService = Rx<ServiceModel?>(null);
  final RxBool isAdding = false.obs;
  final Rx<Uint8List?> pickedImageBytes = Rx<Uint8List?>(null);
  final RxString pickedImageName = ''.obs;

  final RxInt selectedCategoryId = RxInt(0);

  // Controllers
  final searchCtrl = TextEditingController();
  final RxString searchQuery = ''.obs;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final oldPriceCtrl = TextEditingController();
  final techStackCtrl = TextEditingController();

  int _currentCategoryId = 0;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<CategoryController>()) {
      categoryCtrl = Get.find<CategoryController>();
    } else {
      categoryCtrl = Get.put(CategoryController());
    }
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    oldPriceCtrl.dispose();
    techStackCtrl.dispose();
    super.onClose();
  }

  List<ServiceModel> get filteredServices {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return services;
    return services.where((s) => s.title.toLowerCase().contains(q)).toList();
  }

  List<String> _parseTechStack() {
    final text = techStackCtrl.text.trim();
    if (text.isEmpty) return [];
    return text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  Future<void> fetchServices(int categoryId) async {
    _currentCategoryId = categoryId;
    isLoading.value = true;
    error.value = '';
    try {
      final list = await _repo.getServices(categoryId: categoryId);
      services.assignAll(list);
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshServices() async {
    services.clear();
    await fetchServices(_currentCategoryId);
  }

  Future<bool> createService() async {
    final title = titleCtrl.text.trim();
    if (title.isEmpty) {
      FlutterToast.warning('Service title is required');
      return false;
    }
    if (selectedCategoryId.value == 0) {
      FlutterToast.warning('Please select a category');
      return false;
    }

    isSubmitting.value = true;
    try {
      await _repo.createService(
        categoryId: selectedCategoryId.value,
        title: title,
        description: descCtrl.text.trim(),
        price: priceCtrl.text.trim(),
        oldPrice: oldPriceCtrl.text.trim(),
        techStack: _parseTechStack(),
        imageBytes: pickedImageBytes.value,
        imageFilename: pickedImageName.value.isEmpty ? null : pickedImageName.value,
      );

      await fetchServices(_currentCategoryId);
      FlutterToast.success('Service created successfully');
      resetForm();
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateService() async {
    final current = selectedService.value;
    if (current == null) return false;

    final title = titleCtrl.text.trim();
    if (title.isEmpty) {
      FlutterToast.warning('Service title is required');
      return false;
    }
    if (selectedCategoryId.value == 0) {
      FlutterToast.warning('Please select a category');
      return false;
    }

    isSubmitting.value = true;
    try {
      await _repo.updateService(
        id: current.id,
        categoryId: selectedCategoryId.value,
        title: title,
        description: descCtrl.text.trim(),
        price: priceCtrl.text.trim(),
        oldPrice: oldPriceCtrl.text.trim(),
        techStack: _parseTechStack(),
        imageBytes: pickedImageBytes.value,
        imageFilename: pickedImageName.value.isEmpty ? null : pickedImageName.value,
      );

      await fetchServices(_currentCategoryId);
      FlutterToast.success('Service updated successfully');
      resetForm();
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteService(int id) async {
    try {
      await _repo.deleteService(id);
      await fetchServices(_currentCategoryId);
      if (selectedService.value?.id == id) resetForm();
      FlutterToast.success('Service deleted successfully');
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  void selectService(ServiceModel service) {
    selectedService.value = service;
    isAdding.value = false;

    titleCtrl.text = service.title;
    descCtrl.text = service.description;
    priceCtrl.text = service.price;
    oldPriceCtrl.text = service.oldPrice;
    techStackCtrl.text = service.techStack.join(', ');

    selectedCategoryId.value = service.categoryDetail?.id ?? _currentCategoryId;
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }

  void startAdding() {
    selectedService.value = null;
    isAdding.value = true;

    titleCtrl.clear();
    descCtrl.clear();
    priceCtrl.clear();
    oldPriceCtrl.clear();
    techStackCtrl.clear();

    selectedCategoryId.value = _currentCategoryId == 0 ? 0 : _currentCategoryId;
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }

  void setImage({required Uint8List bytes, required String name}) {
    pickedImageBytes.value = bytes;
    pickedImageName.value = name;
  }

  void resetForm() {
    selectedService.value = null;
    isAdding.value = false;
    titleCtrl.clear();
    descCtrl.clear();
    priceCtrl.clear();
    oldPriceCtrl.clear();
    techStackCtrl.clear();
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }
}