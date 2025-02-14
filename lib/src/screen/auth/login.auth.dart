import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/auth/login.screen.dart';
import 'package:laundromats/src/screen/home/home.screen.dart';
import 'package:laundromats/src/screen/login_step/category.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:logger/logger.dart';

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

  void _signInEmail() {
    final navigator = Navigator.of(context);

    navigator.push(
      MaterialPageRoute(
        builder: (context) => const LoginAuthScreen(),
      ),
    );
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
          navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // ❌ User does not exist, show dialog before proceeding
          bool proceedToRegister = await _showRegisterDialog(context);

          if (proceedToRegister) {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
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

        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const CategoryScreen()),
        );
      }
    } catch (e) {
      logger.e("Facebook Login Failed: $e");
    }
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
          body: SizedBox.expand(
              child: SingleChildScrollView(
            child: FocusScope(
              child: Container(
                decoration: const BoxDecoration(color: kColorWhite),
                height: vhh(context, 100),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: vh(context, 10)),
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
                        height: vMin(context, 10),
                      ),
                      Text(
                        loginHeaderTitle.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'Onset',
                            fontWeight: FontWeight.bold,
                            color: kColorSecondary),
                      ),
                      SizedBox(
                        height: vMin(context, 10),
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
                        height: vMin(context, 15),
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
                                height: vMin(context, 10),
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
                                      _signInEmail();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons
                                              .mail, // System-provided email icon
                                          size: vMin(context,
                                              3.5), // Adjust size based on your layout
                                          color:
                                              kColorInputBorder, // Customize color if needed
                                        ), // Email icon
                                        const SizedBox(
                                            width:
                                                8), // Space between icon and text
                                        const Text(
                                          "Sign-In using Email",
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
                          ))
                    ]),
              ),
            ),
          )),
        ));
  }
}
