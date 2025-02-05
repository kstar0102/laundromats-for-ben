import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/components/tip_modal.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';

class QuestionDetailScreen extends ConsumerStatefulWidget {
  const QuestionDetailScreen({
    super.key,
  });

  @override
  ConsumerState<QuestionDetailScreen> createState() =>
      _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends ConsumerState<QuestionDetailScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final int _currentIndex = 3;
  final bool _isKeyboardVisible = false;

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
                      Padding(
                          padding: EdgeInsets.only(
                              left: vMin(context, 4),
                              right: vMin(context, 4),
                              top: vMin(context, 4)),
                          child: SizedBox(
                            width: vww(context, 100),
                            child: const Text(
                              "I have a speed queen dryer double stack from 2017 that is making a scraping noise when it turn it on, it sounds like its coming from the barrel",
                              style: TextStyle(
                                fontFamily: 'Onset-Regular',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kColorSecondary,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            left: vMin(context, 4), right: vMin(context, 4)),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 0,
                          alignment: WrapAlignment.start,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                  "assets/images/icons/solar-linear.png"),
                              label: const Text(
                                "New",
                                style: TextStyle(
                                  color: kColorSecondary,
                                  fontFamily: 'Onset-Regular',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kColorPrimary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 3),
                                minimumSize: const Size(0, 16),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                  "assets/images/icons/solar-linear.png"),
                              label: const Text(
                                "Barrel",
                                style: TextStyle(
                                  fontFamily: 'Onset-Regular',
                                  color: kColorSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kColorPrimary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 3),
                                minimumSize: const Size(0, 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: vMin(context, 4), right: vMin(context, 4)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Section (Images)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Container(
                                          color: Colors.grey[300],
                                          width: 100,
                                          height: 50,
                                          child: Image.asset(
                                            'assets/images/background/intro.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    seeAllPictures.toString(),
                                    style: const TextStyle(
                                      color: kColorPrimary,
                                      fontFamily: 'Onset-Regular',
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: vMin(context, 2)),
                            // Right Section (Details)
                            Expanded(
                              child: Wrap(
                                spacing: 16.0,
                                runSpacing: 8.0,
                                children: [
                                  _buildInfoCard(
                                      "assets/images/icons/solar-tag.png",
                                      "Serial number",
                                      "17345678"),
                                  _buildInfoCard(
                                      "assets/images/icons/solar-tag.png",
                                      "Pounds",
                                      "175 lbs"),
                                  _buildInfoCard(
                                      "assets/images/icons/solar-box.png",
                                      "Brand",
                                      "Speed Queen"),
                                  _buildInfoCard(
                                      "assets/images/icons/solar-tag.png",
                                      "Year",
                                      "2017"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: vMin(context, 4),
                            right: vMin(context, 4),
                            top: vMin(context, 3)),
                        child: Container(
                          padding: EdgeInsets.all(vMin(context, 2)),
                          decoration: BoxDecoration(
                            border: Border.all(color: kColorPrimary, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/images/icons/gpt.png"),
                                  SizedBox(width: vMin(context, 2)),
                                  const Text(
                                    "LaundromatAI says",
                                    style: TextStyle(
                                      fontFamily: 'Onset-Regular',
                                      color: kColorSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: vMin(context, 2)),
                              const Text(
                                "It sounds like you're experiencing a common issue with your Speed Queen double stack dryer from 2017. A scraping noise could indicate a few potential problems, often related to the dryer barrel or internal components. Here are some steps to help you troubleshoot the issue:\n\n1. **Check for Foreign Objects**: First, ensure that there are no foreign objects (like coins, buttons, or lint) lodged in the drum or around the door seal.\n\n2. **Inspect the Drum Rollers**: The drum rollers or glides may be worn out or damaged. Inspect them for wear and tear.",
                                style: TextStyle(
                                  fontFamily: 'Onset-Regular',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
                              top: vMin(context, 3)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: vMin(context, 45),
                                child: ButtonWidget(
                                  btnType: ButtonWidgetType.downloadPdfBtn,
                                  borderColor: kColorPrimary,
                                  textColor: kColorPrimary,
                                  fullColor: kColorWhite,
                                  icon: true,
                                  size: true,
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(
                                width: vMin(context, 45),
                                child: ButtonWidget(
                                  btnType: ButtonWidgetType.regenerateAnswerBtn,
                                  borderColor: kColorPrimary,
                                  textColor: kColorWhite,
                                  fullColor: kColorPrimary,
                                  icon: true,
                                  size: true,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with Icon and Text
                            Row(
                              children: [
                                Image.asset(
                                    "assets/images/icons/solar-pen.png"),
                                const SizedBox(width: 8.0),
                                Text(
                                  writeAnswer.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            TextField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: typeHere.toString(),
                                hintStyle: const TextStyle(
                                  color: kColorLightGrey,
                                  fontSize: 14,
                                  fontFamily: 'Onset-Regular',
                                ),
                                contentPadding: const EdgeInsets.all(12.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: kColorPrimary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: kColorPrimary, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: kColorPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: vMin(context, 4), right: vMin(context, 4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: vMin(context, 35),
                                child: ButtonWidget(
                                  btnType: ButtonWidgetType.sendAnswerBtn,
                                  borderColor: kColorPrimary,
                                  textColor: kColorWhite,
                                  fullColor: kColorPrimary,
                                  icon: true,
                                  size: false,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                    "assets/images/icons/checklist.png"),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(laundromatOwners.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Onset-Regular',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: kColorSecondary,
                                      ),
                                      overflow: TextOverflow.visible),
                                ),
                              ],
                            ),
                            SizedBox(height: vMin(context, 2)),
                            Container(
                              decoration: BoxDecoration(
                                color: kColorWhite,
                                borderRadius: BorderRadius.circular(5.0),
                                border:
                                    Border.all(color: kColorPrimary, width: 1),
                              ),
                              child: Card(
                                elevation: 0,
                                color: kColorWhite,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                  'assets/images/icons/user.png'),
                                              SizedBox(width: vMin(context, 2)),
                                              const Text(
                                                "Ben",
                                                style: TextStyle(
                                                  color: kColorSecondary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Text(
                                            "3 days ago",
                                            style: TextStyle(
                                              fontFamily: 'Onset-Regular',
                                              fontSize: 12,
                                              color: kColorPrimary,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: vMin(context, 3)),

                                      const Text(
                                        "I have a Speed Queen dryer double stack from 2017 that is making a scraping noise when I turn it on, it sounds like it's coming from the barrel.",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Onset-Regular',
                                            fontWeight: FontWeight.bold,
                                            color: kColorSecondary),
                                      ),
                                      SizedBox(height: vMin(context, 2)),

                                      // Footer Section
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Image.asset(
                                                "assets/images/icons/like.png"),
                                          ),
                                          SizedBox(width: vMin(context, 1)),
                                          const Text(
                                            "41",
                                            style: TextStyle(
                                              fontFamily: 'Onset-Regular',
                                              fontSize: 12,
                                              color: kColorSecondary,
                                            ),
                                          ),
                                          SizedBox(width: vMin(context, 4)),
                                          InkWell(
                                            onTap: () {},
                                            child: Image.asset(
                                                "assets/images/icons/dislike.png"),
                                          ),
                                          SizedBox(width: vMin(context, 1)),
                                          const Text(
                                            "2",
                                            style: TextStyle(
                                              fontFamily: 'Onset-Regular',
                                              fontSize: 12,
                                              color: kColorSecondary,
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: vMin(context, 20),
                                            child: ButtonWidget(
                                              btnType: ButtonWidgetType.tipBtn,
                                              borderColor: kColorPrimary,
                                              textColor: kColorPrimary,
                                              fullColor: kColorWhite,
                                              size: false,
                                              icon: true,
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      TipModal(
                                                          onTipSubmit:
                                                              (tipAmount) {}),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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

  Widget _buildInfoCard(String icon, String title, String value) {
    return Container(
      padding: EdgeInsets.only(
          top: vMin(context, 1),
          left: vMin(context, 2),
          right: vMin(context, 2),
          bottom: vMin(context, 1)),
      decoration: BoxDecoration(
        border: Border.all(color: kColorPrimary),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon),
          SizedBox(width: vMin(context, 3)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kColorPrimary,
                  fontFamily: 'Onset-Regular',
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Onset-Regular',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
