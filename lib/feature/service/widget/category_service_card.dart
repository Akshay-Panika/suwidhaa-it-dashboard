import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/widget/flutter_toast.dart';
import '../controller/service_controller.dart';
import '../model/service_model.dart';

class CategoryServiceCard extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  final VoidCallback? onBack;

  const CategoryServiceCard({
    super.key,
    this.categoryId,
    this.categoryName,
    this.onBack,
  });

  @override
  State<CategoryServiceCard> createState() => _CategoryServiceCardState();
}

class _CategoryServiceCardState extends State<CategoryServiceCard> {
  late final ServiceController c;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ServiceController>()) {
      c = Get.find<ServiceController>();
    } else {
      c = Get.put(ServiceController(), permanent: true);
    }
    c.fetchServices(widget.categoryId ?? 0);
  }

  @override
  void didUpdateWidget(CategoryServiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categoryId != oldWidget.categoryId) {
      c.fetchServices(widget.categoryId ?? 0);
    }
  }

  bool get _isWide => MediaQuery.sizeOf(context).width >= 1000;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isAdding = c.isAdding.value;
      final selectedService = c.selectedService.value;

      final showPanel = _isWide && (isAdding || selectedService != null);

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
                            (widget.categoryId == 0 || widget.categoryId == null)
                                ? Icons.apps_rounded
                                : Icons.folder_rounded,
                            color: AppColor.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.categoryName ?? 'All Services',
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
                        '${c.services.length} services available',
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
                      hintText: 'Search services by name…',
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: () {
                      final items = c.filteredServices;

                      if (c.isLoading.value && c.services.isEmpty) {
                        return const Center(child: CircularProgressIndicator(color: AppColor.primary));
                      }

                      if (c.error.value.isNotEmpty && c.services.isEmpty) {
                        return _errorState();
                      }

                      if (items.isEmpty) {
                        return _emptyState();
                      }

                      return _isGridView
                          ? _buildGrid(items)
                          : _buildList(items);
                    }(),
                  ),
                  if (showPanel)
                    SizedBox(
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: _ServiceFormPanel(
                          controller: c,
                          categoryId: widget.categoryId ?? 0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════
  //  LAYOUTS
  // ═══════════════════════════════════════════════
  Widget _buildList(List<ServiceModel> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final service = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ServiceItem(
            service: service,
            isList: true,
            isSelected: c.selectedService.value?.id == service.id,
            onTap: () {
              c.selectService(service);
              if (!_isWide) _showFormSheet();
            },
            onEdit: () {
              c.selectService(service);
              if (!_isWide) _showFormSheet();
            },
            onDelete: () => _confirmDelete(service),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List<ServiceModel> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth < 650 ? 1 : constraints.maxWidth < 1100 ? 2 : 3;
        const gap = 16.0;
        final w = (constraints.maxWidth - gap * (cols - 1)) / cols;

        return SingleChildScrollView(
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: items.map((service) {
              return SizedBox(
                width: w,
                child: _ServiceItem(
                  service: service,
                  isList: false,
                  isSelected: c.selectedService.value?.id == service.id,
                  onTap: () {
                    c.selectService(service);
                    if (!_isWide) _showFormSheet();
                  },
                  onEdit: () {
                    c.selectService(service);
                    if (!_isWide) _showFormSheet();
                  },
                  onDelete: () => _confirmDelete(service),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

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
            child: _ServiceFormPanel(
              controller: c,
              categoryId: widget.categoryId ?? 0,
              isBottomSheet: true,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(ServiceModel service) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${service.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: AppColor.red)),
          ),
        ],
      ),
    );
    if (ok == true) await c.deleteService(service.id);
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
            onPressed: c.refreshServices,
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
                  ? 'No services match "${c.searchQuery.value}"'
                  : 'No services added yet.',
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
//  _ServiceItem UI
// ═══════════════════════════════════════════════
class _ServiceItem extends StatelessWidget {
  final ServiceModel service;
  final bool isList;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ServiceItem({
    required this.service,
    required this.isList,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                color: isSelected ? AppColor.primary.withOpacity(0.12) : Colors.black.withOpacity(0.03),
                blurRadius: isSelected ? 14 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isList ? _list() : _grid(),
        ),
      ),
    );
  }

  Widget _grid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _iconBox(),
            const Spacer(),
            if (service.categoryDetail != null) _categoryBadge(),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          service.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.black),
        ),
        const SizedBox(height: 4),
        Text(
          service.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 14),
        Divider(color: AppColor.border, height: 1),
        const SizedBox(height: 12),
        Row(
          children: [
            _priceWidget(),
            const Spacer(),
            _actions(),
          ],
        ),
      ],
    );
  }

  Widget _list() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _iconBox(),
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
                      service.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColor.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (service.categoryDetail != null) _categoryBadge(),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                service.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              _priceWidget(),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _actions(),
      ],
    );
  }

  Widget _iconBox() {
    if (service.imageUrl.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.design_services_rounded, color: AppColor.primary, size: 22),
      );
    }

    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(service.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _categoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        service.categoryDetail!.name,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColor.primary),
      ),
    );
  }

  Widget _priceWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.currency_rupee_rounded, size: 14, color: AppColor.primary),
        Text(
          service.price,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColor.primary),
        ),
        if (service.oldPrice.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            service.oldPrice,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ]
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
//  _ServiceFormPanel (Add / Edit Form)
// ═══════════════════════════════════════════════
class _ServiceFormPanel extends StatelessWidget {
  final ServiceController controller;
  final int categoryId;
  final bool isBottomSheet;

