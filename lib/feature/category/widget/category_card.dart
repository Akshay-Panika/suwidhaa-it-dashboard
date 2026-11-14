import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/app_color.dart';
import '../controller/category_controller.dart';
import '../model/category_model.dart';

class CategoryCard extends StatefulWidget {
  final VoidCallback? onBack; // 👈 Ye line add karein

  const CategoryCard({
    super.key,
    this.onBack, // 👈 Ye line add karein
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final c = Get.find<CategoryController>();
  bool _isGridView = false;

  bool get _isWide => MediaQuery.sizeOf(context).width >= 1000;

  @override
  Widget build(BuildContext context) {
    // 🔥 FIX: Pura UI Obx me wrap kiya taaki startAdding par form show ho
    return Obx(() {
      final showPanel = _isWide && (c.isAdding.value || c.selectedCategory.value != null);

      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            (c.selectedCategory.value == null || c.selectedCategory.value!.id == 0)
                                ? Icons.apps_rounded
                                : Icons.folder_rounded,
                            color: AppColor.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            c.selectedCategory.value?.name ?? 'All Categories',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (c.isLoading.value)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.primary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${c.categories.length} categories available',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  tooltip: 'Back',
                  onPressed: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Get.back();
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: AppColor.black),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: () {
                    c.startAdding();
                    if (!_isWide) _showFormSheet();
                  },
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add New'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Search + View Toggle ──
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: c.searchCtrl,
                    onChanged: (v) => c.searchQuery.value = v,
                    style: const TextStyle(fontSize: 13.5),
                    decoration: InputDecoration(
                      hintText: 'Search categories by name…',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      prefixIcon: Icon(Icons.search_rounded, size: 20, color: Colors.grey.shade500),
                      suffixIcon: c.searchQuery.value.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade500),
                        onPressed: () {
                          c.searchCtrl.clear();
                          c.searchQuery.value = '';
                        },
                      )
                          : null,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      filled: true,
                      fillColor: AppColor.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColor.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColor.primary, width: 1.4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Grid / List Toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _toggleBtn(
                        icon: Icons.view_list_rounded,
                        tooltip: 'List view',
                        active: !_isGridView,
                        onTap: () => setState(() => _isGridView = false),
                      ),
                      const SizedBox(width: 2),
                      _toggleBtn(
                        icon: Icons.grid_view_rounded,
                        tooltip: 'Grid view',
                        active: _isGridView,
                        onTap: () => setState(() => _isGridView = true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Content ──
            Expanded(
              child: () {
                final items = c.filteredCategories;

                if (c.isLoading.value && c.categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColor.primary));
                }

                if (c.error.value.isNotEmpty && c.categories.isEmpty) {
                  return _errorState();
                }

                if (items.isEmpty) {
                  return _emptyState();
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _isGridView
                          ? _buildGrid(items)
                          : _buildList(items),
                    ),
                    if (showPanel)
                      SizedBox(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: _FormPanel(controller: c),
                        ),
                      ),
                  ],
                );
              }(),
            ),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════
  //  LAYOUTS
  // ═══════════════════════════════════════════════
  Widget _buildList(List<CategoryModel> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cat = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _CategoryItem(
            category: cat,
            isList: true,
            isSelected: c.selectedCategory.value?.id == cat.id,
            onTap: () {
              c.selectCategory(cat);
              if (!_isWide && cat.id != 0) _showFormSheet();
            },
            onEdit: () {
              c.selectCategory(cat);
              if (!_isWide) _showFormSheet();
            },
            onDelete: () => _confirmDelete(cat),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List<CategoryModel> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth < 650 ? 1 : constraints.maxWidth < 1100 ? 2 : 3;
        const gap = 16.0;
        final w = (constraints.maxWidth - gap * (cols - 1)) / cols;

        return SingleChildScrollView(
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: items.map((cat) {
              return SizedBox(
                width: w,
                child: _CategoryItem(
                  category: cat,
                  isList: false,
                  isSelected: c.selectedCategory.value?.id == cat.id,
                  onTap: () {
                    c.selectCategory(cat);
                    if (!_isWide && cat.id != 0) _showFormSheet();
                  },
                  onEdit: () {
                    c.selectCategory(cat);
                    if (!_isWide) _showFormSheet();
                  },
                  onDelete: () => _confirmDelete(cat),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════
  //  HANDLERS & HELPERS
  // ═══════════════════════════════════════════════
  void _showFormSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _FormPanel(controller: c, isBottomSheet: true),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(CategoryModel cat) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${cat.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: AppColor.red)),
          ),
        ],
      ),
    );
    if (ok == true) await c.deleteCategory(cat.id);
  }

  Widget _errorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(c.error.value, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: c.refreshCategories,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              c.searchQuery.value.isNotEmpty
                  ? 'No categories match "${c.searchQuery.value}"'
                  : 'No categories yet. Click "Add New" to start.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn({required IconData icon, required String tooltip, required bool active, required VoidCallback onTap}) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: active ? AppColor.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: active ? AppColor.primary : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  _CategoryItem
// ═══════════════════════════════════════════════
class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool isList;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryItem({
    required this.category,
    required this.isList,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = category.id == 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColor.primary : AppColor.border,
              width: isSelected ? 1.8 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColor.primary.withOpacity(0.12)
                    : Colors.black.withOpacity(0.03),
                blurRadius: isSelected ? 14 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isList ? _list(isDefault) : _grid(isDefault),
        ),
      ),
    );
  }

