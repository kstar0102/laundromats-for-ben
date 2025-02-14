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
                      const HeaderWidget(
                        role: false,
                        isLogoutBtn: false,
                        backIcon: true,
                      ),
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
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
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
                                                radius: 50,
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.person,
                                                  color: kColorPrimary,
                                                  size: 50,
                                                ),
                                              )
                                            : Image.network(
                                                userImageUrl!,
                                                width: 120,
                                                height: 120,
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
                                                    radius: 45,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons.person,
                                                      color: kColorPrimary,
                                                      size: 50,
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
                                        fontSize: 16,
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
                                  width: vw(context, 2),
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
                            const Divider(
                              color: kColorThird,
                              thickness: 0.7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: vh(context, 1),
                                ),
                                _buildUserRoleItem(
                                    "Tips earned for answers", "12"),
                                SizedBox(
                                  height: vh(context, 1),
                                ),
                                _buildUserRoleItem(
                                    "Tips given to others", "86"),
                                SizedBox(
                                  height: vh(context, 1),
                                ),
                                const Divider(
                                  color: kColorThird,
                                  thickness: 0.6,
                                ),
                                SizedBox(
                                  height: vh(context, 1),
                                ),
                                _buildUserRoleItem(
                                    "User Role", userRole ?? " "),
                                SizedBox(
                                  height: vh(context, 1),
                                ),
                                userRole != "Owner"
                                    ? _buildUserRoleItem(
                                        "Expert In", userRoleExpert ?? " ")
                                    : const SizedBox.shrink(),
                                userRole != "Owner"
                                    ? SizedBox(
                                        height: vh(context, 1),
                                      )
                                    : const SizedBox.shrink(),
                                _buildUserRoleItem(
                                    "Business Years", userRoleBusiness ?? " "),
                                SizedBox(
                                  height: vh(context, 1),
                                ),
                                userRole != "Mechanic"
                                    ? _buildUserRoleItem("Laundromats Counts",
                                        userRoleLaundromatsCount ?? " ")
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: vh(context, 3),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: vMin(context, 100),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  kColorPrimary, // Green background color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 20), // Adjust padding
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 15,
                                fontFamily: 'Onset-Regular',
                              ),
                            ),
                          ),
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
            width: 22, // Set a fixed size for the image
            height: 22,
          ),
          SizedBox(width: vw(context, 0.5)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Onset-Regular',
              color: kColorPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRoleItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Onset-Regular',
            color: kColorPrimary,
          ),
        ),
        Text(
          value.isNotEmpty ? value : "  ",
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Onset-Regular',
            color: kColorBlack,
          ),
        ),
      ],
    );
  }
}
