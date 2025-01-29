import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';

class TipModal extends StatelessWidget {
  final Function(double) onTipSubmit;

  const TipModal({super.key, required this.onTipSubmit});

  @override
  Widget build(BuildContext context) {
    final TextEditingController tipController = TextEditingController();

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: vMin(context, 95),
          decoration: BoxDecoration(
            color: kColorWhite,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: vMin(context, 4)),
                  Image.asset("assets/images/icons/people-money-1.png"),
                  SizedBox(height: vMin(context, 4)),
                  Text(
                    showAppreciation.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Onset',
                      color:kColorSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: vMin(context, 2)),
                  Text(
                    giveThemTip.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Onset-Regular',
                      color:kColorSecondary,
                    ),
                  ),
                  SizedBox(height: vMin(context, 2)),
                  SizedBox(
                    width: vw(context, 40),
                    height: vh(context, 5),
                    child: TextField(
                      controller: tipController,
                      keyboardType: TextInputType.name,
                      autocorrect: false,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        floatingLabelBehavior:  FloatingLabelBehavior.always,
                        enabledBorder: kEnableBorder,
                        focusedBorder: kFocusBorder,
                        hintText: howMuchTip.toString(),
                        hintStyle: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Onset-Regular',
                            color: kColorLightGrey),
                        filled: false,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15),
                        suffixIcon: Image.asset("assets/images/icons/money.png"), 
                        counterText: '',
                      ),
                    ),
                  ),
                  SizedBox(height: vMin(context, 6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: vMin(context, 20),
                        child: ButtonWidget(
                          btnType: ButtonWidgetType.tipToolBtn,
                          borderColor: kColorPrimary,
                          textColor: kColorWhite,
                          fullColor: kColorPrimary,
                          size: false,
                          icon: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
      )
    );
  }
}