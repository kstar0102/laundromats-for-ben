import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/auth/login.auth.dart';
import 'package:laundromats/src/screen/home/home.screen.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myId = prefs.getString('userId');
    logger.i('user id : $myId');

    if (myId == null || myId.isEmpty) {}

    Future.delayed(const Duration(seconds: 3), () {
      if (myId == null || myId.isEmpty) {
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }
      } else {
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: FocusScope(
          child: Container(
            decoration: const BoxDecoration(color: kColorWhite),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: vh(context, 30)),
                Image.asset(
                  'assets/images/background/logo.png',
                  width: 200,
                  height: 200,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: vh(context, 30),
                  child: Text(
                    appName.toString(),
                    style: const TextStyle(
                        fontSize: 40,
                        fontFamily: 'Onset',
                        fontWeight: FontWeight.bold,
                        color: kColorPrimary),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
