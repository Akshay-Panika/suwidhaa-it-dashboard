import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/app_color.dart';
import '../controller/banner_controller.dart';
import '../model/banner_model.dart';

class BannerCard extends StatefulWidget {
  final VoidCallback? onBack; // 👈 1. Ye line add karein

  const BannerCard({
    super.key,
    this.onBack, // 👈 2. Ye line add karein
  });

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  late final BannerController c;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<BannerController>()) {
      c = Get.find<BannerController>();
    } else {
      c = Get.put(BannerController(), permanent: true);
    }
  }

  bool get _isWide => MediaQuery.sizeOf(context).width >= 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Obx(() {
        final isAdding = c.isAdding.value;
        final selected = c.selectedBanner.value;
        final showPanel = _isWide && (isAdding || selected != null);

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
                            const Icon(Icons.view_carousel_rounded,
                                color: AppColor.primary, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'Banners',
                              style: TextStyle(
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
                          '${c.banners.length} banners available',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w600),
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
                        hintText: 'Search banners by ID or video URL…',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.search_rounded,
                            size: 20, color: Colors.grey.shade500),
                        suffixIcon: c.searchQuery.value.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.close_rounded,
                              size: 18, color: Colors.grey.shade500),
                          onPressed: () {
                            c.searchCtrl.clear();
                            c.searchQuery.value = '';
                          },
                        )
                            : null,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
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
                          borderSide: const BorderSide(
                              color: AppColor.primary, width: 1.4),
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
                        final items = c.filteredBanners;
                        if (c.isLoading.value && c.banners.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.primary));
                        }
                        if (c.error.value.isNotEmpty && c.banners.isEmpty) {
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
                          child: _BannerFormPanel(controller: c),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── Layouts ──
  Widget _buildList(List<BannerModel> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final banner = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _BannerItem(
            banner: banner,
            isList: true,
            isSelected: c.selectedBanner.value?.id == banner.id,
            onTap: () {
              c.selectBanner(banner);
              if (!_isWide) _showFormSheet();
            },
            onEdit: () {
              c.selectBanner(banner);
              if (!_isWide) _showFormSheet();
            },
            onDelete: () => _confirmDelete(banner),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List<BannerModel> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth < 650
            ? 1
            : constraints.maxWidth < 1100
            ? 2
            : 3;
        const gap = 16.0;
        final w = (constraints.maxWidth - gap * (cols - 1)) / cols;

        return SingleChildScrollView(
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: items.map((banner) {
              return SizedBox(
                width: w,
                child: _BannerItem(
                  banner: banner,
                  isList: false,
                  isSelected: c.selectedBanner.value?.id == banner.id,
                  onTap: () {
                    c.selectBanner(banner);
                    if (!_isWide) _showFormSheet();
                  },
                  onEdit: () {
                    c.selectBanner(banner);
                    if (!_isWide) _showFormSheet();
                  },
                  onDelete: () => _confirmDelete(banner),
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
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _BannerFormPanel(controller: c, isBottomSheet: true),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BannerModel banner) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Banner'),
        content: Text('Are you sure you want to delete banner #${banner.id}?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: AppColor.red)),
          ),
        ],
      ),
    );
    if (ok == true) await c.deleteBanner(banner.id);
  }

  Widget _errorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(c.error.value,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: c.refreshBanners,
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
            Icon(Icons.view_carousel_outlined,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              c.searchQuery.value.isNotEmpty
                  ? 'No banners match "${c.searchQuery.value}"'
                  : 'No banners added yet.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn({
    required IconData icon,
    required String tooltip,
    required bool active,
    required VoidCallback onTap,
  }) {
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
            child: Icon(icon,
                size: 18,
                color: active ? AppColor.primary : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  _BannerItem
// ═══════════════════════════════════════════════
class _BannerItem extends StatelessWidget {
  final BannerModel banner;
  final bool isList;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BannerItem({
    required this.banner,
    required this.isList,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return iso;
    }
  }

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
                color: isSelected
                    ? AppColor.primary.withOpacity(0.12)
                    : Colors.black.withOpacity(0.03),
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
        _imageBox(height: 150, width: double.infinity, radius: 12),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '#${banner.id}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            const Spacer(),
            _dateBadge(),
          ],
        ),
        const SizedBox(height: 8),
        if (banner.videoUrl != null && banner.videoUrl!.isNotEmpty)
          _videoBadge(banner.videoUrl!)
        else
          Text(
            'No video URL',
            style: TextStyle(
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade500),
          ),
        const SizedBox(height: 12),
        Divider(color: AppColor.border, height: 1),
        const SizedBox(height: 10),
        Row(
          children: [
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
        _imageBox(height: 60, width: 90, radius: 10),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Banner #${banner.id}',
                    style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black),
                  ),
                  const SizedBox(width: 8),
                  _dateBadge(),
                ],
              ),
              const SizedBox(height: 4),
              if (banner.videoUrl != null && banner.videoUrl!.isNotEmpty)
                _videoBadge(banner.videoUrl!)
              else
                Text(
                  'No video URL',
                  style: TextStyle(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade500),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _actions(),
      ],
    );
  }

  Widget _imageBox({
    required double height,
    required double width,
    required double radius,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: width,
        child: banner.bannerImage.isEmpty
            ? Container(
          color: AppColor.primary.withOpacity(0.12),
          child: Icon(Icons.image_outlined,
              color: AppColor.primary, size: height * 0.4),
        )
            : Image.network(
          banner.bannerImage,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColor.bg,
            child: Icon(Icons.broken_image_rounded,
                color: Colors.grey.shade400, size: height * 0.4),
          ),
        ),
      ),
    );
  }

  Widget _dateBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formatDate(banner.createdAt),
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700),
      ),
    );
  }

  Widget _videoBadge(String url) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_circle_outline_rounded,
              size: 13, color: AppColor.primary),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary),
            ),
          ),
        ],
      ),
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
//  _BannerFormPanel (Add / Edit Form)
// ═══════════════════════════════════════════════
class _BannerFormPanel extends StatelessWidget {
  final BannerController controller;
  final bool isBottomSheet;

