import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';

class DashboardCard extends StatelessWidget {
  final VoidCallback? onAdsWorkshopTapped;
  const DashboardCard({
    super.key,
    this.onAdsWorkshopTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;

            final leftSide = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildOverviewCard(),
                    const SizedBox(height: 24),
                    _buildNoticeBoard(),
                  ],
                )
              ],
            );

            final rightSide = _buildLiveRequests();

            if (isMobile) {
              return Column(
                children: [
                  leftSide,
                  const SizedBox(height: 24),
                  rightSide,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: leftSide),
                const SizedBox(width: 24),
                Expanded(flex: 3, child: rightSide),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Header
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Back, Admin! 👋',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Here's what's happening with your dashboard today",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Overview Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Service Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Tap to view details →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 0.65, // Example
                      strokeWidth: 14,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.primary.withOpacity(0.8),
                      ),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '65%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          Text(
                            'Resolved',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem('Completed', '0', const Color(0xFF10B981)),
                    const SizedBox(height: 12),
                    _buildLegendItem('Pending', '0', const Color(0xFFEF4444)),
                    const SizedBox(height: 12),
                    _buildLegendItem('In Progress', '0', const Color(0xFFF59E0B)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String count, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
        Text(
          count,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Notice Board
  // ─────────────────────────────────────────────────────────────
  Widget _buildNoticeBoard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📌 System Updates',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 600;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildNoticeItem(
                    onTap: onAdsWorkshopTapped,
                    title: 'Banner Maintenance',
                    tag: 'Suwidhaa IT',
                    desc: 'Server upgrade scheduled on Nov 25, 2026.',
                    color: const Color(0xFFEFF6FF),
                    borderColor: const Color(0xFF3B82F6),
                    icon: '🛠️',
                    width: isSmall ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _buildNoticeItem(
                    title: 'New Service Added',
                    tag: 'Suwidhaa IT',
                    desc: 'Home Automation service is now live.',
                    color: const Color(0xFFECFDF5),
                    borderColor: const Color(0xFF10B981),
                    icon: '⚡',
                    width: isSmall ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _buildNoticeItem(
                    title: 'Ads Workshop',
                    tag: 'Suwidhaa IT',
                    desc: 'Annual tech workshop scheduled on Jan 10.',
                    color: const Color(0xFFECFDF5),
                    borderColor: const Color(0xFF10B981),
                    icon: '🏆',
                    width: isSmall ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem({
    required String title,
    required String tag,
    required String desc,
    required Color color,
    required Color borderColor,
    required String icon,
    required double width,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 16,
                          decoration: BoxDecoration(
                            color: borderColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(icon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: borderColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Live Requests
  // ─────────────────────────────────────────────────────────────
  Widget _buildLiveRequests() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: Color(0xFFEF4444),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Requests',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  Text(
                    '6 pending requests',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildRequestCard(
                  title: 'AC Repair Required',
                  desc: 'AC not working in Server Room',
                  tags: ['High', 'Pending'],
                  category: 'Maintenance',
                  time: '2 min ago',
                  isUrgent: true,
                ),
                const SizedBox(height: 12),
                _buildRequestCard(
                  title: 'New Service Enquiry',
                  desc: 'Inquiry for CCTV Installation in Office',
                  tags: ['Medium', 'In Progress'],
                  category: 'Enquiry',
                  time: '15 min ago',
                  isUrgent: false,
                ),
                const SizedBox(height: 12),
                _buildRequestCard(
                  title: 'Staff Leave Request',
                  desc: 'Medical leave for Tech Support Agent',
                  tags: ['High', 'Pending'],
                  category: 'Leave',
                  time: '1 hour ago',
                  isUrgent: true,
                ),
                const SizedBox(height: 12),
                _buildRequestCard(
                  title: 'Payment Query',
                  desc: 'Payment receipt not generated',
                  tags: ['Low', 'Resolved'],
                  category: 'Billing',
                  time: '2 hours ago',
                  isUrgent: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required String title,
    required String desc,
    required List<String> tags,
    required String category,
    required String time,
    required bool isUrgent,
  }) {
    final bgColor = isUrgent ? const Color(0xFFFEF2F2) : AppColor.white;
    final borderColor = isUrgent ? const Color(0xFFFCA5A5) : AppColor.border;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _miniTag(tags[0], const Color(0xFFF59E0B)),
                    _miniTag(tags[1], isUrgent ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.folder_outlined, size: 12, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                category,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ADS CARD (Restored so main_screen.dart doesn't throw errors)
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
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
            ],
          ),
        ),
      ),
    );
  }
}