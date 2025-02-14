import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/login_step/category.screen.dart';

class VerifyCodeScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const VerifyCodeScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _remainingTime = 60; // 60 seconds countdown
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingTime = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        _timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  void _resendCode() {
    if (_canResend) {
      _startTimer(); // Restart timer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A new code has been sent")),
      );
    }
  }

  void _verifyCode() {
    String otpCode = _controllers.map((controller) => controller.text).join();
    if (otpCode.length == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CategoryScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the full 6-digit code")),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: kColorWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Container(
        color: kColorWhite,
        child: Column(
          children: [
            const HeaderWidget(
              role: true,
              isLogoutBtn: false,
              backIcon: true,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter the verification code sent to ${widget.phoneNumber}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// OTP Input Fields (6 TextFields)
                  Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 50,
                          height: 60,
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: kColorPrimary,
                            ),
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: kColorPrimary, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                            ),

                            /// Handles input change and moves focus
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (index < 5) {
                                  _focusNodes[index + 1]
                                      .requestFocus(); // Move to next field
                                } else {
                                  _focusNodes[index]
                                      .unfocus(); // Last field, close keyboard
                                }
                              }
                            },

                            /// Handles backspace (Move focus to the previous field when empty)
                            onEditingComplete: () {
                              if (_controllers[index].text.isEmpty &&
                                  index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kColorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 20),
                      ),
                      onPressed: _verifyCode,
                      child: const Text(
                        "Verify Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Onset-Regular',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Resend Code Section
                  _canResend
                      ? TextButton(
                          onPressed: _resendCode,
                          child: const Text(
                            "Resend Code",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kColorPrimary,
                            ),
                          ),
                        )
                      : Text(
                          "Resend in $_remainingTime sec",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
