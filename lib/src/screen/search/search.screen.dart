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
import 'package:laundromats/src/utils/index.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

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
  String? selectedFilter; // New filter selection
  final logger = Logger();
  bool isLoading = true;
  Set<String> selectedFilters = {};
  @override
  void initState() {
    super.initState();
    _loadFilters();
    getData();
  }

  void _saveFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'search_selectedCategories', selectedCategories.toList());
    await prefs.setStringList(
        'search_selectedFilters', selectedFilters.toList());
  }

  Future<void> _loadFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategories =
          (prefs.getStringList('search_selectedCategories') ?? []).toSet();
      selectedFilters =
          (prefs.getStringList('search_selectedFilters') ?? []).toSet();
    });
  }

  void _resetFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_selectedCategories');
    await prefs.remove('search_selectedFilters');
    setState(() {
      selectedCategories.clear();
      selectedFilters.clear();
    });
  }

  Future<void> getData() async {
    final authService = AuthService();
    try {
      final fetchedQuestions = await authService.fetchQuestionsWithAnswers();
      final validQuestions =
          fetchedQuestions.whereType<Map<String, dynamic>>().toList();

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
      questions = [];
      isLoading = true;
    });

    try {
      final authService = AuthService();
      final searchQuery = _searchValue.text.trim();
      final List<String> categories = selectedCategories.toList();

      final response =
          await authService.searchQuestionsAll(searchQuery, categories);

      setState(() {
        questions = response;
        isLoading = false;
      });
    } catch (e) {
      logger.e('Error searching questions: $e');
      setState(() {
        isLoading = false;
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
        selectedCategories = selectedFilters;
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

    // ✅ Apply Filters to Questions List
    List<Map<String, dynamic>> filteredQuestions = questions
        .cast<Map<String, dynamic>>()
        .where((q) =>
            selectedCategories.isEmpty ||
            selectedCategories.contains(q["category"]))
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

    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        if (event.delta.dy > 10) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            backgroundColor: kColorWhite,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: AppBar(
                backgroundColor: kColorWhite,
                elevation: 0,
                automaticallyImplyLeading: false,
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
                            role: true, isLogoutBtn: false, backIcon: false),

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

                        // ✅ Search Bar
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: vMin(context, 4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: vw(context, 33),
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
                              const Spacer(),
                              InkWell(
                                  onTap: _openFilterModal,
                                  child: Image.asset(
                                    'assets/images/icons/filter.png',
                                    fit: BoxFit.cover,
                                  )),
                              IconButton(
                                onPressed: _resetFilters,
                                icon: const Icon(
                                  Icons.refresh, // System Reset Icon
                                  color: kColorPrimary,
                                  size: 28,
                                ),
                                tooltip: "Reset Filters", // Tooltip on hover
                              ),
                            ],
                          ),
                        ),

                        // ✅ Filter Bar (Answered, Unanswered, Resolved, Unresolved)
                        FilterBarWidget(
                          selectedFilters: selectedFilters,
                          onFilterSelected: (Set<String> filters) {
                            setState(() {
                              selectedFilters = filters;
                            });
                            _saveFilters();
                          },
                        ),

                        // ✅ Category Filter Chips
                        if (selectedCategories.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: vMin(context, 4)),
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: selectedCategories.map((category) {
                                return Chip(
                                  label: Text(category,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: kColorSecondary)),
                                  backgroundColor: kColorWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side:
                                        const BorderSide(color: kColorPrimary),
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

                        // ✅ Questions List
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: vMin(context, 4)),
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : filteredQuestions.isNotEmpty
                                  ? HomeDataWidget(
                                      questions: filteredQuestions,
                                      fromPage: "Search",
                                    )
                                  : const Center(
                                      child: Text("No questions found.",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: kColorSecondary))),
                        ),
                      ]),
                ),
              ),
            )),
            bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex)),
      ),
    );
  }
}
