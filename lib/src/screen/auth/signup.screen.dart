import 'package:flutter/material.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/screen/auth/login.screen.dart';
import 'package:laundromats/src/screen/login_step/category.screen.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:logger/logger.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/utils/index.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final Logger logger = Logger();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  /// **Email Validation Function**
  bool _validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void _onSignupClicked() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields");
      return;
    }

    if (!_validateEmail(_emailController.text.trim())) {
      _showErrorDialog("Please enter a valid email address");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Passwords do not match");
      return;
    }

    GlobalVariable.userName = _nameController.text;
    GlobalVariable.userEmail = _emailController.text;
    GlobalVariable.userPassword = _passwordController.text;

    if (mounted) {
      // Navigate to HomeScreen after successful signup
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
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Signup Error"),
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

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const HeaderWidget(role: false, isLogoutBtn: false),
                SizedBox(height: vh(context, 10)),
                const Text(
                  "Create an Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Onset',
                    fontWeight: FontWeight.bold,
                    color: kColorSecondary,
                  ),
                ),
                SizedBox(height: vh(context, 5)),

                /// Username Field
                _buildInputField(
                    "Full Name", _nameController, TextInputType.text),

                /// Email Field
                _buildInputField("Email Address", _emailController,
                    TextInputType.emailAddress),

                /// Password Field
                _buildPasswordField("Password", _passwordController, true),

                /// Confirm Password Field
                _buildPasswordField(
                    "Confirm Password", _confirmPasswordController, false),

                SizedBox(height: vMin(context, 10)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: vww(context, 15)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Navigator.pop(context);
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
                              onPressed: _onSignupClicked,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: vh(context, 2)),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                fontSize: 16,
                                color: kColorBlack,
                              ),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginAuthScreen()),
                                  );
                                },
                                child: const Text(
                                  " Log in",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary, // Clickable color
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Onset-bold',
            color: kColorBlack,
          ),
        ),
        SizedBox(height: vh(context, 1)),
        SizedBox(
          width: vw(context, 40),
          height: vh(context, 6),
          child: TextField(
            controller: controller,
            keyboardType: type,
            autocorrect: false,
            cursorColor: Colors.grey,
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: kEnableSearchBorder,
              focusedBorder: kFocusSearchBorder,
              hintStyle: TextStyle(fontSize: 16.0, color: kColorThird),
              filled: false,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Onset-bold',
            color: kColorBlack,
          ),
        ),
        SizedBox(height: vh(context, 1)),
        SizedBox(
          width: vw(context, 40),
          height: vh(context, 6),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.visiblePassword,
            obscureText:
                isPassword ? _isPasswordHidden : _isConfirmPasswordHidden,
            autocorrect: false,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: kEnableSearchBorder,
              focusedBorder: kFocusSearchBorder,
              suffixIcon: IconButton(
                icon: Icon(
                  isPassword
                      ? (_isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility)
                      : (_isConfirmPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility),
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (isPassword) {
                      _isPasswordHidden = !_isPasswordHidden;
                    } else {
                      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
