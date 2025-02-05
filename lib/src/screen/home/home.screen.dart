import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/home/partials/home_data.widget.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
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
  List<dynamic> questions = [];
  bool _isLoading = false;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool allowRevert = true;

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "Guest"; // Fallback to "Guest"
    });

    final authService = AuthService();
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const HeaderWidget(role: true, isLogoutBtn: false),
                      Padding(
                          padding: EdgeInsets.all(vMin(context, 4)),
                          child: SizedBox(
                              width: vww(context, 100),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/icons/smile.png",
                                    width: vhh(context, 7),
                                    height: vhh(context, 7),
                                    fit: BoxFit.contain,
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
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Onset',
                                                color: kColorSecondary,
                                              ),
                                            ),
                                            SizedBox(width: vMin(context, 1)),
                                            Text(
                                              userName ?? "Guest",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            InkWell(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/icons/filter.png',
                                  fit: BoxFit.cover,
                                ))
                          ],
                        ),
                      ),
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
                                        questions: questions
                                            .cast<Map<String, dynamic>>(),
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
          bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex)),
    );
  }
}
