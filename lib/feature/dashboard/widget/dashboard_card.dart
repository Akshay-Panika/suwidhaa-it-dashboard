import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../../order/widget/current_request_card.dart';

class DashboardCard extends StatelessWidget {
  final VoidCallback? onBannerTapped; // 👈 Banner ke liye
  final VoidCallback? onAdsTapped;    // 👈 Ads ke liye
  final VoidCallback? onServiceTapped;    // 👈 Ads ke liye

  const DashboardCard({
    super.key,
    this.onBannerTapped,
    this.onAdsTapped,
    this.onServiceTapped,
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

            final rightSide = CurrentRequestCard();

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
                    onTap: onBannerTapped,
                    title: 'Banner Maintenance',
                    tag: 'Suwidhaa IT',
                    desc: 'Server upgrade scheduled on Nov 25, 2026.',
                    color: const Color(0xFFEFF6FF),
                    borderColor: const Color(0xFF3B82F6),
                    icon: '🛠️',
                    width: isSmall ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _buildNoticeItem(
                    onTap: onServiceTapped,
                    title: 'New Service Added',
                    tag: 'Suwidhaa IT',
                    desc: 'Home Automation service is now live.',
                    color: const Color(0xFFECFDF5),
                    borderColor: const Color(0xFF10B981),
                    icon: '⚡',
                    width: isSmall ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                  ),
                  _buildNoticeItem(
                    onTap: onAdsTapped,
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

}