import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suwidhaa_it_service_dashboard/feature/auth/screen/auth_screen.dart';
import '../../../core/utils/app_color.dart';
import '../../banner/widget/banner_card.dart';
import '../../category/controller/category_controller.dart';
import '../../category/widget/category_card.dart';
import '../../service/widget/category_service_card.dart';
import '../../dashboard/widget/dashboard_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final _categoryCtrl = Get.find<CategoryController>();

  final _ads = const [/* ... same as before ... */];
  final _banners = const [/* ... same as before ... */];

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColor.red),
            ),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userEmail');
    Get.offAll(() => const AuthScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.dashboard_customize_rounded,
                color: AppColor.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Suwidhaa Dashboard',
              style: TextStyle(
                color: AppColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded, color: AppColor.black),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 240, child: _buildSidebar()),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  SIDEBAR
  // ═══════════════════════════════════════════════
  Widget _buildSidebar() {
    return Container(
      color: AppColor.white,
      child: Column(
        children: [
          const SizedBox(height: 12),
          _sidebarItem(
            index: 0,
            label: 'Dashboard',
            icon: Icons.dashboard_rounded,
            onTap: () {
              setState(() => _selectedIndex = 0);
              _categoryCtrl.resetForm();
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(child: Divider(color: AppColor.border, height: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'CATEGORIES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppColor.border, height: 1)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Dynamic category list from API ──
          Expanded(
            child: Obx(() {
              if (_categoryCtrl.isLoading.value &&
                  _categoryCtrl.categories.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                );
              }
              if (_categoryCtrl.categories.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'No categories yet',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _categoryCtrl.categories.length,
                itemBuilder: (context, i) {
                  final cat = _categoryCtrl.categories[i];
                  final isSelected =
                      _categoryCtrl.selectedCategory.value?.id == cat.id;
                  return _sidebarItem(
                    index: 2 + i,
                    label: cat.name,
                    icon: cat.id == 0 ? Icons.apps_rounded : Icons.folder_rounded,
                    // Clicking category opens CategoryServiceCard
                    selectedOverride: isSelected && _selectedIndex == 2,
                    onTap: () {
                      setState(() => _selectedIndex = 2);
                      _categoryCtrl.selectCategory(cat);
                    },
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.white,
              border: Border(top: BorderSide(color: AppColor.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Clicking Add Category opens CategoryCard with Form
                  setState(() => _selectedIndex = 1);
                  _categoryCtrl.startAdding();
                },
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Category'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required int index,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool? selectedOverride,
  }) {
    final selected = selectedOverride ?? (_selectedIndex == index);
    return Padding(
      padding: const EdgeInsets.only(bottom: 3, right: 10, left: 10),
      child: Material(
        color:
        selected ? AppColor.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? AppColor.primary : Colors.grey.shade700,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? AppColor.primary
                          : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // Widget _buildContent() {
  //   if (_selectedIndex == '') {
  //     return const BannerCard();
  //   }
  //   if (_selectedIndex == 0) {
  //     return DashboardCard();
  //   }
  //   if (_selectedIndex == 1) {
  //     return const CategoryCard();
  //   }
  //   if (_selectedIndex == 2) {
  //     final selectedCat = _categoryCtrl.selectedCategory.value;
  //     return CategoryServiceCard(
  //       categoryId: selectedCat?.id ?? 0,
  //       categoryName: selectedCat?.name ?? 'All Services',
  //     );
  //   }
  //   return const CategoryCard();
  // }
  Widget _buildContent() {
    if (_selectedIndex == 3) {
      return  BannerCard(
        onBack: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      );
    }

    if (_selectedIndex == 0) {
      return DashboardCard(
        onAdsWorkshopTapped: () {
          setState(() {
            _selectedIndex = 3;
          });
        },
      );
    }

    if (_selectedIndex == 1) {
      return const CategoryCard();
    }

    if (_selectedIndex == 2) {
      final selectedCat = _categoryCtrl.selectedCategory.value;
      return CategoryServiceCard(
        categoryId: selectedCat?.id ?? 0,
        categoryName: selectedCat?.name ?? 'All Services',
      );
    }

    return const CategoryCard();
  }
}