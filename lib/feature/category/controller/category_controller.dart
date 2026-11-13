import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repo = CategoryRepository();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;

  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final RxBool isAdding = false.obs;
  final Rx<Uint8List?> pickedImageBytes = Rx<Uint8List?>(null);
  final RxString pickedImageName = ''.obs;

  final nameCtrl = TextEditingController();
  final searchCtrl = TextEditingController();
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  List<CategoryModel> get filteredCategories {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return categories;
    return categories.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    error.value = '';
    try {
      final list = await _repo.getCategories();
      categories.assignAll(list);
    } catch (e) {
      error.value = _friendly(e);
      debugPrint("FETCH ERROR: $e");
      FlutterToast.error(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCategories() => fetchCategories();

  Future<bool> createCategory() async {
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      FlutterToast.warning('Category name is required');
      return false;
    }
    if (pickedImageBytes.value == null) {
      FlutterToast.warning('Please select an image');
      return false;
    }

    isSubmitting.value = true;
    try {
      debugPrint("CREATING CATEGORY: $name");

      await _repo.createCategory(
        name: name,
        imageBytes: pickedImageBytes.value!,
        imageFilename: pickedImageName.value.isEmpty
            ? 'image.jpg'
            : pickedImageName.value,
      );

      await fetchCategories();
      FlutterToast.success('Category created successfully');
      resetForm();
      return true;
    } catch (e) {
      debugPrint("CREATE ERROR: $e");
      FlutterToast.error(_friendly(e));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateCategory() async {
    final current = selectedCategory.value;
    if (current == null) return false;
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      FlutterToast.warning('Category name is required');
      return false;
    }
    isSubmitting.value = true;
    try {
      await _repo.updateCategory(
        id: current.id,
        name: name,
        imageBytes: pickedImageBytes.value,
        imageFilename: pickedImageName.value.isEmpty
            ? null
            : pickedImageName.value,
      );
      await fetchCategories();
      FlutterToast.success('Category updated successfully');
      resetForm();
      return true;
    } catch (e) {
      debugPrint("UPDATE ERROR: $e");
      FlutterToast.error(_friendly(e));
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    if (id == 0) {
      FlutterToast.warning("The 'All' category cannot be deleted.");
      return false;
    }
    try {
      await _repo.deleteCategory(id);
      await fetchCategories();
      if (selectedCategory.value?.id == id) resetForm();
      FlutterToast.success('Category deleted successfully');
      return true;
    } catch (e) {
      debugPrint("DELETE ERROR: $e");
      FlutterToast.error(_friendly(e));
      return false;
    }
  }

  void selectCategory(CategoryModel cat) {
    selectedCategory.value = cat;
    isAdding.value = false;
    nameCtrl.text = cat.name;
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }

  void startAdding() {
    selectedCategory.value = null;
    isAdding.value = true;
    nameCtrl.clear();
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }

  void setImage({required Uint8List bytes, required String name}) {
    pickedImageBytes.value = bytes;
    pickedImageName.value = name;
  }

  void resetForm() {
    selectedCategory.value = null;
    isAdding.value = false;
    nameCtrl.clear();
    pickedImageBytes.value = null;
    pickedImageName.value = '';
  }

  String _friendly(Object e) {
    final s = e.toString();
    return s.startsWith('Exception: ') ? s.substring(11) : s;
  }
}