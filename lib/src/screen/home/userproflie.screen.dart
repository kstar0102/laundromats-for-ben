import 'package:flutter/material.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:logger/logger.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final logger = Logger();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  String? userName;
  String? userEmail;
  String? userRole;
  String? userRoleExpert;
  String? userRoleBusiness;
  String? userRoleLaundromatsCount;
  String? userImageUrl;
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final authService = AuthService();
      final result = await authService.fetchUserData(widget.userId);

      if (result['success'] == true) {
        setState(() {
          userData = result['data'];
          userName = userData!['user_name'];
          userEmail = userData!['email'];
          userRole = userData!['user_role'];
          userRoleExpert = userData!['user_role_expertIn'];
          userRoleBusiness = userData!['user_role_businessTime'];
          userRoleLaundromatsCount = userData!['user_role_laundromatsCount'];
          userImageUrl = userData!['user_image'];

          isLoading = false;
        });
      } else {
        logger.e('Failed to fetch user data: ${result['message']}');
      }
    } catch (e) {
      logger.e('Error fetching user profile: $e');
    }
  }

  void _showBadgeDialog(String title, String emoji) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("You will get this badge"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                emoji,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('Failed to load user data'))
              : SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderWidget(role: false, isLogoutBtn: false),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: kColorPrimary,
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: userImageUrl == null ||
                                                userImageUrl!.isEmpty
                                            ? const CircleAvatar(
                                                radius: 40,
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.person,
                                                  color: kColorPrimary,
                                                  size: 40,
                                                ),
                                              )
                                            : Image.network(
                                                userImageUrl!,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons.person,
                                                      color: kColorPrimary,
                                                      size: 40,
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: vMin(context, 1)),
                                    Text(
                                      userName ?? 'Guest',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Onset-Regular',
                                        color: kColorSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: vMin(context, 0.5)),
                                    Text(
                                      userEmail ?? 'Guest Email',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: kColorPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: vh(context, 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildBadgeItem(
                                    "Answered 1 question",
                                    "assets/images/icons/first_answer.png",
                                    "Helping Hand Answered 10 questions",
                                    "assets/images/icons/ten_answer.png"),
                                SizedBox(
                                  width: vw(context, 3),
                                ),
                                _buildBadgeItem(
                                    "Active Member ",
                                    "assets/images/icons/week_login.png",
                                    "Super Active Logged in daily for 30 days",
                                    "assets/images/icons/month_login.png"),
                              ],
                            ),
                            SizedBox(
                              height: vh(context, 1),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "User Role",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Onset-Regular',
                                        color: kColorPrimary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: vw(context, 2),
                                    ),
                                    Text(
                                      userRole ?? " ",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Onset-Regular',
                                        color: kColorBlack,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: vh(context, 1),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Tips earned for answers",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Onset-Regular',
                                        color: kColorPrimary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: vw(context, 2),
                                    ),
                                    const Text(
                                      "10",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Onset-Regular',
                                        color: kColorBlack,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: vh(context, 1),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Tips given to others",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Onset-Regular',
                                        color: kColorPrimary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: vw(context, 2),
                                    ),
                                    const Text(
                                      "25",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Onset-Regular',
                                        color: kColorBlack,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildBadgeItem(
      String text, String emoji, String dialogText, String dialogEmoji) {
    return GestureDetector(
      onTap: () {
        _showBadgeDialog(dialogText, dialogEmoji);
      },
      child: Row(
        children: [
          Image.asset(
            emoji,
            width: 24, // Set a fixed size for the image
            height: 24,
          ),
          SizedBox(width: vw(context, 1)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Onset-Regular',
              color: kColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
