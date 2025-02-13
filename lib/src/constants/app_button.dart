import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonWidgetType {
  googleLogin,
  facebookLogin,
  nextBtn,
  backBtn,
  seeAllAnsersBtn,
  askQuestionBtn,
  downloadPdfBtn,
  regenerateAnswerBtn,
  sendAnswerBtn,
  tipBtn,
  tipToolBtn,
  askQuestionsBtn,
  getStartedBtn,
  continueBtn,
  selectAllBtn,
  filterBtn,
  disSelectAllBtn,
  emailLogin,
  editProfile,
  settingBtn,
  termsBtn,
  updateBtn,
  addBtn
}

class ButtonWidget extends StatefulWidget {
  final ButtonWidgetType btnType;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final Color? fullColor;
  final bool? icon;
  final bool? size;

  const ButtonWidget({
    super.key,
    required this.btnType,
    required this.onPressed,
    required this.borderColor,
    required this.textColor,
    required this.fullColor,
    required this.icon,
    required this.size,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    String btnTitle;
    Widget? iconWidget;
    Widget? arrowIconWidget;

    switch (widget.btnType) {
      case ButtonWidgetType.emailLogin:
        btnTitle = "Sign up using an app";
        if (widget.icon == true) {
          iconWidget = Icon(
            Icons.mail, // System-provided email icon
            size: vMin(context, 3.5), // Adjust size based on your layout
            color: kColorInputBorder, // Customize color if needed
          );
        }
        break;
      case ButtonWidgetType.googleLogin:
        btnTitle = googleLogin.toString();
        if (widget.icon == true) {
          iconWidget = Image.asset(
            'assets/images/icons/google.png',
            width: vMin(context, 5),
            height: vMin(context, 20),
          );
        }
        break;
      case ButtonWidgetType.facebookLogin:
        btnTitle = facebookLogin.toString();
        if (widget.icon == true) {
          iconWidget = Image.asset(
            'assets/images/icons/facebook.png',
            width: vMin(context, 5),
            height: vMin(context, 20),
          );
        }
        break;
      case ButtonWidgetType.updateBtn:
        btnTitle = updateBtn.toString();
        break;
      case ButtonWidgetType.addBtn:
        btnTitle = addBtn.toString();
        break;
      case ButtonWidgetType.nextBtn:
        btnTitle = nextBtn.toString();
        break;
      case ButtonWidgetType.editProfile:
        btnTitle = editprofileBtn.toString();
        break;
      case ButtonWidgetType.settingBtn:
        btnTitle = settingBtn.toString();
        break;
      case ButtonWidgetType.termsBtn:
        btnTitle = termsBtn.toString();
        break;
      case ButtonWidgetType.backBtn:
        btnTitle = backBtn.toString();
        break;
      case ButtonWidgetType.seeAllAnsersBtn:
        btnTitle = seeAllAnsersBtn.toString();
        if (widget.icon == true) {
          arrowIconWidget = Image.asset(
            'assets/images/icons/arrow-right.png',
            width: vMin(context, 5),
            height: vMin(context, 20),
          );
        }
        break;
      case ButtonWidgetType.askQuestionBtn:
        btnTitle = askQuestion.toString();
        if (widget.icon == true) {
          iconWidget = Image.asset(
            'assets/images/icons/solar-add.png',
            width: vMin(context, 5),
            height: vMin(context, 20),
          );
        }
        break;
      case ButtonWidgetType.downloadPdfBtn:
        btnTitle = downloadPdf.toString();
        if (widget.icon == true) {
          arrowIconWidget = Image.asset(
            'assets/images/icons/download.png',
            width: vMin(context, 5),
            height: vMin(context, 20),
          );
        }
        break;
      case ButtonWidgetType.regenerateAnswerBtn:
        btnTitle = regenerateAnswer.toString();
        if (widget.icon == true) {
          arrowIconWidget = Image.asset(
            'assets/images/icons/refresh.png',
            width: vMin(context, 5),
            height: vMin(context, 20),
          );
        }
        break;
      case ButtonWidgetType.sendAnswerBtn:
        btnTitle = sendAnswer.toString();
        break;
      case ButtonWidgetType.tipBtn:
        btnTitle = tip.toString();
        if (widget.icon == true) {
          iconWidget = Image.asset(
            'assets/images/icons/people-money.png',
            width: vMin(context, 5),
            height: vMin(context, 20),
          );
        }
        break;
      case ButtonWidgetType.tipToolBtn:
        btnTitle = tip.toString();
        break;
      case ButtonWidgetType.askQuestionsBtn:
        btnTitle = askQuestions.toString();
        break;
      case ButtonWidgetType.getStartedBtn:
        btnTitle = getStarted.toString();
        break;
      case ButtonWidgetType.continueBtn:
        btnTitle = continueTitle.toString();
        break;
      case ButtonWidgetType.selectAllBtn:
        btnTitle = selectAll.toString();
        break;
      case ButtonWidgetType.filterBtn:
        btnTitle = filter.toString();
        break;
      case ButtonWidgetType.disSelectAllBtn:
        btnTitle = disSelectAll.toString();
        break;
      // default:
      //   btnTitle = "unknown";
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: SizedBox(
            width: vw(context, 100),
            height: vh(context, 5),
            child: Container(
              decoration: BoxDecoration(
                color: widget.fullColor,
                border: Border.all(color: widget.borderColor!),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0XFF000000),
              textStyle: TextStyle(
                fontFamily: 'Onset-Regular',
                fontWeight: FontWeight.w500,
                fontSize: widget.size == true ? 30.sp : 40.sp,
              ),
            ),
            onPressed: widget.onPressed,
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconWidget != null) ...[
                    iconWidget,
                    SizedBox(width: vMin(context, 1)),
                  ],
                  Flexible(
                    // Prevents text overflow
                    child: Text(
                      btnTitle,
                      overflow: TextOverflow.ellipsis, // Avoids breaking UI
                      style: TextStyle(
                        color: widget.textColor!,
                        fontFamily: 'Onset-Regular',
                      ),
                    ),
                  ),
                  if (arrowIconWidget != null) ...[
                    SizedBox(width: vMin(context, 1)),
                    arrowIconWidget,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