  Widget _grid(bool isDefault) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _iconBox(isDefault),
            const Spacer(),
            _statusBadge(isDefault),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.black),
        ),
        const SizedBox(height: 4),
        Text(
          isDefault ? 'System default category' : 'Custom service category',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 14),
        Divider(color: AppColor.border, height: 1),
        const SizedBox(height: 12),
        Row(
          children: [
            _dateWidget(),
            const Spacer(),
            if (!isDefault) _actions(),
          ],
        ),
      ],
    );
  }

  Widget _list(bool isDefault) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _iconBox(isDefault),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColor.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _statusBadge(isDefault),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                isDefault ? 'System default category' : 'Custom service category',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dateWidget(),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (!isDefault) _actions(),
      ],
    );
  }

  Widget _iconBox(bool isDefault) {
    if (isDefault) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.apps_rounded, color: AppColor.primary, size: 22),
      );
    }

    if (category.imageUrl.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.folder_rounded, color: AppColor.primary, size: 22),
      );
    }

    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(category.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _statusBadge(bool isDefault) {
    final color = isDefault ? const Color(0xFF10B981) : AppColor.primary;
    final text = isDefault ? 'Default' : 'Custom';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }


  Widget _dateWidget() {
    String dateStr = '';
    try {
      final dt = DateTime.parse(category.createdAt).toLocal();
      dateStr = '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      dateStr = 'N/A';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_today_rounded, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(
          dateStr,
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _actions() {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconBtn(Icons.edit_outlined, AppColor.black.withOpacity(0.55), onEdit),
          const SizedBox(width: 4),
          _iconBtn(Icons.delete_outline_rounded, AppColor.red, onDelete),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  _FormPanel
// ═══════════════════════════════════════════════
class _FormPanel extends StatelessWidget {
  final CategoryController controller;
  final bool isBottomSheet;

  const _FormPanel({required this.controller, this.isBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isAdding = controller.isAdding.value;

      Widget content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isAdding ? Icons.add_circle_outline_rounded : Icons.edit_rounded,
                  color: AppColor.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAdding ? 'Add New Category' : 'Edit Category',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAdding ? 'Create a new category' : 'Update category details',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (isBottomSheet) Navigator.pop(context);
                  controller.resetForm();
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.close_rounded, size: 20, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColor.border, height: 1),
          const SizedBox(height: 16),

          const Text('Category Image', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
          const SizedBox(height: 8),
          _imagePicker(context),
          const SizedBox(height: 14),

          const Text('Category Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
          const SizedBox(height: 6),
          TextField(
            controller: controller.nameCtrl,
            style: const TextStyle(fontSize: 13),
            decoration: _inputDecoration(hint: 'e.g. Web Development'),
          ),
          const SizedBox(height: 20),

          Obx(() => Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () {
                    if (isBottomSheet) Navigator.pop(context);
                    controller.resetForm();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: AppColor.border),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () async {
                    bool success;
                    if (isAdding) {
                      success = await controller.createCategory();
                    } else {
                      success = await controller.updateCategory();
                    }
                    if (success && isBottomSheet && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.white),
                  )
                      : Text(
                    isAdding ? 'Add Category' : 'Save Changes',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          )),
        ],
      );

      if (isBottomSheet) return content;

      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          child: content,
        ),
      );
    });
  }

  Widget _imagePicker(BuildContext context) {
    return Obx(() {
      final bytes = controller.pickedImageBytes.value;
      final existingUrl = controller.selectedCategory.value?.imageUrl;

      Widget preview;
      if (bytes != null) {
        preview = Image.memory(bytes, fit: BoxFit.cover);
      } else if (existingUrl != null && existingUrl.isNotEmpty) {
        preview = Image.network(
          existingUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.broken_image_rounded, size: 32, color: Colors.grey.shade400),
        );
      } else {
        preview = Center(child: Icon(Icons.add_photo_alternate_rounded, size: 32, color: Colors.grey.shade400));
      }

      return InkWell(
        onTap: () => _pickImage(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 130,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColor.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.border),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: preview),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload_rounded, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Upload', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey.shade500),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: AppColor.bg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColor.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColor.primary, width: 1.4),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final Uint8List bytes = await file.readAsBytes();
      controller.setImage(bytes: bytes, name: file.name);
    } catch (e) {
      // ignore
    }
  }
}