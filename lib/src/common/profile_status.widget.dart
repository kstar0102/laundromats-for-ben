import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';
// import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/utils/index.dart';

class ProfileStatusWidget extends StatelessWidget {
  final int? askedCount;
  final int? commentCount;
  final int? likeCount;
  final int? dislikeCount;

  const ProfileStatusWidget({
    super.key,
    required this.askedCount,
    required this.commentCount,
    required this.likeCount,
    required this.dislikeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: vMin(context, 4),
        right: vMin(context, 4),
        top: vMin(context, 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusItem(
            context: context,
            title: 'Asked',
            count: askedCount?.toString() ?? '0',
            icon: Icons.question_answer_outlined,
          ),
          _buildStatusItem(
            context: context,
            title: 'Commented',
            count: commentCount?.toString() ?? '0',
            icon: Icons.comment_outlined,
          ),
          _buildStatusItem(
            context: context,
            title: 'Liked',
            count: likeCount?.toString() ?? '0',
            icon: Icons.thumb_up_outlined,
          ),
          _buildStatusItem(
            context: context,
            title: 'Disliked',
            count: dislikeCount?.toString() ?? '0',
            icon: Icons.thumb_down_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required BuildContext context,
    required String title,
    required String count,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade200, // Light background color
      ),
      width: vMin(context, 20), // Adjust width if needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: kColorPrimary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            count,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