  const _ServiceFormPanel({
    required this.controller,
    required this.categoryId,
    this.isBottomSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isAdding = controller.isAdding.value;
      final catCtrl = controller.categoryCtrl;

      final validCats = catCtrl.categories.where((cat) => cat.id != 0).toList();
      final selectedVal = controller.selectedCategoryId.value;
      final isValid = validCats.any((c) => c.id == selectedVal);
      final safeValue = isValid ? selectedVal : null;

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
                      isAdding ? 'Add New Service' : 'Edit Service',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAdding ? 'Create a new service' : 'Update service details',
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

          const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
          const SizedBox(height: 6),
          DropdownButtonFormField<int>(
            value: safeValue,
            decoration: _inputDecoration(hint: 'Select Category'),
            items: validCats.map((cat) => DropdownMenuItem(
              value: cat.id,
              child: Text(cat.name),
            )).toList(),
            onChanged: (val) {
              if (val != null) controller.selectedCategoryId.value = val;
            },
          ),
          const SizedBox(height: 14),

          const Text('Service Image', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
          const SizedBox(height: 8),
          _imagePicker(context),
          const SizedBox(height: 14),

          const Text('Service Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
          const SizedBox(height: 6),
          TextField(
            controller: controller.titleCtrl,
            style: const TextStyle(fontSize: 13),
            decoration: _inputDecoration(hint: 'e.g. Static Website'),
          ),
          const SizedBox(height: 14),

          const Text('Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
          const SizedBox(height: 6),
          TextField(
            controller: controller.descCtrl,
            maxLines: 2,
            style: const TextStyle(fontSize: 13),
            decoration: _inputDecoration(hint: 'Brief description'),
          ),
          const SizedBox(height: 14),

          // 🔥 Tech Stack Field
          const Text('Tech Stack (comma separated)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
          const SizedBox(height: 6),
          TextField(
            controller: controller.techStackCtrl,
            style: const TextStyle(fontSize: 13),
            decoration: _inputDecoration(hint: 'e.g. Flutter, Firebase, Node.js'),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price (₹)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controller.priceCtrl,
                      style: const TextStyle(fontSize: 13),
                      decoration: _inputDecoration(hint: 'e.g. 25,000'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Old Price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controller.oldPriceCtrl,
                      style: const TextStyle(fontSize: 13),
                      decoration: _inputDecoration(hint: 'e.g. 30,000'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
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
                      success = await controller.createService();
                    } else {
                      success = await controller.updateService();
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
                    isAdding ? 'Add Service' : 'Save Changes',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
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
      final existingUrl = controller.selectedService.value?.imageUrl;

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
        onTap: () async {
          final picker = ImagePicker();
          final XFile? file = await picker.pickImage(source: ImageSource.gallery);
          if (file == null) return;
          final Uint8List bytes = await file.readAsBytes();
          controller.setImage(bytes: bytes, name: file.name);
        },
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
}