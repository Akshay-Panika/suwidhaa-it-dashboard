import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/ad_model.dart';
import '../repository/ad_repository.dart';

class AdController extends GetxController {
  final AdRepository _repository = AdRepository();

  // ── List State ──
  var ads = <AdModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final searchCtrl = TextEditingController();
  var searchQuery = ''.obs;

  // ── Form State ──
  var isAdding = false.obs;
  var isSubmitting = false.obs;
  var selectedAd = Rx<AdModel?>(null);

  final titleCtrl = TextEditingController();
  final videoUrlCtrl = TextEditingController();
  var isHome = false.obs;
  var pickedImageBytes = Rx<Uint8List?>(null);
  var pickedImageName = ''.obs;

  // Search Filter
  List<AdModel> get filteredAds {
    if (searchQuery.value.isEmpty) return ads;
    return ads.where((a) =>
    (a.title ?? '').toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        a.id.toString().contains(searchQuery.value)
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAds();
  }

  Future<void> fetchAds() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await _repository.getAds();

      if (response.statusCode == 200) {
        final rawData = response.data['data'];
        if (rawData is List) {
          ads.assignAll(rawData.map((e) => AdModel.fromJson(e)).toList());
        } else {
          ads.clear();
        }
      }
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void startAdding() {
    resetForm();
    isAdding.value = true;
    selectedAd.value = null;
  }

  void selectAd(AdModel ad) {
    isAdding.value = false;
    selectedAd.value = ad;
    titleCtrl.text = ad.title ?? '';
    videoUrlCtrl.text = ad.videoUrl ?? '';
    isHome.value = ad.isHome;
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }

  void resetForm() {
    titleCtrl.clear();
    videoUrlCtrl.clear();
    isHome.value = false;
    pickedImageBytes.value = null;
    pickedImageName.value = '';
    selectedAd.value = null;
    isAdding.value = false;
  }

  void setImage({required Uint8List bytes, required String name}) {
    pickedImageBytes.value = bytes;
    pickedImageName.value = name;
  }

  Future<bool> createAd() async {
    if (pickedImageBytes.value == null) {
      FlutterToast.error('Please select an ad image');
      return false;
    }

    try {
      isSubmitting.value = true;
      final response = await _repository.createAd(
        imageBytes: pickedImageBytes.value!,
        imageName: pickedImageName.value,
        title: titleCtrl.text.trim(),
        videoUrl: videoUrlCtrl.text.trim(),
        isHome: isHome.value,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        FlutterToast.success('Ad created successfully');
        resetForm();
        fetchAds(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateAd() async {
    if (selectedAd.value == null) return false;

    try {
      isSubmitting.value = true;
      final response = await _repository.updateAd(
        id: selectedAd.value!.id,
        imageBytes: pickedImageBytes.value,
        imageName: pickedImageName.value.isNotEmpty ? pickedImageName.value : null,
        title: titleCtrl.text.trim(),
        videoUrl: videoUrlCtrl.text.trim(),
        isHome: isHome.value,
      );

      if (response.statusCode == 200) {
        FlutterToast.success('Ad updated successfully');
        resetForm();
        fetchAds(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteAd(int id) async {
    try {
      final response = await _repository.deleteAd(id);
      if (response.statusCode == 200) {
        FlutterToast.success('Ad deleted successfully');
        ads.removeWhere((a) => a.id == id); // Remove locally
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceAll('Exception: ', ''));
    }
  }
}