import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/components/filter.category.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/ask_question/ask_question.screen.dart';
import 'package:laundromats/src/screen/questions/partials/questions_data.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key,});

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final int _currentIndex = 3;
  final bool _isKeyboardVisible = false;
  final _searchValue = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kColorWhite,
        resizeToAvoidBottomInset: true,
        body: SizedBox.expand(
          child: SingleChildScrollView(
            child: FocusScope(
              child: Container(
                decoration: const BoxDecoration(
                  color: kColorWhite
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const HeaderWidget(role: true),

                    Padding(padding: EdgeInsets.all(vMin(context, 4)),
                      child: SizedBox(
                        width: vww(context, 100),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              myQuestions.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
                                      pageBuilder: (context, animation1, animation2) => const AskQuestionScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      )
                    ),

                    Padding(padding: EdgeInsets.only(left: vMin(context, 4), right: vMin(context, 4), top: vMin(context, 2)),
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

                    Padding(padding: EdgeInsets.only(left: vMin(context, 4), right: vMin(context, 4), top: vMin(context, 2)),
                      child: const Text(
                        "9 $questions",
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Onset-Regular',
                          color: kColorThird,
                        ),
                      ),
                    ),


                    Padding(padding: EdgeInsets.only(left: vMin(context, 4), right: vMin(context, 4), top: vMin(context, 2)),
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
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                hintText: search.toString(),
                                floatingLabelBehavior:  FloatingLabelBehavior.always,
                                enabledBorder: kEnableSearchBorder,
                                focusedBorder: kFocusSearchBorder,
                                hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Onset-Regular',
                                    color: kColorLightGrey),
                                filled: false,
                                disabledBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                counterText: '',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => const FilterCategoryModal(),
                              );
                            },
                            child: Image.asset('assets/images/icons/filter.png', fit: BoxFit.cover,)
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        left: vMin(context, 4),
                        right: vMin(context, 4),
                        top: vMin(context, 2),
                      ),
                      child: const Column(
                        children: [
                          QuestionsDataWidget(),
                          QuestionsDataWidget(),
                        ],
                      ) 
                    ),

                  ]
                ),
              ),
            ),
          )
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex)
      ),
    );
  }
}
