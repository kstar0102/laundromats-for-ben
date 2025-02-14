import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/login_step/category.screen.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:logger/logger.dart';

class SetPasswordScreen extends ConsumerStatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final Logger logger = Logger();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  void _onSetPasswordClicked() {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields");
    } else if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Passwords do not match");
    } else {
      // logger.i("Setting new password: ${_passwordController.text}");
      GlobalVariable.userPassword = _passwordController.text;
      final navigator = Navigator.of(context);
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const CategoryScreen(),
        ),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const HeaderWidget(
                role: true,
                isLogoutBtn: false,
                backIcon: true,
              ),
              SizedBox(height: vh(context, 10)),
              const Text(
                "Set New Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Onset',
                  fontWeight: FontWeight.bold,
                  color: kColorSecondary,
                ),
              ),
              SizedBox(height: vh(context, 8)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  "New Password",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Onset-bold',
                      color: kColorBlack),
                ),
                SizedBox(height: vh(context, 1)),
                SizedBox(
                  width: vw(context, 40),
                  height: vh(context, 6),
                  child: TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: "Enter new password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                      enabledBorder: kEnableSearchBorder,
                      focusedBorder: kFocusSearchBorder,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: vh(context, 3)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  "Confirm Password",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Onset-bold',
                      color: kColorBlack),
                ),
                SizedBox(height: vh(context, 1)),
                SizedBox(
                  width: vw(context, 40),
                  height: vh(context, 6),
                  child: TextField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isConfirmPasswordHidden,
                    decoration: InputDecoration(
                      hintText: "Confirm new password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordHidden =
                                !_isConfirmPasswordHidden;
                          });
                        },
                      ),
                      enabledBorder: kEnableSearchBorder,
                      focusedBorder: kFocusSearchBorder,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: vMin(context, 12)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: vww(context, 15)),
                child: Column(
                  children: [
                    ButtonWidget(
                      btnType: ButtonWidgetType.nextBtn,
                      borderColor: kColorPrimary,
                      textColor: kColorWhite,
                      fullColor: kColorPrimary,
                      size: false,
                      icon: true,
                      onPressed: _onSetPasswordClicked,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
