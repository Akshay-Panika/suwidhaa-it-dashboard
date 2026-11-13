import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suwidhaa_it_service_dashboard/feature/auth/screen/auth_screen.dart';
import '../../../core/utils/app_color.dart';
import '../../category/widget/category_service_card.dart';
import '../../dashboard/widget/dashboard_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // ═══════════════════════════════════════════════
  //  AD + BANNER DATA
  // ═══════════════════════════════════════════════
  final _ads = const [
    {
      'campaign': 'Summer Sale Campaign',
      'platform': 'Google Ads',
      'icon': Icons.ads_click_rounded,
      'color': Color(0xFF3B82F6),
      'budget': 50000.0,
      'spent': 32500.0,
      'impressions': 148000,
      'clicks': 3200,
      'status': 'Active',
    },
    {
      'campaign': 'App Install Promo',
      'platform': 'Meta Ads',
      'icon': Icons.facebook_rounded,
      'color': Color(0xFF1877F2),
      'budget': 40000.0,
      'spent': 40000.0,
      'impressions': 210000,
      'clicks': 5800,
      'status': 'Ended',
    },
    {
      'campaign': 'Retargeting Campaign',
      'platform': 'Google Ads',
      'icon': Icons.ads_click_rounded,
      'color': Color(0xFF3B82F6),
      'budget': 30000.0,
      'spent': 12500.0,
      'impressions': 85000,
      'clicks': 1900,
      'status': 'Active',
    },
    {
      'campaign': 'Festive Offer Blast',
      'platform': 'Instagram',
      'icon': Icons.camera_alt_rounded,
      'color': Color(0xFFEC4899),
      'budget': 60000.0,
      'spent': 18000.0,
      'impressions': 320000,
      'clicks': 4100,
      'status': 'Paused',
    },
  ];

  final _banners = const [
    {
      'title': 'Diwali Mega Sale',
      'subtitle': 'Flat 40% off on all IT services',
      'position': 'Hero',
      'gradient': [AppColor.primary, Color(0xFF6D28D9)],
      'icon': Icons.celebration_rounded,
      'impressions': 92000,
      'clicks': 2100,
      'active': true,
    },
    {
      'title': 'New Mobile App Launch',
      'subtitle': 'Download our iOS & Android app',
      'position': 'Header',
      'gradient': [Color(0xFF3B82F6), Color(0xFF1E40AF)],
      'icon': Icons.phone_iphone_rounded,
      'impressions': 68000,
      'clicks': 1450,
      'active': true,
    },
    {
      'title': 'Free SEO Audit',
      'subtitle': 'Get your free 20-point SEO report',
      'position': 'Sidebar',
      'gradient': [Color(0xFF10B981), Color(0xFF047857)],
      'icon': Icons.search_rounded,
      'impressions': 45000,
      'clicks': 900,
      'active': false,
    },
  ];

  // ═══════════════════════════════════════════════
  //  LOGOUT
  // ═══════════════════════════════════════════════
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

  // ═══════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════
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
          ),
          _sidebarItem(
            index: 1,
            label: 'All Services',
            icon: Icons.apps_rounded,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Divider(color: AppColor.border, height: 1),
                ),
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
                Expanded(
                  child: Divider(color: AppColor.border, height: 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: itCategories.length,
              itemBuilder: (context, i) {
                final cat = itCategories[i];
                return _sidebarItem(
                  index: i + 2,
                  label: cat.name,
                  icon: cat.icon,
                  trailing: Text(
                    '${cat.services.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _selectedIndex == i + 2
                          ? AppColor.primary
                          : Colors.grey.shade500,
                    ),
                  ),
                );
              },
            ),
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
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Service'),
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
    Widget? trailing,
  }) {
    final selected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 3, right: 10, left: 10),
      child: Material(
        color: selected
            ? AppColor.primary.withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _selectedIndex = index),
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
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  CONTENT SWITCH
  // ═══════════════════════════════════════════════
  Widget _buildContent() {
    if (_selectedIndex == 0) return _dashboardView();
    return CategoryServiceCard(
      categoryIndex: _selectedIndex == 1 ? null : _selectedIndex - 2,
    );
  }

  // ═══════════════════════════════════════════════
  //  DASHBOARD VIEW
  // ═══════════════════════════════════════════════
  Widget _dashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pageHeader('Dashboard', 'Welcome back, Admin 👋'),
          const SizedBox(height: 24),

          // ═══════════════════════════════════════
          //  1. STAT CARDS — self-contained (no params)
          // ═══════════════════════════════════════
          const DashboardCard(),

          const SizedBox(height: 32),

          // ═══════════════════════════════════════
          //  2. AD CAMPAIGNS
          // ═══════════════════════════════════════
          _sectionHeader(
            'Active Ad Campaigns',
            '${_ads.length} campaigns running',
            Icons.ads_click_rounded,
            const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 16),
          _responsiveGrid(
            maxCols: 3,
            children: _ads.map((ad) {
              return AdsCard(
                campaignName: ad['campaign'] as String,
                platformName: ad['platform'] as String,
                platformIcon: ad['icon'] as IconData,
                accentColor: ad['color'] as Color,
                budget: ad['budget'] as double,
                spent: ad['spent'] as double,
                impressions: ad['impressions'] as int,
                clicks: ad['clicks'] as int,
                status: ad['status'] as String,
                onTap: () {},
                onEdit: () {},
                onDelete: () {},
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // ═══════════════════════════════════════
          //  3. PROMO BANNERS
          // ═══════════════════════════════════════
          _sectionHeader(
            'Promo Banners',
            '${_banners.where((b) => b['active'] == true).length} active',
            Icons.view_carousel_rounded,
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          _responsiveGrid(
            maxCols: 3,
            children: _banners.map((b) {
              return BannerCard(
                title: b['title'] as String,
                subtitle: b['subtitle'] as String,
                position: b['position'] as String,
                gradient: (b['gradient'] as List).cast<Color>(),
                icon: b['icon'] as IconData,
                impressions: b['impressions'] as int,
                clicks: b['clicks'] as int,
                isActive: b['active'] as bool,
                onToggle: (v) {},
                onTap: () {},
                onEdit: () {},
                onDelete: () {},
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // ═══════════════════════════════════════
          //  4. RECENT ACTIVITY
          // ═══════════════════════════════════════
          _pageHeader('Recent Activity', 'Your latest updates'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.border),
            ),
            child: Column(
              children: List.generate(5, (i) {
                final labels = [
                  'New ad campaign "Summer Sale" started',
                  'Banner "Diwali Mega Sale" went live',
                  'Category "AI / ML Solutions" updated',
                  'Payment received — ₹ 2,500 from Priya Verma',
                  'New service "Chatbot Integration" added',
                ];
                final icons = [
                  Icons.ads_click_rounded,
                  Icons.view_carousel_rounded,
                  Icons.category_rounded,
                  Icons.payments_rounded,
                  Icons.miscellaneous_services_rounded,
                ];
                return Padding(
                  padding: EdgeInsets.only(bottom: i == 4 ? 0 : 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icons[i],
                          size: 16,
                          color: AppColor.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      Text(
                        '${i + 1}h ago',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════
  Widget _responsiveGrid({
    required int maxCols,
    required List<Widget> children,
  }) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth < 650
            ? 1
            : c.maxWidth < 1100
            ? (maxCols > 2 ? 2 : maxCols)
            : maxCols;
        const gap = 16.0;
        final w = (c.maxWidth - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children.map((child) {
            return SizedBox(width: w, child: child);
          }).toList(),
        );
      },
    );
  }

  Widget _pageHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _sectionHeader(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}