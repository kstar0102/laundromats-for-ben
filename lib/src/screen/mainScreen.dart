import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/screen/ask_question/ask_question.screen.dart';
import 'package:laundromats/src/screen/home/home.screen.dart';
import 'package:laundromats/src/screen/profile/profile.screen.dart';
import 'package:laundromats/src/screen/questions/questions.screen.dart';
import 'package:laundromats/src/screen/search/search.screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomeScreen(),
          SearchScreen(),
          AskQuestionScreen(),
          QuestionScreen(),
          ProfileScreen(),
        ],
      ),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: _currentIndex,
      //   onTabTapped: onTabTapped,
      // ),
    );
  }
}
