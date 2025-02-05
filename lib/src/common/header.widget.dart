import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/auth/login.auth.dart';
import 'package:laundromats/src/screen/subscription/subscription.screen.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderWidget extends ConsumerStatefulWidget {
  const HeaderWidget(
      {super.key, required this.role, required this.isLogoutBtn});
  final bool? role; // Controls premium banner
  final bool isLogoutBtn; // Controls logout button visibility

  @override
  ConsumerState<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends ConsumerState<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              left: vMin(context, 3),
              right: vMin(context, 3),
              top: vMin(context, 10),
              bottom: vMin(context, 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/icons/icon.png',
                  ),
                  SizedBox(width: vMin(context, 1)),
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
              // Show Logout Button only if _isLogoutBtn is true
              if (widget.isLogoutBtn)
                IconButton(
                  icon: const Icon(Icons.logout, color: kColorPrimary),
                  onPressed: () => _showLogoutDialog(context),
                ),
            ],
          ),
        ),
        SizedBox(height: vMin(context, 2)),
        widget.role == false
            ? const Divider(
                color: kColorPrimary,
                thickness: 1,
              )
            : InkWell(
                onTap: () => _showGoPremiumDialog(context),
                child: Container(
                  width: vMin(context, 100),
                  height: vMin(context, 10),
                  decoration: const BoxDecoration(
                    color: kColorPrimary,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/icons/crown.png"),
                      SizedBox(width: vMin(context, 2)),
                      Text(
                        getPremium.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Onset-Regular',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  /// Show Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.exit_to_app, size: 50, color: kColorPrimary),
              const SizedBox(height: 10),
              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kColorSecondary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to log out?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: kColorSecondary),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: kColorSecondary)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _logout(context),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Logout Function - Clears Local Storage and Redirects to Login
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored user data

    if (mounted) {
      // ignore: use_build_context_synchronously
      final navigator = Navigator.of(context);

      navigator.push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  /// Show Go Premium Dialog
  void _showGoPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(20),
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/icons/crown-2.png", width: 50),
                  const SizedBox(height: 10),
                  const Text(
                    "Go Premium",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kColorSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enjoying the free experience so far? What are you waiting for? Come join us, Go premium and get unlimited features.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: kColorSecondary),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubscriptionScreen()),
                      );
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -5,
                right: -5,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
