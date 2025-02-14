import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/common/profile_status.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
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
  int? askedCount;
  int? commentCount;
  int? likeCount;
  int? dislikeCount;
  String? selectedFilter; // Tracks active filter
  List<dynamic> filteredQuestions = []; // Stores filtered questions

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    getUserQuestions();
  }

  /// Fetch user questions and apply the filter
  Future<void> getUserQuestions() async {
    setState(() {
      isLoading = true; // Show loading
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
            final fetchedQuestions =
                await authService.fetchUserQuestionsWithAnswers(userId!);

            setState(() {
              questions = fetchedQuestions;
              askedCount = questions.length;
              commentCount = questions.fold<int>(0, (sum, question) {
                final answers = question['answers'] as List<dynamic>?;
                return sum + (answers?.length ?? 0);
              });

              likeCount = questions.fold<int>(0, (sum, question) {
                return sum +
                    (int.tryParse(question['likes_count']?.toString() ?? '0') ??
                        0);
              });

              dislikeCount = questions.fold<int>(0, (sum, question) {
                return sum +
                    (int.tryParse(
                            question['dislikes_count']?.toString() ?? '0') ??
                        0);
              });

              isLoading = false;
              applyFilter(); // Apply filter after fetching data
            });
          }
        } catch (e) {
          logger.e('Error fetching user questions: $e');
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  /// Search questions with applied filters
  Future<void> searchQuestions() async {
    if (userId == null) return;

    setState(() {
      isLoading = true; // Show loading
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
        isLoading = false;
        applyFilter(); // Apply filter after searching
      });
    } catch (e) {
      logger.e('Error searching questions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Apply filters when a user selects a tab
  void applyFilter() {
    setState(() {
      List<Map<String, dynamic>> tempFilteredQuestions = questions
          .cast<Map<String, dynamic>>() // Ensure correct type
          .where((q) =>
              selectedCategories.isEmpty || // Show all if no category selected
              selectedCategories.contains(q["category"]))
          .toList(); // Convert back to a list

      // Apply tab-based filters
      if (selectedFilter == 'commented') {
        tempFilteredQuestions = tempFilteredQuestions
            .where((q) => q['answers'] != null && q['answers'].isNotEmpty)
            .toList();
      } else if (selectedFilter == 'liked') {
        tempFilteredQuestions = tempFilteredQuestions
            .where((q) => (q['likes_count'] ?? 0) > 0)
            .toList();
      } else if (selectedFilter == 'disliked') {
        tempFilteredQuestions = tempFilteredQuestions
            .where((q) => (q['dislikes_count'] ?? 0) > 0)
            .toList();
      }

      filteredQuestions = tempFilteredQuestions;
    });
  }

  /// Handles filter selection
  void onFilterSelected(String? filterKey) {
    setState(() {
      if (selectedFilter == filterKey) {
        selectedFilter = null;
      } else {
        selectedFilter = filterKey;
      }
      applyFilter();
    });
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
      applyFilter();
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
        body: SizedBox.expand(
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

                    // Header Section
                    Padding(
                      padding: EdgeInsets.only(
                          top: vh(context, 3),
                          left: vw(context, 2),
                          right: vw(context, 2)),
                      child: SizedBox(
                        width: vww(context, 100),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "My Questions",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Onset',
                                color: kColorSecondary,
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
                                    const EdgeInsets.symmetric(horizontal: 5),
                                counterText: '',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: kColorLightGrey,
                                  size: 20,
                                ),
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

                    ProfileStatusWidget(
                      askedCount: askedCount ?? 0,
                      commentCount: commentCount ?? 0,
                      likeCount: likeCount ?? 0,
                      dislikeCount: dislikeCount ?? 0,
                      selectedFilter: selectedFilter,
                      onFilterSelected: onFilterSelected,
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
                    // Question List
                    Padding(
                      padding: EdgeInsets.only(
                          left: vMin(context, 4),
                          right: vMin(context, 4),
                          top: vMin(context, 2)),
                      child: isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                    color: kColorPrimary), // Loader
                              ),
                            )
                          : filteredQuestions.isNotEmpty
                              ? HomeDataWidget(
                                  questions: filteredQuestions
                                      .cast<Map<String, dynamic>>())
                              : const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("No questions found.",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kColorSecondary)),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AskQuestionScreen()),
            );
          },
          backgroundColor: kColorPrimary,
          shape: const CircleBorder(), // Ensures Circular Shape
          child: const Icon(
            Icons.edit_document, // Edit Icon Similar to Image
            color: Colors.white, // White Color for Icon
            size: 26, // Slightly Larger for Visibility
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // ✅ Bottom Right

        bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex),
      ),
    );
  }
}
