import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/home/partials/home_data.widget.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/screen/ask_question/ask_question.screen.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/components/filter.category.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key});

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final int _currentIndex = 3;
  final bool _isKeyboardVisible = false;
  final _searchValue = TextEditingController();
  int? userId;
  List<dynamic> questions = [];
  Set<String> selectedCategories = {};
  bool isLoading = false;

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    getUserQuestions();
  }

  Future<void> getUserQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('userId');

    if (userIdString != null) {
      int? parsedUserId = int.tryParse(userIdString);

      if (parsedUserId != null) {
        setState(() {
          userId = parsedUserId; // Ensure `setState` is updating properly
        });

        final authService = AuthService();
        try {
          if (userId != 0) {
            final fetchedQuestions =
                await authService.fetchUserQuestionsWithAnswers(userId!);

            setState(() {
              questions = fetchedQuestions;
            });

            // logger.i(questions);
          } else {
            logger.e('Invalid user ID: $userId');
          }
        } catch (e) {
          logger.e('Error fetching user questions: $e');
        }
      }
    }
  }

  void _openFilterModal() async {
    final selectedFilters = await showDialog<Set<String>>(
      context: context,
      builder: (context) => const FilterCategoryModal(),
    );

    if (selectedFilters != null) {
      setState(() {
        selectedCategories = selectedFilters; // ✅ Update selected categories
      });
    }
  }

  Future<void> searchQuestions() async {
    if (userId == null) return;

    setState(() {
      questions = []; // Clear the list while searching
      isLoading = true; // Show loading indicator
    });

    try {
      final authService = AuthService();
      final searchQuery = _searchValue.text.trim();
      final List<String> categories = selectedCategories.toList();

      final response = await authService.searchQuestions(
        userId!,
        searchQuery,
        categories,
      );

      setState(() {
        questions = response;
        isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      logger.e('Error searching questions: $e');
      setState(() {
        isLoading = false; // Hide loading indicator on error
      });
    }
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
      onWillPop: () async => false,
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

                    // Header Section
                    Padding(
                      padding: EdgeInsets.all(vMin(context, 4)),
                      child: SizedBox(
                        width: vww(context, 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "My Questions",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Onset',
                                color: kColorSecondary,
                              ),
                            ),
                            SizedBox(
                              width: vMin(context, 40),
                              child: ButtonWidget(
                                btnType: ButtonWidgetType.askQuestionBtn,
                                borderColor: kColorPrimary,
                                textColor: kColorWhite,
                                fullColor: kColorPrimary,
                                size: false,
                                icon: true,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const AskQuestionScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: vMin(context, 4),
                          right: vMin(context, 4),
                          top: vMin(context, 2)),
                      child: Text(
                        allYourQuestions.toString(),
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Onset-Regular',
                          color: kColorSecondary,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: vMin(context, 4),
                          right: vMin(context, 4),
                          top: vMin(context, 2)),
                      child: Text(
                        "${questions.length} Questions",
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Onset-Regular',
                          color: kColorThird,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: vMin(context, 4),
                          right: vMin(context, 4),
                          top: vMin(context, 2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: vw(context, 38),
                            height: vh(context, 5),
                            child: TextField(
                              controller: _searchValue,
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              cursorColor: kColorPrimary,
                              onChanged: (value) {
                                setState(
                                    () {}); // Trigger UI update when text changes
                              },
                              decoration: InputDecoration(
                                hintText: search.toString(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                enabledBorder: kEnableSearchBorder,
                                focusedBorder: kFocusSearchBorder,
                                hintStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Onset-Regular',
                                  color: kColorLightGrey,
                                ),
                                filled: false,
                                disabledBorder: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                counterText: '',
                                suffixIcon: _searchValue.text
                                        .isNotEmpty // Show icons only when text exists
                                    ? Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Adjusts to content size
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.close,
                                                color: kColorPrimary),
                                            onPressed: () {
                                              setState(() {
                                                _searchValue.clear();
                                                getUserQuestions();
                                                // Clear the text field
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.send,
                                                color: kColorPrimary),
                                            onPressed:
                                                searchQuestions, // Call the search function
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: _openFilterModal,
                              child: Image.asset(
                                'assets/images/icons/filter.png',
                                fit: BoxFit.cover,
                              )),
                        ],
                      ),
                    ),

                    if (selectedCategories.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                            left: vMin(context, 4),
                            right: vMin(context, 4),
                            top: vMin(context, 2)),
                        child: Wrap(
                          spacing: 6.0, // Horizontal space between tags
                          runSpacing:
                              0.0, // Reduced vertical space between rows
                          children: selectedCategories.map((category) {
                            return Chip(
                              label: Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: kColorSecondary,
                                ),
                              ),
                              backgroundColor: kColorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(color: kColorPrimary),
                              ),
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 15,
                                color: kColorPrimary,
                              ),
                              onDeleted: () {
                                setState(() {
                                  selectedCategories.remove(category);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),

                    // Question List
                    Padding(
                      padding: EdgeInsets.only(
                        left: vMin(context, 4),
                        right: vMin(context, 4),
                        top: vMin(context, 2),
                      ),
                      child: Column(
                        children: [
                          isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : questions.isNotEmpty
                                  ? HomeDataWidget(
                                      questions: questions
                                          .cast<Map<String, dynamic>>(),
                                    )
                                  : const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          "No questions found.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kColorSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex),
      ),
    );
  }
}
