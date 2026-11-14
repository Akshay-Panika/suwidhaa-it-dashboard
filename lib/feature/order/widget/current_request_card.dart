import 'package:flutter/material.dart';

import '../../../core/utils/app_color.dart';

class CurrentRequestCard extends StatelessWidget {
  const CurrentRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
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
