import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/components/filter.category.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/home/partials/home_data.widget.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:logger/logger.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final int _currentIndex = 1;
  final bool _isKeyboardVisible = false;
  final _searchValue = TextEditingController();
  List<dynamic> questions = [];
  Set<String> selectedCategories = {};
  final logger = Logger();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    final authService = AuthService();
    try {
      final fetchedQuestions = await authService.fetchQuestionsWithAnswers();
      final validQuestions = fetchedQuestions
          .whereType<Map<String, dynamic>>() // Filters out non-map elements
          .toList();

      setState(() {
        questions = validQuestions;
        isLoading = false;
      });
    } catch (e) {
      logger.i('Error fetching questions: $e');
    }
  }

  Future<void> searchQuestions() async {
    setState(() {
      questions = []; // Clear the list while searching
      isLoading = true; // Show loading indicator
    });

    try {
      final authService = AuthService();
      final searchQuery = _searchValue.text.trim();
      final List<String> categories = selectedCategories.toList();

      final response = await authService.searchQuestionsAll(
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
                      Padding(
                          padding: EdgeInsets.all(vMin(context, 4)),
                          child: SizedBox(
                              width: vww(context, 100),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    searchQuestion.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Onset',
                                      color: kColorSecondary,
                                    ),
                                  ),
                                ],
                              ))),
                      Padding(
                        padding: EdgeInsets.only(
                            left: vMin(context, 4),
                            right: vMin(context, 4),
                            top: vMin(context, 0)),
                        child: Text(
                          exploreQuestionCategory.toString(),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                                  getData();
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

                      //tag list
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
                      //question list
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
                                    : Padding(
                                        padding: EdgeInsets.only(
                                          left: vMin(context, 4),
                                          right: vMin(context, 4),
                                          top: vMin(context, 2),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: vMin(context, 35),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                  "assets/images/icons/search-2.png"),
                                            ),
                                            SizedBox(
                                              height: vMin(context, 5),
                                            ),
                                            const Text(
                                              "No questions found.",
                                              textAlign: TextAlign.left,
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Onset-Regular',
                                                color: kColorSecondary,
                                              ),
                                            ),
                                          ],
                                        )),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          )),
          bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex)),
    );
  }
}
