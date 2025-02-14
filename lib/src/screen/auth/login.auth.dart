import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/auth/phonenumber.screen.dart';
import 'package:laundromats/src/screen/auth/signup.screen.dart';
import 'package:laundromats/src/screen/home/home.screen.dart';
import 'package:laundromats/src/screen/login_step/category.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:laundromats/src/utils/shared_preferences_util.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final bool _isKeyboardVisible = false;
  final AuthService authService = AuthService();
  final logger = Logger();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

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

  Future<void> _signInGoogle(BuildContext context) async {
    final navigator = Navigator.of(context);

    try {
      var user = await authService.signInWithGoogle();

      if (user != null) {
        logger.i("Google Login Success: ${user.displayName}");
        logger.i("Email: ${user.email}");

        GlobalVariable.userName = user.displayName;
        GlobalVariable.userEmail = user.email;

        bool userExists = await AuthService().checkUserExistence(user.email!);

        if (userExists) {
          navigator.push(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // ❌ User does not exist, show dialog before proceeding
          // ignore: use_build_context_synchronously
          bool proceedToRegister = await _showRegisterDialog(context);

          if (proceedToRegister) {
            navigator.push(
              MaterialPageRoute(
                  builder: (context) => const PhoneNumberScreen()),
            );
          }
        }
      }
    } catch (e) {
      logger.e("Google Login Failed: $e");
    }
  }

  Future<bool> _showRegisterDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("User Not Found"),
          content: const Text(
              "You need to register before proceeding. Would you like to continue?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // ❌ Cancel, stay on login screen
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // ✅ Proceed to CategoryScreen
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInFacebook(BuildContext context) async {
    final navigator = Navigator.of(context);

    try {
      var user = await authService.signInWithFacebook();
      if (user != null) {
        logger.i("Facebook Login Success: ${user.displayName}");
        logger.i("Email: ${user.email}");
        GlobalVariable.userName = user.displayName;
        GlobalVariable.userEmail = user.email;

        navigator.push(
          MaterialPageRoute(builder: (context) => const CategoryScreen()),
        );
      }
    } catch (e) {
      logger.e("Facebook Login Failed: $e");
    }
  }

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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                      SizedBox(height: vh(context, 3)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icons/icon.png',
                          ),
                          SizedBox(
                            width: vMin(context, 1),
                          ),
                          Text(
                            appName.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Onset-Regular',
                                fontWeight: FontWeight.bold,
                                color: kColorPrimary),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: vMin(context, 5),
                      ),
                      Text(
                        loginHeaderTitle.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 26,
                            fontFamily: 'Onset',
                            fontWeight: FontWeight.bold,
                            color: kColorSecondary),
                      ),
                      SizedBox(
                        height: vMin(context, 5),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: vMin(context, 2.5),
                            right: vMin(context, 2.5)),
                        child: Text(
                          loginDescriptionContent.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Onset-Regular',
                              color: kColorSecondary),
                        ),
                      ),
                      SizedBox(
                        height: vMin(context, 5),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: vww(context, 15), right: vww(context, 15)),
                          child: Column(
                            children: [
                              Text(
                                adsName.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Onset',
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary),
                              ),
                              SizedBox(
                                height: vMin(context, 5),
                              ),
                              Column(
                                children: [
                                  TextButton(
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
                                      _signInGoogle(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/icons/google.png',
                                          width: vMin(context, 5),
                                          height: vMin(context, 5),
                                        ), // Email icon
                                        const SizedBox(
                                            width:
                                                8), // Space between icon and text
                                        const Text(
                                          "Sign-In with Google",
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontSize: 15,
                                            fontFamily: 'Onset-Regular',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: vMin(context, 3),
                                  ),
                                  TextButton(
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
                                      _signInFacebook(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/icons/facebook.png',
                                          width: vMin(context, 5),
                                          height: vMin(context, 5),
                                        ), // Email icon
                                        const SizedBox(
                                            width:
                                                8), // Space between icon and text
                                        const Text(
                                          "Sign-In with Facebook",
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontSize: 15,
                                            fontFamily: 'Onset-Regular',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(
                        height: vh(context, 1),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const Divider(
                                color: Colors.grey, // Line color
                                thickness: 1, // Line thickness
                              ),
                            ),
                          ),
                          const Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.grey, // Text color
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Onset-Regular',
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const Divider(
                                color: Colors.grey, // Line color
                                thickness: 1, // Line thickness
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: vh(context, 2)),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: vw(context, 43),
                              height: vh(context, 6),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                decoration: const InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableSearchBorder,
                                  focusedBorder: kFocusSearchBorder,
                                  hintStyle: TextStyle(
                                      fontSize: 16.0, color: kColorThird),
                                  hintText: "Email",
                                  filled: false,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(height: vh(context, 2)),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: vw(context, 43),
                              height: vh(context, 6),
                              child: TextField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText:
                                    _isPasswordHidden, // Toggles password visibility
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black), // Text style
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableSearchBorder,
                                  focusedBorder: kFocusSearchBorder,
                                  hintStyle: const TextStyle(
                                      fontSize: 16.0, color: kColorThird),
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
                      SizedBox(height: vh(context, 2)),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: vh(context, 2)),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: kColorBlack,
                              ),
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: "Sign Up",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: kColorPrimary,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context, // Pass the BuildContext
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: vh(context, 4),
                      ),
                      SizedBox(
                        width: vw(context, 43), // Set your desired width
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                kColorPrimary, // Green background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 20), // Adjust padding
                          ),
                          onPressed: _onLoginClicked,
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 15,
                              fontFamily: 'Onset-Regular',
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