  const _BannerFormPanel({
    required this.controller,
    this.isBottomSheet = false,
  });

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
                      isAdding ? 'Add New Banner' : 'Edit Banner',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAdding ? 'Create a new banner' : 'Update banner details',
                      style: TextStyle(
                          fontSize: 11.5, color: Colors.grey.shade600),
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
                  child: Icon(Icons.close_rounded,
                      size: 20, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColor.border, height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              const Text(
                'Banner Image',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black),
              ),
              const SizedBox(width: 6),
              if (!isAdding)
                Text('(leave empty to keep current)',
                    style: TextStyle(
                        fontSize: 10.5, color: Colors.grey.shade500)),
              const Spacer(),
              const Text('*',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColor.red,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          _imagePicker(context),
          const SizedBox(height: 14),

          const Text(
            'Video URL',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColor.black),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller.videoUrlCtrl,
            style: const TextStyle(fontSize: 13),
            keyboardType: TextInputType.url,
            decoration: _inputDecoration(
                hint: 'e.g. https://www.youtube.com/watch?v=…'),
          ),
          const SizedBox(height: 8),
          Text(
            'Optional — YouTube, Vimeo, Cloudinary, etc.',
            style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: AppColor.border),
                  ),
                  child: Text('Cancel',
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600)),
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
                      success = await controller.createBanner();
                    } else {
                      success = await controller.updateBanner();
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColor.white),
                  )
                      : Text(
                    isAdding ? 'Add Banner' : 'Save Changes',
                    style:
                    const TextStyle(fontWeight: FontWeight.w600),
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
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6)),
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
      final existingUrl = controller.selectedBanner.value?.bannerImage;

      Widget preview;
      if (bytes != null) {
        preview = Image.memory(bytes, fit: BoxFit.cover);
      } else if (existingUrl != null && existingUrl.isNotEmpty) {
        preview = Image.network(
          existingUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.broken_image_rounded,
              size: 32, color: Colors.grey.shade400),
        );
      } else {
        preview = Center(
            child: Icon(Icons.add_photo_alternate_rounded,
                size: 32, color: Colors.grey.shade400));
      }

      return InkWell(
        onTap: () async {
          final picker = ImagePicker();
          final XFile? file =
          await picker.pickImage(source: ImageSource.gallery);
          if (file == null) return;
          final Uint8List b = await file.readAsBytes();
          controller.setImage(bytes: b, name: file.name);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 150,
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload_rounded,
                          size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Upload',
                          style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
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
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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