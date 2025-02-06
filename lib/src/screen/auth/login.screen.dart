import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/home/home.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:laundromats/src/utils/shared_preferences_util.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAuthScreen extends ConsumerStatefulWidget {
  const LoginAuthScreen({super.key});

  @override
  ConsumerState<LoginAuthScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginAuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Logger logger = Logger();
  bool _isPasswordHidden = true;

  void _onLoginClicked() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields");
    } else {
      AuthService authService = AuthService();

      final result = await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Check if result is null or API returned an error
      if (result['success'] == false) {
        _showErrorDialog(
            result['message'] ?? "An error occurred during login.");
        return;
      }

      // Ensure 'user' key exists before accessing it
      if (result.containsKey('data') && result['data'] != null) {
        final user = result['data']['user'];

        // Save token to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['token']);

        // Save full user details
        await SharedPreferencesUtil.saveUserDetails(
          userId: user['id'].toString(),
          userName: user['name'] ?? "",
          userEmail: user['email'] ?? "",
          userExpertIn: user['role_expertIn'] ?? "",
          userBusinessTime: user['role_businessTime'] ?? "",
          userLaundromatsCount: user['role_laundromatsCount'] ?? "",
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
        _showErrorDialog("User data not found. Please try again.");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Error"),
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
              const HeaderWidget(role: true, isLogoutBtn: false),
              SizedBox(height: vh(context, 10)),
              const Text(
                "Login to Laundromats",
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
                  "User Email",
                  textAlign: TextAlign.center,
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: kEnableSearchBorder,
                      focusedBorder: kFocusSearchBorder,
                      hintStyle: TextStyle(fontSize: 16.0, color: kColorThird),
                      hintText: "Email",
                      filled: false,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                      counterText: '',
                    ),
                  ),
                ),
              ]),
              SizedBox(height: vh(context, 3)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  "User Password",
                  textAlign: TextAlign.center,
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
                    obscureText:
                        _isPasswordHidden, // Toggles password visibility
                    autocorrect: false,
                    cursorColor: Colors.grey,
                    style: const TextStyle(
                        fontSize: 16.0, color: Colors.black), // Text style
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: kEnableSearchBorder,
                      focusedBorder: kFocusSearchBorder,
                      hintStyle:
                          const TextStyle(fontSize: 16.0, color: kColorThird),
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden =
                                !_isPasswordHidden; // Toggle visibility
                          });
                        },
                      ),
                      filled: false,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10),
                      counterText: '',
                    ),
                  ),
                ),
              ]),
              SizedBox(height: vMin(context, 12)),
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
                            onPressed: _onLoginClicked,
                          ),
                        ),
                      ],
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
