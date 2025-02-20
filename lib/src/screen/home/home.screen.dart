import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/components/filter.category.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/home/filter.bar.widget.dart';
import 'package:laundromats/src/screen/home/partials/home_data.widget.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final int _currentIndex = 0;
  final bool _isKeyboardVisible = false;
  String? userName;
  String? userImageUrl;
  List<dynamic> questions = [];
  bool _isLoading = false;
  final logger = Logger();
  Set<String> selectedCategories = {};
  Set<String> selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _loadFilters();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool allowRevert = true;

  Future<void> _loadFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategories =
          (prefs.getStringList('Home_selectedCategories') ?? []).toSet();
      selectedFilters =
          (prefs.getStringList('Home_selectedFilters') ?? []).toSet();
    });
  }

  void _saveFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'Home_selectedCategories', selectedCategories.toList());
    await prefs.setStringList('Home_selectedFilters', selectedFilters.toList());
  }

  void _resetFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('Home_selectedCategories');
    await prefs.remove('Home_selectedFilters');
    setState(() {
      selectedCategories.clear();
      selectedFilters.clear();
    });
  }

  Future<void> getData() async {
    final authService = AuthService();
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('userId');
    int? parsedUserId = int.tryParse(userIdString!);
    try {
      if (parsedUserId != 0) {
        final result = await authService.fetchUserData(parsedUserId!);

        if (result['success'] == true) {
          final userData = result['data'];
          setState(() {
            userName = userData['user_name'];
            userImageUrl = userData['user_image'];
            GlobalVariable.userName = userData['user_name'];
            GlobalVariable.userImageUrl = userData['user_image'];
          });
        } else {
          logger.e('Failed to fetch user data: Invalid response');
        }
      } else {
        logger.e('Invalid user ID: $parsedUserId');
      }
    } catch (e) {
      logger.e('Error fetching user questions: $e');
    }

    try {
      final fetchedQuestions = await authService.fetchQuestionsWithAnswers();
      final validQuestions = fetchedQuestions
          .whereType<Map<String, dynamic>>() // Filters out non-map elements
          .toList();

      setState(() {
        questions = validQuestions;
        _isLoading = false;
      });
    } catch (e) {
      logger.i('Error fetching questions: $e');
    }
  }

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      return false;
    }
    return false;
  }

  void _openFilterModal() async {
    final selectedFilters = await showDialog<Set<String>>(
      context: context,
      builder: (context) => const FilterCategoryModal(),
    );

    if (selectedFilters != null) {
      setState(() {
        selectedCategories = selectedFilters;
        logger.i(selectedCategories);
      });
      _saveFilters();
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
    List<Map<String, dynamic>> filteredQuestions = questions
        .cast<
            Map<String, dynamic>>() // Ensure it's a List<Map<String, dynamic>>
        .where((q) =>
            selectedCategories.isEmpty ||
            selectedCategories.contains(q["category"])) // Category filter
        .where((q) {
      // ✅ Answered (Has user answers)
      bool hasUserAnswer = (q["answers"] as List<dynamic>?)
              ?.any((answer) => answer["isWho"] == "user") ??
          false;

      // ✅ Unanswered (No user answers)
      bool isUnanswered = !hasUserAnswer;

      // ✅ Resolved (Has solved_state "Solved")
      bool isResolved = q["solved_state"] == "Solved" ||
          (q["answers"] as List<dynamic>?)!
              .any((answer) => answer["solved_state"] == "Solved");

      // ✅ Unresolved (Does not have "Solved" state)
      bool isUnresolved = !isResolved;

      // ✅ Apply filters
      if (selectedFilters.contains("Answered") && !hasUserAnswer) return false;
      if (selectedFilters.contains("Unanswered") && !isUnanswered) return false;
      if (selectedFilters.contains("Resolved") && !isResolved) return false;
      if (selectedFilters.contains("Unresolved") && !isUnresolved) return false;

      return true; // Pass through
    }).toList();
    // ignore: deprecated_member_use
    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        if (event.delta.dy > 10) {
          // Detect downward movement
          FocusManager.instance.primaryFocus?.unfocus(); // Dismiss keyboard
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Detect taps outside text fields
        onTap: () {
          FocusManager.instance.primaryFocus
              ?.unfocus(); // Tap anywhere to dismiss
        },
        // ignore: deprecated_member_use
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: kColorWhite,
              resizeToAvoidBottomInset: false,
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
              body: SafeArea(
                child: SizedBox.expand(
                    child: SingleChildScrollView(
                  child: FocusScope(
                    child: Container(
                      decoration: const BoxDecoration(color: kColorWhite),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const HeaderWidget(
                              role: true,
                              isLogoutBtn: false,
                              backIcon: false,
                            ),
                            Padding(
                                padding: EdgeInsets.all(vMin(context, 4)),
                                child: SizedBox(
                                    width: vww(context, 100),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        userImageUrl == null ||
                                                userImageUrl!.isEmpty
                                            ? Image.asset(
                                                "assets/images/icons/smile.png", // **Show Fallback Icon Immediately If URL is Null/Empty**
                                                width: vhh(context, 7),
                                                height: vhh(context, 7),
                                                fit: BoxFit.contain,
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    50), // **Make It Circular**
                                                child: Image.network(
                                                  userImageUrl!,
                                                  width: vhh(context, 7),
                                                  height: vhh(context, 7),
                                                  fit: BoxFit
                                                      .cover, // **Ensure Proper Fit**
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child; // **Show Image Once Loaded**
                                                    }
                                                    return SizedBox(
                                                      width: vhh(context, 7),
                                                      height: vhh(context, 7),
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      "assets/images/icons/smile.png", // **Show Fallback Image If Error Occurs**
                                                      width: vhh(context, 7),
                                                      height: vhh(context, 7),
                                                      fit: BoxFit.contain,
                                                    );
                                                  },
                                                ),
                                              ),
                                        SizedBox(width: vMin(context, 3)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    welcomeBack.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Onset',
                                                      color: kColorSecondary,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: vMin(context, 1)),
                                                  Text(
                                                    userName ?? " ",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Onset',
                                                      color: kColorPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                findAnswer.toString(),
                                                textAlign: TextAlign.left,
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Onset-Regular',
                                                  color: kColorSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: vMin(context, 4),
                                  right: vMin(context, 4),
                                  top: vMin(context, 2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    trendingQuestions.toString(),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Onset-Regular',
                                      color: kColorSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                      onTap: _openFilterModal,
                                      child: Image.asset(
                                        'assets/images/icons/filter.png',
                                        fit: BoxFit.cover,
                                      )),
                                  SizedBox(
                                    width: vw(context, 1),
                                  ),
                                  TextButton.icon(
                                    onPressed: _resetFilters,
                                    label: const Text(
                                      "Reset",
                                      style: TextStyle(
                                        color: kColorPrimary,
                                        fontSize: 14, // Adjust text size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 1),
                                      minimumSize:
                                          const Size(60, 30), // Custom padding
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            6), // Rounded corners
                                        side: const BorderSide(
                                            color:
                                                kColorPrimary), // Border color
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            FilterBarWidget(
                              selectedFilters: selectedFilters,
                              onFilterSelected: (Set<String> filters) {
                                setState(() {
                                  selectedFilters = filters;
                                });
                                _saveFilters();
                              },
                            ),

                            // ✅ Display Selected Categories as Chips
                            if (selectedCategories.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: vMin(context, 4),
                                  vertical: vMin(context, 1),
                                ),
                                child: Align(
                                  alignment: Alignment
                                      .centerLeft, // ✅ Ensures chips start from the left
                                  child: Wrap(
                                    alignment: WrapAlignment
                                        .start, // ✅ Makes sure the first chip starts from the left
                                    spacing:
                                        6.0, // Horizontal spacing between items
                                    runSpacing:
                                        6.0, // Vertical spacing between rows
                                    children:
                                        selectedCategories.map((category) {
                                      return Container(
                                        height: 35,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  kColorPrimary), // Match the border color
                                          borderRadius: BorderRadius.circular(
                                              6), // Rounded edges
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize
                                              .min, // Keeps row compact
                                          children: [
                                            Text(
                                              category,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .black, // Match text color
                                              ),
                                            ),
                                            const SizedBox(
                                                width:
                                                    6), // Space between text and icon
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCategories
                                                      .remove(category);
                                                });
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color:
                                                    kColorPrimary, // Match icon color
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),

                            // Questions List
                            Padding(
                              padding: EdgeInsets.only(
                                left: vMin(context, 4),
                                right: vMin(context, 4),
                                top: vMin(context, 2),
                              ),
                              child: Column(
                                children: [
                                  _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : questions.isNotEmpty
                                          ? HomeDataWidget(
                                              questions: filteredQuestions,
                                              fromPage: "Home",
                                            )
                                          : const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                  "No questions.",
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
                          ]),
                    ),
                  ),
                )),
              ),
              bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex),
            )),
      ),
    );
  }
}
