import 'package:flutter/material.dart';
import 'package:laundromats/src/components/primium_modal.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';

class ManuallyScreen extends StatelessWidget {
  const ManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(vMin(context, 4)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(vMin(context, 4)),
              decoration: BoxDecoration(
                color: kColorWhite,
                border: Border.all(color: kColorPrimary),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    free.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Onset-Regular',
                      color: kColorSecondary,
                    ),
                  ),

                  SizedBox(height: vMin(context, 1)),

                  const Text(
                    '\$0',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Onset-Regular',
                      color: kColorSecondary,
                    ),
                  ),

                  SizedBox(height: vMin(context, 0.5)),

                  Text(
                    subscriptionCardDetail.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Onset-Regular',
                      color: kColorSecondary,
                    ),
                  ),
                  SizedBox(height: vMin(context, 4)),

                  // Features
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check,
                                color: kColorPrimary, size: 20),
                            SizedBox(width: vMin(context, 3)),
                            Text(
                              mockDataTitle.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Onset-Regular',
                                color: kColorSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: vMin(context, 4)),

                  // Button
                  SizedBox(
                    width: vMin(context, 100),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // No background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              color: kColorPrimary), // Green border
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          color: kColorPrimary, // Green text color
                          fontSize: 15,
                          fontFamily: 'Onset-Regular',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: vMin(context, 4),
            ),
            Container(
              padding: EdgeInsets.all(vMin(context, 4)),
              decoration: BoxDecoration(
                color: kColorWhite,
                border: Border.all(color: kColorPrimary),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    basic.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Onset-Regular',
                      color: kColorSecondary,
                    ),
                  ),

                  SizedBox(height: vMin(context, 1)),

                  Row(
                    children: [
                      const Text(
                        '\$10',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Onset-Regular',
                          color: kColorSecondary,
                        ),
                      ),
                      SizedBox(
                        width: vMin(context, 2),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: kColorInputBorder,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          '-15%',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Onset-Regular',
                            color: kColorSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: vMin(context, 0.5)),

                  Text(
                    subscriptionCardDetail.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Onset-Regular',
                      color: kColorSecondary,
                    ),
                  ),
                  SizedBox(height: vMin(context, 4)),

                  // Features
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check,
                                color: kColorPrimary, size: 20),
                            SizedBox(width: vMin(context, 3)),
                            Text(
                              mockDataTitle.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Onset-Regular',
                                color: kColorSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: vMin(context, 4)),

                  // Button
                  SizedBox(
                    width: vMin(context, 100),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // No background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              color: kColorPrimary), // Green border
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          color: kColorPrimary, // Green text color
                          fontSize: 15,
                          fontFamily: 'Onset-Regular',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: vMin(context, 4),
            ),
            Container(
              padding: EdgeInsets.all(vMin(context, 4)),
              decoration: BoxDecoration(
                color: kColorPrimary,
                border: Border.all(color: kColorPrimary),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    pro.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Onset-Regular',
                      color: kColorWhite,
                    ),
                  ),

                  SizedBox(height: vMin(context, 1)),

                  Row(
                    children: [
                      const Text(
                        '\$15',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Onset-Regular',
                          color: kColorWhite,
                        ),
                      ),
                      SizedBox(
                        width: vMin(context, 2),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: kColorInputBorder,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          '-15%',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Onset-Regular',
                            color: kColorSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: vMin(context, 0.5)),

                  Text(
                    subscriptionCardDetail.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Onset-Regular',
                      color: kColorWhite,
                    ),
                  ),
                  SizedBox(height: vMin(context, 4)),

                  // Features
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check,
                                color: kColorWhite, size: 20),
                            SizedBox(width: vMin(context, 3)),
                            Text(
                              mockDataTitle.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Onset-Regular',
                                color: kColorWhite,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: vMin(context, 4)),

                  // Button
                  SizedBox(
                    width: vMin(context, 100),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kColorWhite, // Green background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 20), // Adjust padding
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const PrimiumModal(),
                        );
                      },
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          color: kColorPrimary, // Text color
                          fontSize: 15,
                          fontFamily: 'Onset-Regular',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
