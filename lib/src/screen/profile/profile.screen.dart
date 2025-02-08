import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/common/profile_status.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
// import 'package:laundromats/src/screen/home/partials/home_data.widget.dart';
import 'package:laundromats/src/screen/subscription/subscription.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';
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
  int? askedCount;
  int? commentCount;
  int? likeCount;
  int? dislikeCount;
  String? userRole;
  String? userRoleExpert;
  String? userRoleBusiness;
  String? userRoleLaundromatsCount;
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('userId');

    setState(() {
      userName = prefs.getString("userName");
      userEmail = prefs.getString("userEmail");
      isLoading = true;
    });

    if (userIdString != null) {
      int? parsedUserId = int.tryParse(userIdString);

      if (parsedUserId != null) {
        setState(() {
          userId = parsedUserId;
        });

        final authService = AuthService();
        try {
          if (userId != 0) {
            final fetchedQuestions =
                await authService.fetchUserQuestionsWithAnswers(userId!);

            final result = await authService.fetchUserData(userId!);

            if (result['success'] == true) {
              final userData = result['data'];
              setState(() {
                userRole = userData['user_role'];
                userRoleExpert = userData['user_role_expertIn'];
                userRoleBusiness = userData['user_role_businessTime'];
                userRoleLaundromatsCount =
                    userData['user_role_laundromatsCount'];
              });
            } else {
              logger.e('Failed to fetch user data: Invalid response');
            }

            setState(() {
              questions = fetchedQuestions;
              askedCount = questions.length;
              commentCount = questions.fold<int>(0, (sum, question) {
                final answers = question['answers'] as List<dynamic>?;
                return (sum) +
                    (answers?.length ?? 0); // Handle null for sum and answers
              });
              commentCount = questions.fold<int>(0, (sum, question) {
                final answers = question['answers'] as List<dynamic>?;
                return (sum) +
                    (answers?.length ?? 0); // Handle null for sum and answers
              });

              // Total likes count
              likeCount = questions.fold<int>(0, (sum, question) {
                final likes =
                    int.tryParse(question['likes_count']?.toString() ?? '0') ??
                        0;
                return (sum) + likes; // Ensure sum is non-null
              });

              // Total dislikes count
              dislikeCount = questions.fold<int>(0, (sum, question) {
                final likes = int.tryParse(
                        question['dislikes_count']?.toString() ?? '0') ??
                    0;
                return (sum) + likes; // Ensure sum is non-null
              });
              isLoading = false;
            });
          } else {
            logger.e('Invalid user ID: $userId');
          }
        } catch (e) {
          logger.e('Error fetching user questions: $e');
        }
      }
    }
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      return false;
    }
    return false;
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
          body: SizedBox.expand(
              child: SingleChildScrollView(
            child: FocusScope(
              child: Container(
                decoration: const BoxDecoration(color: kColorWhite),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const HeaderWidget(role: true, isLogoutBtn: false),
                      Container(
                        padding: EdgeInsets.only(
                            top: vMin(context, 3),
                            left: vMin(context, 4),
                            right: vMin(context, 4)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
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
                                  child: const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.person,
                                      color: kColorPrimary,
                                      size: 25,
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
                                    fontSize: 14,
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
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: vMin(context, 25),
                              width: 1,
                              color: kColorPrimary,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  free.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Onset-Regular',
                                    fontSize: 16,
                                    color: kColorSecondary,
                                  ),
                                ),
                                SizedBox(height: vMin(context, 1)),
                                Text(
                                  subscription.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Onset-Regular',
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                                SizedBox(height: vMin(context, 3)),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                const SubscriptionScreen(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          "assets/images/icons/crown-1.png"),
                                      SizedBox(width: vMin(context, 2)),
                                      Text(
                                        getPremium.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Onset-Regular',
                                          fontSize: 14,
                                          color: kColorPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: vh(context, 3),
                      ),
                      ProfileStatusWidget(
                        askedCount: askedCount ?? 0,
                        commentCount: commentCount ?? 0,
                        likeCount: likeCount ?? 0,
                        dislikeCount: dislikeCount ?? 0,
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            left: vw(context, 3.5),
                            right: vw(context, 3.5),
                            top: vh(context, 4)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "User Role",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Onset-Regular',
                                color: kColorPrimary,
                              ),
                            ),
                            Text(
                              userRole ?? " ",
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Onset-Regular',
                                color: kColorBlack,
                              ),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            left: vw(context, 3.5),
                            right: vw(context, 3.5),
                            top: vh(context, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Expert In",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Onset-Regular',
                                color: kColorPrimary,
                              ),
                            ),
                            Text(
                              userRoleExpert ?? " ",
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Onset-Regular',
                                color: kColorBlack,
                              ),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            left: vw(context, 3.5),
                            right: vw(context, 3.5),
                            top: vh(context, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Business Year",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Onset-Regular',
                                color: kColorPrimary,
                              ),
                            ),
                            Text(
                              userRoleBusiness ?? " ",
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Onset-Regular',
                                color: kColorBlack,
                              ),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            left: vw(context, 3.5),
                            right: vw(context, 3.5),
                            top: vh(context, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Number of laundromats",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Onset-Regular',
                                color: kColorPrimary,
                              ),
                            ),
                            Text(
                              userRoleLaundromatsCount ?? " ",
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Onset-Regular',
                                color: kColorBlack,
                              ),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            top: vh(context, 6),
                            left: vw(context, 3.5),
                            right: vw(context, 3.5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: vMin(context, 25),
                              child: ButtonWidget(
                                btnType: ButtonWidgetType.editProfile,
                                borderColor: kColorPrimary,
                                textColor: kColorWhite,
                                fullColor: kColorPrimary,
                                size: false,
                                icon: true,
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: vMin(context, 25),
                              child: ButtonWidget(
                                btnType: ButtonWidgetType.termsBtn,
                                borderColor: kColorPrimary,
                                textColor: kColorWhite,
                                fullColor: kColorPrimary,
                                size: false,
                                icon: true,
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: vMin(context, 25),
                              child: ButtonWidget(
                                btnType: ButtonWidgetType.settingBtn,
                                borderColor: kColorPrimary,
                                textColor: kColorWhite,
                                fullColor: kColorPrimary,
                                size: false,
                                icon: true,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      )

                      //
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       left: vMin(context, 4),
                      //       right: vMin(context, 4),
                      //       top: vMin(context, 4)),
                      //   child: Wrap(
                      //     spacing: 8,
                      //     runSpacing: 0,
                      //     alignment: WrapAlignment.start,
                      //     children: [
                      //       _buildToggleButton(0, comments.toString()),
                      //       _buildToggleButton(1, liked.toString()),
                      //       _buildToggleButton(2, disliked.toString()),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //     padding: EdgeInsets.only(
                      //         left: vMin(context, 4),
                      //         right: vMin(context, 4),
                      //         bottom: vMin(context, 3)),
                      //     child: const Divider(
                      //       color: kColorPrimary,
                      //       thickness: 1,
                      //     )),

                      // //question list
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     left: vMin(context, 4),
                      //     right: vMin(context, 4),
                      //     top: vMin(context, 2),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       isLoading
                      //           ? const Center(
                      //               child: CircularProgressIndicator(),
                      //             )
                      //           : questions.isNotEmpty
                      //               ? HomeDataWidget(
                      //                   questions: questions
                      //                       .cast<Map<String, dynamic>>(),
                      //                 )
                      //               : const Center(
                      //                   child: Padding(
                      //                     padding: EdgeInsets.all(16.0),
                      //                     child: Text(
                      //                       "No questions found.",
                      //                       style: TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold,
                      //                         color: kColorSecondary,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //     ],
                      //   ),
                      // ),
                    ]),
              ),
            ),
          )),
          bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex)),
    );
  }

  // Widget _buildToggleButton(int index, String text) {
  //   final bool isSelected = _selectedButtons.contains(index);

  //   return OutlinedButton(
  //     onPressed: () {
  //       setState(() {
  //         if (isSelected) {
  //           _selectedButtons.remove(index);
  //         } else {
  //           _selectedButtons.add(index);
  //         }
  //       });
  //     },
  //     style: OutlinedButton.styleFrom(
  //       backgroundColor: isSelected ? kColorPrimary : kColorWhite,
  //       side: const BorderSide(color: kColorPrimary),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
  //       minimumSize: const Size(0, 24),
  //     ),
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         color: isSelected ? kColorWhite : kColorPrimary,
  //         fontFamily: 'Onset-Regular',
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //   );
  // }
}
