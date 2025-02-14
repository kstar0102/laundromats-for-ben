import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/auth/login.auth.dart';
import 'package:laundromats/src/screen/profile/editprofile.screen.dart';
import 'package:laundromats/src/screen/profile/payment.screen.dart';
import 'package:laundromats/src/screen/profile/policy.screen.dart';
import 'package:laundromats/src/screen/profile/terms.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:laundromats/src/utils/shared_preferences_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final int _currentIndex = 4;
  final bool _isKeyboardVisible = false;
  // final Set<int> _selectedButtons = {};
  int? userId;
  String? userName;
  String? userEmail;

  String? userRole;
  String? userRoleExpert;
  String? userRoleBusiness;
  String? userRoleLaundromatsCount;
  String? userImageUrl;
  bool isLoading = false;
  List<dynamic> questions = [];

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    getUserQuestions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserQuestions() async {
    setState(() {
      isLoading = true; // ✅ Show loading bar while fetching data
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('userId');

    if (userIdString != null) {
      int? parsedUserId = int.tryParse(userIdString);

      if (parsedUserId != null) {
        setState(() {
          userId = parsedUserId;
        });

        final authService = AuthService();
        try {
          if (userId != 0) {
            final result = await authService.fetchUserData(userId!);

            if (result['success'] == true) {
              final userData = result['data'];
              setState(() {
                userName = userData['user_name'];
                GlobalVariable.userName = userData['user_name'];
                userEmail = userData['email'];
                GlobalVariable.userEmail = userData['email'];
                userRole = userData['user_role'];
                GlobalVariable.userRole = userData['user_role'];
                userRoleExpert = userData['user_role_expertIn'];
                GlobalVariable.userExpertIn = userData['user_role_expertIn'];
                userRoleBusiness = userData['user_role_businessTime'];
                GlobalVariable.userbusinessTime =
                    userData['user_role_businessTime'];
                userRoleLaundromatsCount =
                    userData['user_role_laundromatsCount'];
                GlobalVariable.userLaundromatsCount =
                    userData['user_role_laundromatsCount'];
                userImageUrl = userData['user_image'];
                GlobalVariable.userImageUrl = userData['user_image'];
              });
            } else {
              logger.e('Failed to fetch user data: Invalid response');
            }
          } else {
            logger.e('Invalid user ID: $userId');
          }
        } catch (e) {
          logger.e('Error fetching user questions: $e');
        } finally {
          setState(() {
            isLoading = false; // ✅ Hide loading bar when done
          });
        }
      }
    }
  }

  Future<void> _logoutClicked() async {
    bool confirmLogout = await _showConfirmationDialog(
      context,
      title: "Logout",
      content: "Are you sure you want to log out?",
    );

    if (confirmLogout) {
      // Clear user details from SharedPreferences
      await SharedPreferencesUtil.saveUserDetails(
        userId: "",
        userName: "",
        userEmail: "",
        userExpertIn: "",
        userBusinessTime: "",
        userLaundromatsCount: "",
      );

      // Optionally clear global variables
      GlobalVariable.userName = null;
      GlobalVariable.userEmail = null;
      GlobalVariable.userExpertIn = null;
      GlobalVariable.userbusinessTime = null;

      // Navigate to login screen or close session
      if (mounted) {
        Navigator.push(
          context, // Pass the BuildContext
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    bool confirmDelete = await _showConfirmationDialog(
      context,
      title: "Delete Account",
      content:
          "Are you sure you want to permanently delete your account? This action cannot be undone.",
    );

    if (!confirmDelete) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString("userId");

    if (userIdString == null || userIdString.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Error: Unable to delete account. Please log in again.')),
      );
      return;
    }

    int userId = int.parse(userIdString);
    bool success = await AuthService().deleteUser(userId);

    if (success) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to delete account. Please try again.')),
      );
    }
  }

  Future<void> _onPolicyClicked() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
    );
  }

  Future<void> _onTermsClicked() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
    );
  }

  Future<void> _onPaymentClicked() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CardInputScreen()),
    );
  }

  Future<void> _onEditProfileClicked() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context,
      {required String title, required String content}) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Cancel
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Confirm
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if the dialog is dismissed
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      return false;
    }
    return false;
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
    if (_isKeyboardVisible == true) {
      screenHeight = MediaQuery.of(context).size.height;
    } else {
      screenHeight = 800;
      keyboardHeight = 0;
    }
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: kColorWhite,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(0.0), // Adjust the height as needed
            child: AppBar(
              backgroundColor: kColorWhite,
              elevation: 0, // Removes shadow for a flat UI
              automaticallyImplyLeading:
                  false, // Hides back button if unnecessary
            ),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(), // ✅ Show loading spinner
                )
              : SizedBox.expand(
                  child: SingleChildScrollView(
                  child: FocusScope(
                    child: Container(
                      decoration: const BoxDecoration(color: kColorWhite),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const HeaderWidget(
                              role: true,
                              isLogoutBtn: false,
                              backIcon: false,
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
                                                      backgroundColor:
                                                          Colors.white,
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
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return const Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      },
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const CircleAvatar(
                                                          radius: 40,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Icon(
                                                            Icons.person,
                                                            color:
                                                                kColorPrimary,
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
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: vMin(context, 25),
                                        width: 1,
                                        color: kColorPrimary,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "User Role",
                                                style: TextStyle(
                                                  fontSize: 13,
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
                                                  fontSize: 13,
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
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Onset-Regular',
                                                  color: kColorPrimary,
                                                ),
                                              ),
                                              SizedBox(
                                                width: vw(context, 1),
                                              ),
                                              const Text(
                                                "10",
                                                style: TextStyle(
                                                  fontSize: 13,
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
                                                  fontSize: 12,
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
                                                  fontSize: 12,
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
                                ],
                              ),
                            ),
                            _buildProfileOption(
                              icon: Icons.person_outline,
                              title: "Edit Account",
                              onTap: _onEditProfileClicked,
                            ),
                            _buildProfileOption(
                              icon: Icons.notifications_outlined,
                              title: "Notifications",
                              onTap: () {
                                // Handle Notifications action
                              },
                            ),
                            _buildProfileOption(
                              icon: Icons.perm_device_information,
                              title: "About",
                              onTap: _onPolicyClicked,
                            ),
                            _buildProfileOption(
                              icon: Icons.policy,
                              title: "Terms",
                              onTap: _onTermsClicked,
                            ),
                            _buildProfileOption(
                              icon: Icons.credit_card_outlined,
                              title: "Manage Payment Methods",
                              onTap: _onPaymentClicked,
                            ),
                            _buildProfileOption(
                              icon: Icons.logout,
                              title: "Logout Account",
                              onTap: _logoutClicked,
                            ),
                            _buildProfileOption(
                              icon: Icons.delete_forever,
                              title: "Delete Account",
                              onTap: _deleteAccount,
                            ),
                          ]),
                    ),
                  ),
                )),
          bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex)),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: kColorPrimary, size: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: kColorSecondary,
            ),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          onTap: onTap,
        ),
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 20), // Set horizontal padding
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
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
          SizedBox(width: vw(context, 1)),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
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
