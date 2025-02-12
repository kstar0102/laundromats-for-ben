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
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  /// **Email Validation Function**
  bool _validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$');
    return emailRegex.hasMatch(email);
  }

  void _onSignupClicked() {
    setState(() {
      _isEmailValid = _validateEmail(_emailController.text.trim());
      _isPasswordValid = _passwordController.text.length >= 4;
    });

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields");
      return;
    }

    if (!_isEmailValid) {
      _showErrorDialog("Please enter a valid email address");
      return;
    }

    if (!_isPasswordValid) {
      _showErrorDialog("Password must be at least 4 characters long");
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

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const HeaderWidget(role: false, isLogoutBtn: false),
                SizedBox(height: vh(context, 5)),
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
                _buildInputField("Full Name", _nameController,
                    TextInputType.text, "Enter your full name"),
                SizedBox(height: vh(context, 2)),
                _buildInputField("Email Address", _emailController,
                    TextInputType.emailAddress, "Enter your email"),
                if (!_isEmailValid)
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 5.0),
                    child: Text("Invalid email format",
                        style: TextStyle(color: Colors.grey)),
                  ),
                SizedBox(height: vh(context, 2)),
                _buildPasswordField("Password", _passwordController, true,
                    "Enter your password"),
                if (!_isPasswordValid)
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 5.0),
                    child: Text("Password must be at least 4 characters",
                        style: TextStyle(color: Colors.grey)),
                  ),
                SizedBox(height: vh(context, 2)),
                _buildPasswordField("Confirm Password",
                    _confirmPasswordController, false, "Confirm your password"),
                SizedBox(height: vh(context, 2)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: vww(context, 10), vertical: vh(context, 3)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: vMin(context, 30),
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
                            width: vMin(context, 30),
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
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(children: [
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
                                builder: (context) => const LoginAuthScreen()),
                          );
                        },
                        child: const Text(
                          "   Log in",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      TextInputType type, String hint) {
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
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: kEnableSearchBorder,
              focusedBorder: kFocusSearchBorder,
              hintStyle: const TextStyle(fontSize: 16.0, color: kColorThird),
              hintText: hint,
              filled: false,
              disabledBorder: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isPassword, String hint) {
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
              hintText: hint,
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
