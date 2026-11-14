// lib/feature/dashboard/widget/current_request_card.dart
// (adjust path as per your project)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../controller/booking_controller.dart';
import '../model/booking_model.dart';

class CurrentRequestCard extends StatelessWidget {
  const CurrentRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();

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
          // ── Header ──
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
                  Obx(() {
                    final count = controller.bookings.length;
                    return Text(
                      '$count pending request${count == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── List area ──
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error state
              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade400, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: controller.retry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Empty state
              if (controller.bookings.isEmpty) {
                return Center(
                  child: Text(
                    'No current requests',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                );
              }

              // Data list
              return ListView.separated(
                itemCount: controller.bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = controller.bookings[index];
                  return _buildRequestCardFromBooking(booking);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Map BookingModel → existing card UI ──
  Widget _buildRequestCardFromBooking(BookingModel booking) {
    final status = booking.status.toLowerCase();
    final isUrgent = status == 'pending';
    final tags = [
      booking.serviceDetail.category.name, // first tag (orange)
      booking.status,                      // second tag (red/green)
    ];
    final time = _formatTime(booking.createdAt);

    return _buildRequestCard(
      title: booking.serviceDetail.title,
      desc: booking.serviceDetail.description,
      tags: tags,
      category: booking.serviceDetail.category.name,
      time: time,
      isUrgent: isUrgent,
    );
  }

  // ── Relative time formatting ──
  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    }
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  // ── Existing card builder (unchanged) ──
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
                    _miniTag(
                      tags[1],
                      isUrgent
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF10B981),
                    ),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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

  // ── Mini tag chip (unchanged) ──
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