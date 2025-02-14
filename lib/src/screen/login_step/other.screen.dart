import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/common/progress.widget.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/home/home.screen.dart';
import 'package:laundromats/src/screen/login_step/category.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:laundromats/src/utils/shared_preferences_util.dart';

class OtherScreen extends ConsumerStatefulWidget {
  const OtherScreen({super.key});

  @override
  ConsumerState<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends ConsumerState<OtherScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  int currentStep = 1;
  final bool _isKeyboardVisible = false;
  final _experInValue = TextEditingController();
  final _businessValue = TextEditingController();
  final _howLaundromatsValue = TextEditingController();

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
    if (_experInValue.text.isEmpty ||
        _businessValue.text.isEmpty ||
        _howLaundromatsValue.text.isEmpty) {
      _showErrorDialog(
          "Please fill in all the required fields before proceeding.");
    } else {
      GlobalVariable.userExpertIn = _experInValue.text;
      GlobalVariable.userbusinessTime = _businessValue.text;
      GlobalVariable.userLaundromatsCount = _howLaundromatsValue.text;

      AuthService authService = AuthService();

      final result = await authService.signup(
        name: GlobalVariable.userName ?? "",
        email: GlobalVariable.userEmail ?? "",
        password: GlobalVariable.userPassword ?? "",
        role: "Other",
        roleExpertIn: GlobalVariable.userExpertIn!,
        roleBusinessTime: GlobalVariable.userbusinessTime!,
        roleLaundromatsCount: GlobalVariable.userLaundromatsCount!,
        userAddress: GlobalVariable.userAddress!,
        userPhoneNumber: GlobalVariable.userphoneNumber!,
      );

      if (result['success'] == true) {
        await SharedPreferencesUtil.saveUserDetails(
          userId: result['userId'].toString(),
          userName: GlobalVariable.userName!,
          userEmail: GlobalVariable.userEmail!,
          userExpertIn: GlobalVariable.userExpertIn!,
          userBusinessTime: GlobalVariable.userbusinessTime!,
          userLaundromatsCount: GlobalVariable.userLaundromatsCount!,
        );

        if (mounted) {
          // Navigate to HomeScreen

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoryScreen()),
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
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(0.0), // Adjust the height as needed
            child: AppBar(
              backgroundColor: kColorWhite,
              elevation: 0, // Removes shadow for a flat UI
              automaticallyImplyLeading:
                  false, // Hides back button if unnecessary
            ),
          ),
          body: SizedBox.expand(
              child: SingleChildScrollView(
            child: FocusScope(
              child: Container(
                decoration: const BoxDecoration(color: kColorWhite),
                height: vhh(context, 100),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const HeaderWidget(
                        role: true,
                        isLogoutBtn: false,
                        backIcon: true,
                      ),
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
                          // ignore: deprecated_member_use
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
                                      experIn.toString(),
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
                                        controller: _experInValue,
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
                                        keyboardType: TextInputType.number,
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
                                        keyboardType: TextInputType.number,
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
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              kColorPrimary, // Green background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8), // Rounded corners
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7,
                                              horizontal: 20), // Adjust padding
                                        ),
                                        onPressed: () {
                                          _onBackClicked();
                                        },
                                        child: const Text(
                                          "Back",
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontSize: 15,
                                            fontFamily: 'Onset-Regular',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: vMin(context, 20),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              kColorPrimary, // Green background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8), // Rounded corners
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7,
                                              horizontal: 20), // Adjust padding
                                        ),
                                        onPressed: () {
                                          _onNextClicked();
                                        },
                                        child: const Text(
                                          "Next",
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
                        ),
                      ),
                    ]),
              ),
            ),
          )),
        ));
  }
}
