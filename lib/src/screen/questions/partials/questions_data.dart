import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/questions/details.screen.dart';
import 'package:laundromats/src/utils/index.dart';

class QuestionsDataWidget extends ConsumerStatefulWidget {
  const QuestionsDataWidget({super.key});

  @override
  ConsumerState<QuestionsDataWidget> createState() =>
      _QuestionsDataWidgetState();
}

class _QuestionsDataWidgetState extends ConsumerState<QuestionsDataWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: kColorQuestionBorder, width: 1),
          ),
          child: Card(
            elevation: 0,
            color: kColorWhite,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Drying Machines",
                        style: TextStyle(
                          fontFamily: 'Onset-Regular',
                          fontSize: 14,
                          color: kColorPrimary,
                        ),
                      ),
                      Text(
                        "3 days ago",
                        style: TextStyle(
                          fontFamily: 'Onset-Regular',
                          fontSize: 12,
                          color: kColorPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: vMin(context, 2)),
                  Row(
                    children: [
                      Image.asset('assets/images/icons/user.png'),
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
                  SizedBox(height: vMin(context, 3)),

                  const Text(
                    "I have a Speed Queen dryer double stack from 2017 that is making a scraping noise when I turn it on, it sounds like it's coming from the barrel.",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Onset-Normal',
                        fontWeight: FontWeight.bold,
                        color: kColorSecondary),
                  ),
                  SizedBox(height: vMin(context, 1)),

                  Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    alignment: WrapAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon:
                            Image.asset("assets/images/icons/solar-linear.png"),
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
                          minimumSize: const Size(0, 24),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon:
                            Image.asset("assets/images/icons/solar-linear.png"),
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
                  SizedBox(height: vMin(context, 2)),

                  // Response Section
                  Container(
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
                  SizedBox(height: vMin(context, 2)),

                  // Footer Section
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child:
                            Image.asset("assets/images/icons/chat-message.png"),
                      ),
                      SizedBox(width: vMin(context, 1)),
                      const Text(
                        "8",
                        style: TextStyle(
                          fontFamily: 'Onset-Regular',
                          fontSize: 12,
                          color: kColorSecondary,
                        ),
                      ),
                      SizedBox(width: vMin(context, 4)),
                      InkWell(
                        onTap: () {},
                        child: Image.asset("assets/images/icons/like.png"),
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
                        child: Image.asset("assets/images/icons/dislike.png"),
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
                        width: vMin(context, 40),
                        child: ButtonWidget(
                          btnType: ButtonWidgetType.seeAllAnsersBtn,
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
                                        const QuestionDetailScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
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
        SizedBox(
          height: vMin(context, 5),
        )
      ],
    );
  }
}
