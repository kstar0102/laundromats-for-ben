import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/common/progress.widget.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/home/home.screen.dart';
import 'package:laundromats/src/screen/login_step/category.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:laundromats/src/utils/shared_preferences_util.dart';
import 'package:logger/logger.dart';
class OwnerScreen extends ConsumerStatefulWidget {
  const OwnerScreen({super.key});

  @override
  ConsumerState<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends ConsumerState<OwnerScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  int currentStep = 1;
  final bool _isKeyboardVisible = false;
  final _howLaundromatsValue = TextEditingController();
  final _businessValue = TextEditingController();
  final logger = Logger();

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

  void _onNextClicked() async {
    if (_businessValue.text.isEmpty || _howLaundromatsValue.text.isEmpty) {
      _showErrorDialog(
          "Please fill in all the required fields before proceeding.");
    } else {
      GlobalVariable.userbusinessTime = _businessValue.text;
      GlobalVariable.userLaundromatsCount = _howLaundromatsValue.text;

      AuthService authService = AuthService();

      final result = await authService.signup(
        name: GlobalVariable.userName ?? "",
        email: GlobalVariable.userEmail ?? "",
        password: GlobalVariable.userPassword ?? "",
        role: "Owner",
        roleExpertIn: " ",
        roleBusinessTime: GlobalVariable.userbusinessTime!,
        roleLaundromatsCount:
            GlobalVariable.userLaundromatsCount!, // Add relevant value
      );

      logger.i(result);

      if (result['success'] == true) {
        await SharedPreferencesUtil.saveUserDetails(
          userId: result['userId'].toString(),
          userName: GlobalVariable.userName!,
          userEmail: GlobalVariable.userEmail!,
          userExpertIn: " ",
          userBusinessTime: GlobalVariable.userbusinessTime!,
          userLaundromatsCount: GlobalVariable.userLaundromatsCount!,
        );

        if (mounted) {
          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const HomeScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      } else {
        _showErrorDialog(result['message']);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Missing Information"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _onBackClicked() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const CategoryScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
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
          resizeToAvoidBottomInset: true,
          body: SizedBox.expand(
              child: SingleChildScrollView(
            child: FocusScope(
              child: Container(
                decoration: const BoxDecoration(color: kColorWhite),
                height: vhh(context, 100),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const HeaderWidget(role: true, isLogoutBtn: false),
                      SizedBox(
                        height: vMin(context, 10),
                      ),
                      Text(
                        letGetStarted.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'Onset',
                            fontWeight: FontWeight.bold,
                            color: kColorSecondary),
                      ),
                      SizedBox(
                        height: vMin(context, 1),
                      ),
                      Text(
                        letGetStartedDescription.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Onset-Regular',
                            color: kColorSecondary),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 5)),
                        child: ProgressIndicatorWidget(
                          currentStep: currentStep,
                          activeColor: kColorPrimary,
                          inactiveColor: kColorSecondary.withOpacity(0.5),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(vMin(context, 5)),
                          child: Container(
                            padding: EdgeInsets.all(vMin(context, 5)),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: kColorPrimary, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: vMin(context, 5),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      howLaundromats.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Onset-Regular',
                                          color: kColorSecondary),
                                    ),
                                    SizedBox(
                                      height: vMin(context, 1),
                                    ),
                                    SizedBox(
                                      width: vw(context, 40),
                                      height: vh(context, 5),
                                      child: TextField(
                                        controller: _howLaundromatsValue,
                                        keyboardType: TextInputType.name,
                                        autocorrect: false,
                                        cursorColor: Colors.grey,
                                        decoration: const InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          enabledBorder: kEnableBorder,
                                          focusedBorder: kFocusBorder,
                                          hintStyle: TextStyle(
                                              fontSize: 10.0,
                                              color: kColorInputBorder),
                                          filled: false,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 10),
                                          counterText: '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: vMin(context, 2),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      businessName.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Onset-Regular',
                                          color: kColorSecondary),
                                    ),
                                    SizedBox(
                                      height: vMin(context, 1),
                                    ),
                                    SizedBox(
                                      width: vw(context, 40),
                                      height: vh(context, 5),
                                      child: TextField(
                                        controller: _businessValue,
                                        keyboardType: TextInputType.name,
                                        autocorrect: false,
                                        cursorColor: Colors.grey,
                                        decoration: const InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          enabledBorder: kEnableBorder,
                                          focusedBorder: kFocusBorder,
                                          hintStyle: TextStyle(
                                              fontSize: 10.0,
                                              color: kColorInputBorder),
                                          filled: false,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 10),
                                          counterText: '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: vMin(context, 8)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: vMin(context, 20),
                                      child: ButtonWidget(
                                        btnType: ButtonWidgetType.backBtn,
                                        borderColor: kColorPrimary,
                                        textColor: kColorWhite,
                                        fullColor: kColorPrimary,
                                        size: false,
                                        icon: true,
                                        onPressed: () {
                                          _onBackClicked();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: vMin(context, 20),
                                      child: ButtonWidget(
                                        btnType: ButtonWidgetType.nextBtn,
                                        borderColor: kColorPrimary,
                                        textColor: kColorWhite,
                                        fullColor: kColorPrimary,
                                        size: false,
                                        icon: true,
                                        onPressed: () {
                                          _onNextClicked();
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          )),
        ));
  }
}
