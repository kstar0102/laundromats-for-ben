import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/screen/auth/login.screen.dart';
import 'package:laundromats/src/screen/auth/phonenumber.screen.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:logger/logger.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/utils/index.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
    GlobalVariable.userAddress = _addressController.text;

    if (mounted) {
      Navigator.push(
        context, // Pass the BuildContext
        MaterialPageRoute(
          builder: (context) => const PhoneNumberScreen(),
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
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
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
          body: Container(
            color: kColorWhite,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 0.0), // Adjust padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const HeaderWidget(
                      role: false,
                      isLogoutBtn: false,
                      backIcon: true,
                    ),
                    SizedBox(height: vh(context, 3)),

                    /// **Title - "Create an Account"**
                    const Center(
                      child: Text(
                        "Create an Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Onset',
                          fontWeight: FontWeight.bold,
                          color: kColorSecondary,
                        ),
                      ),
                    ),
                    SizedBox(height: vh(context, 3)),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          /// **Form Fields - Centered & Adjusted**
                          _buildInputField("Full Name", _nameController,
                              TextInputType.text, "Enter your full name", true),
                          SizedBox(height: vh(context, 2)),

                          _buildInputField(
                              "Email",
                              _emailController,
                              TextInputType.emailAddress,
                              "Enter your email",
                              true),
                          if (!_isEmailValid)
                            const Padding(
                              padding: EdgeInsets.only(left: 5.0, top: 5.0),
                              child: Text("Invalid email format",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          SizedBox(height: vh(context, 2)),

                          _buildInputField(
                              "Address (Optional)",
                              _addressController,
                              TextInputType.text,
                              "Enter your Address",
                              false),
                          SizedBox(height: vh(context, 2)),

                          _buildPasswordField("Password", _passwordController,
                              true, "Enter your password"),
                          if (!_isPasswordValid)
                            const Padding(
                              padding: EdgeInsets.only(left: 5.0, top: 5.0),
                              child: Text(
                                  "Password must be at least 4 characters",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          SizedBox(height: vh(context, 2)),

                          _buildPasswordField(
                              "Confirm Password",
                              _confirmPasswordController,
                              false,
                              "Confirm your password"),
                          SizedBox(height: vh(context, 3)),

                          /// **Buttons - Properly Aligned & Centered**
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:
                                    vw(context, 15), // Set your desired width
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
                                    Navigator.pop(context);
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

                              const SizedBox(
                                  width: 16), // Space between buttons

                              SizedBox(
                                width:
                                    vw(context, 15), // Set your desired width
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
                                  onPressed: _onSignupClicked,
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
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: vh(context, 4)),

                    /// **Login Text - Properly Centered**
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: kColorBlack,
                          ),
                          children: [
                            const TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: "Log in",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kColorPrimary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginAuthScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: vh(context, 3)),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      TextInputType type, String hint, bool require) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
            if (require == true)
              const Text(
                " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: vh(context, 1)),
        SizedBox(
          width: vw(context, 50),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
            const Text(
              " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: vh(context, 1)),
        SizedBox(
          width: vw(context, 50),
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
