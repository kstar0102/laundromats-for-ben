import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';

class PrimiumModal extends StatelessWidget {
  const PrimiumModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: vMin(context, 95),
          decoration: BoxDecoration(
              color: kColorWhite, borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: vMin(context, 4)),
                    Image.asset("assets/images/icons/crown-2.png"),
                    SizedBox(height: vMin(context, 4)),
                    Text(
                      goPrimium.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Onset',
                        color: kColorSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: vMin(context, 2)),
                    Center(
                      child: Text(
                        goPrimiumDescription.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Onset-Regular',
                          color: kColorSecondary,
                        ),
                      ),
                    ),
                    SizedBox(height: vMin(context, 6)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: vMin(context, 25),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  kColorPrimary, // Green background color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 20), // Adjust padding
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 15,
                                fontFamily: 'Onset-Regular',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Image.asset("assets/images/icons/solar-close.png"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
