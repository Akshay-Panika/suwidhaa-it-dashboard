import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/banner_model.dart';
import '../repository/banner_repository.dart';

class BannerController extends GetxController {
  final _repo = BannerRepository();

  // ── List state ──
  final banners = <BannerModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  // ── Form state ──
  final isAdding = false.obs;
  final selectedBanner = Rxn<BannerModel>();
  final isSubmitting = false.obs;

  final videoUrlCtrl = TextEditingController();
  final searchCtrl = TextEditingController();
  final searchQuery = ''.obs;

  final pickedImageBytes = Rxn<Uint8List>();
  final pickedImageName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  @override
  void onClose() {
    videoUrlCtrl.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  List<BannerModel> get filteredBanners {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return banners;
    return banners.where((b) {
      return b.id.toString().contains(q) ||
          b.bannerImage.toLowerCase().contains(q) ||
          (b.videoUrl ?? '').toLowerCase().contains(q);
    }).toList();
  }

  // ── Data ──
  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await _repo.fetchBanners();
      banners.assignAll(data);
    } catch (e) {
      error.value = _parseError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBanners() => fetchBanners();

  // ── Form lifecycle ──
  void startAdding() {
    isAdding.value = true;
    selectedBanner.value = null;
    resetForm(preserveMode: true);
  }

  void selectBanner(BannerModel banner) {
    isAdding.value = false;
    selectedBanner.value = banner;
    videoUrlCtrl.text = banner.videoUrl ?? '';
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }

  void setImage({required Uint8List bytes, required String name}) {
    pickedImageBytes.value = bytes;
    pickedImageName.value = name;
  }

  void clearImage() {
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }

  void resetForm({bool preserveMode = false}) {
    videoUrlCtrl.clear();
    pickedImageBytes.value = null;
    pickedImageName.value = '';
    if (!preserveMode) {
      selectedBanner.value = null;
      isAdding.value = false;
    }
  }

  // ── CRUD ──
  Future<bool> createBanner() async {
    if (pickedImageBytes.value == null) {
      _toast('Please select a banner image');
      return false;
    }
    try {
      isSubmitting.value = true;
      final created = await _repo.createBanner(
        imageBytes: pickedImageBytes.value!,
        imageName: pickedImageName.value,
        videoUrl: videoUrlCtrl.text.trim().isEmpty
            ? null
            : videoUrlCtrl.text.trim(),
      );
      banners.insert(0, created);
      resetForm();
      _toast('Banner created successfully');
      return true;
    } catch (e) {
      _toast(_parseError(e));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateBanner() async {
    final target = selectedBanner.value;
    if (target == null) return false;

    final hasNewImage = pickedImageBytes.value != null;
    final currentVideo = videoUrlCtrl.text.trim();
    final originalVideo = (target.videoUrl ?? '').trim();
    final videoChanged = currentVideo != originalVideo;

    if (!hasNewImage && !videoChanged) {
      _toast('Nothing to update');
      return false;
    }

    try {
      isSubmitting.value = true;
      final updated = await _repo.updateBanner(
        id: target.id,
        imageBytes: hasNewImage ? pickedImageBytes.value : null,
        imageName: hasNewImage ? pickedImageName.value : null,
        videoUrl: videoChanged ? currentVideo : null,
        partial: true,
      );
      final i = banners.indexWhere((b) => b.id == target.id);
      if (i != -1) banners[i] = updated;
      resetForm();
      _toast('Banner updated successfully');
      return true;
    } catch (e) {
      _toast(_parseError(e));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteBanner(int id) async {
    try {
      await _repo.deleteBanner(id);
      banners.removeWhere((b) => b.id == id);
      if (selectedBanner.value?.id == id) resetForm();
      _toast('Banner deleted successfully');
    } catch (e) {
      _toast(_parseError(e));
    }
  }

  // ── Helpers ──
  void _toast(String msg) {
    Get.snackbar(
      'Banners',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  String _parseError(dynamic e) {
    try {
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data['errors'] != null) {
          final errs = data['errors'] as Map;
          if (errs.isNotEmpty) {
            final first = errs.values.first;
            if (first is List && first.isNotEmpty) return first.first.toString();
            return first.toString();
          }
        }
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
        return e.message ?? 'Network error';
      }
    } catch (_) {}
    return e.toString();
  }
}