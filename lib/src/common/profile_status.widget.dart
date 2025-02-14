import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/utils/index.dart';

class ProfileStatusWidget extends StatelessWidget {
  final int? askedCount;
  final int? commentCount;
  final int? likeCount;
  final int? dislikeCount;
  final String? selectedFilter; // To track the active filter
  final Function(String?) onFilterSelected; // Callback function

  const ProfileStatusWidget({
    super.key,
    required this.askedCount,
    required this.commentCount,
    required this.likeCount,
    required this.dislikeCount,
    required this.selectedFilter,
    required this.onFilterSelected,
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
            filterKey: 'asked',
          ),
          _buildStatusItem(
            context: context,
            title: 'Commented',
            count: commentCount?.toString() ?? '0',
            icon: Icons.comment_outlined,
            filterKey: 'commented',
          ),
          _buildStatusItem(
            context: context,
            title: 'Liked',
            count: likeCount?.toString() ?? '0',
            icon: Icons.thumb_up_outlined,
            filterKey: 'liked',
          ),
          _buildStatusItem(
            context: context,
            title: 'Disliked',
            count: dislikeCount?.toString() ?? '0',
            icon: Icons.thumb_down_outlined,
            filterKey: 'disliked',
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
    required String filterKey,
  }) {
    bool isSelected = selectedFilter == filterKey;

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          onFilterSelected(null); // Remove filter if already selected
        } else {
          onFilterSelected(filterKey); // Apply new filter
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? kColorPrimary : Colors.grey.shade300),
          color: isSelected
              // ignore: deprecated_member_use
              ? kColorPrimary.withOpacity(0.2)
              : Colors.grey.shade200,
        ),
        width: vMin(context, 20), // Adjust width if needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 24, color: isSelected ? kColorPrimary : Colors.black),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? kColorPrimary : Colors.black,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              count,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? kColorPrimary : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
