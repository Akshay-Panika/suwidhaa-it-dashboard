import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';
import '../../category/widget/category_service_card.dart'; // for itCategories

// ═══════════════════════════════════════════════════════════════
//  DASHBOARD CARD — self-contained stats grid
//  No params needed. Renders all 4 stat cards internally.
// ═══════════════════════════════════════════════════════════════
class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Compute stats from category data ──
    final totalServices =
    itCategories.fold<int>(0, (s, c) => s + c.services.length);
    final activeServices = itCategories.fold<int>(
      0,
          (s, c) =>
      s + c.services.where((x) => x.status.toLowerCase() == 'active').length,
    );
    final inactiveServices = totalServices - activeServices;

    final stats = <_StatData>[
      _StatData(
        icon: Icons.category_rounded,
        title: 'Total Categories',
        value: '${itCategories.length}',
        change: '+2',
        isPositive: true,
        subtitle: '$totalServices services total',
        color: AppColor.primary,
      ),
      _StatData(
        icon: Icons.miscellaneous_services_rounded,
        title: 'Total Services',
        value: '$totalServices',
        change: '+4%',
        isPositive: true,
        subtitle: '$activeServices active',
        color: const Color(0xFF3B82F6),
      ),
      _StatData(
        icon: Icons.verified_rounded,
        title: 'Active Services',
        value: '$activeServices',
        change: '+6%',
        isPositive: true,
        subtitle: '$inactiveServices inactive',
        color: const Color(0xFF10B981),
      ),
      _StatData(
        icon: Icons.pending_actions_rounded,
        title: 'Inactive Services',
        value: '$inactiveServices',
        change: '-2%',
        isPositive: false,
        subtitle: 'Needs review',
        color: const Color(0xFFEF4444),
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth < 650 ? 1 : c.maxWidth < 1100 ? 2 : 4;
        const gap = 16.0;
        final w = (c.maxWidth - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats.map((s) {
            return SizedBox(width: w, child: _StatItem(data: s));
          }).toList(),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════
//  _StatData — internal data model
// ═══════════════════════════════════════════════
class _StatData {
  final IconData icon;
  final String title;
  final String value;
  final String? change;
  final String? subtitle;
  final bool isPositive;
  final Color color;

  const _StatData({
    required this.icon,
    required this.title,
    required this.value,
    this.change,
    this.subtitle,
    this.isPositive = true,
    required this.color,
  });
}

// ═══════════════════════════════════════════════
//  _StatItem — single stat card (internal)
// ═══════════════════════════════════════════════
class _StatItem extends StatelessWidget {
  final _StatData data;
  const _StatItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final trendColor = data.isPositive ? const Color(0xFF10B981) : AppColor.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: data.color, size: 22),
              ),
              const Spacer(),
              if (data.change != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: trendColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.isPositive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 13,
                        color: trendColor,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        data.change!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            data.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (data.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              data.subtitle!,
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ADS CARD — unchanged
// ═══════════════════════════════════════════════════════════════
class AdsCard extends StatelessWidget {
  final String campaignName;
  final String platformName;
  final IconData platformIcon;
  final Color accentColor;
  final double budget;
  final double spent;
  final int impressions;
  final int clicks;
  final String status;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdsCard({
    super.key,
    this.campaignName = 'Summer Sale Campaign',
    this.platformName = 'Google Ads',
    this.platformIcon = Icons.ads_click_rounded,
    this.accentColor = AppColor.primary,
    this.budget = 50000,
    this.spent = 32500,
    this.impressions = 148000,
    this.clicks = 3200,
    this.status = 'Active',
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  double get _progress => budget == 0 ? 0 : (spent / budget).clamp(0.0, 1.0);
  double get _ctr => impressions == 0 ? 0 : (clicks / impressions) * 100;

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981);
      case 'paused':
        return const Color(0xFFF59E0B);
      default:
        return AppColor.red;
    }
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(platformIcon, color: accentColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaignName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          platformName,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Budget spent',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹${spent.toStringAsFixed(0)} / ₹${budget.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  backgroundColor: AppColor.border,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
              const SizedBox(height: 14),
              Divider(color: AppColor.border, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  _metric(
                    Icons.visibility_outlined,
                    _formatNum(impressions),
                    'Views',
                  ),
                  const SizedBox(width: 16),
                  _metric(
                    Icons.touch_app_outlined,
                    _formatNum(clicks),
                    'Clicks',
                  ),
                  const SizedBox(width: 16),
                  _metric(
                    Icons.trending_up_rounded,
                    '${_ctr.toStringAsFixed(2)}%',
                    'CTR',
                  ),
                  const Spacer(),
                  _iconBtn(
                    Icons.edit_outlined,
                    AppColor.black.withOpacity(0.55),
                    onEdit,
                  ),
                  const SizedBox(width: 4),
                  _iconBtn(
                    Icons.delete_outline_rounded,
                    AppColor.red,
                    onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback? onTap) {
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

// ═══════════════════════════════════════════════════════════════
//  BANNER CARD — unchanged
// ═══════════════════════════════════════════════════════════════
class BannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String position;
  final List<Color> gradient;
  final IconData icon;
  final int impressions;
  final int clicks;
  final bool isActive;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BannerCard({
    super.key,
    this.title = 'Diwali Mega Sale',
    this.subtitle = 'Flat 40% off on all IT services',
    this.position = 'Hero',
    this.gradient = const [AppColor.primary, Color(0xFF6D28D9)],
    this.icon = Icons.campaign_rounded,
    this.impressions = 92000,
    this.clicks = 2100,
    this.isActive = true,
    this.onToggle,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  double get _ctr => impressions == 0 ? 0 : (clicks / impressions) * 100;

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isActive
                        ? gradient
                        : [Colors.grey.shade400, Colors.grey.shade500],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(
                        icon,
                        size: 80,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          position.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF10B981)
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isActive ? 'LIVE' : 'OFF',
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Row(
                  children: [
                    _metric(
                      Icons.visibility_outlined,
                      _formatNum(impressions),
                      'Views',
                    ),
                    const SizedBox(width: 14),
                    _metric(
                      Icons.touch_app_outlined,
                      _formatNum(clicks),
                      'Clicks',
                    ),
                    const SizedBox(width: 14),
                    _metric(
                      Icons.trending_up_rounded,
                      '${_ctr.toStringAsFixed(1)}%',
                      'CTR',
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: isActive,
                        activeColor: AppColor.primary,
                        onChanged: onToggle,
                      ),
                    ),
                    _iconBtn(
                      Icons.edit_outlined,
                      AppColor.black.withOpacity(0.55),
                      onEdit,
                    ),
                    const SizedBox(width: 2),
                    _iconBtn(
                      Icons.delete_outline_rounded,
                      AppColor.red,
                      onDelete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback? onTap) {
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