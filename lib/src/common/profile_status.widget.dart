import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Beginner',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset',
                  color: kColorSecondary,
                ),
              ),
              SizedBox(height: vMin(context, 1)),
              const Text(
                "Level",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset-Regular',
                  color: kColorSecondary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                askedCount?.toString() ?? '0',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset',
                  color: kColorSecondary,
                ),
              ),
              SizedBox(height: vMin(context, 1)),
              const Text(
                'Asked',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset-Regular',
                  color: kColorSecondary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                commentCount?.toString() ?? '0',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset',
                ),
              ),
              SizedBox(height: vMin(context, 1)),
              const Text(
                "Commented",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset-Regular',
                  color: kColorSecondary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                likeCount?.toString() ?? '0',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset',
                ),
              ),
              SizedBox(height: vMin(context, 1)),
              const Text(
                "Liked",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset-Regular',
                  color: kColorSecondary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                dislikeCount?.toString() ?? '0',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset',
                ),
              ),
              SizedBox(height: vMin(context, 1)),
              const Text(
                "Disliked",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset-Regular',
                  color: kColorSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
