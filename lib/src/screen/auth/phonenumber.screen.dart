import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/auth/verify.screen.dart';
import 'package:laundromats/src/utils/global_variable.dart';

class PhoneNumberScreen extends ConsumerStatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  ConsumerState<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _fullPhoneNumber = "";

  void _submitPhoneNumber(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      GlobalVariable.userphoneNumber = _phoneController.text;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyCodeScreen(phoneNumber: _fullPhoneNumber),
        ),
      );
    }
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter your phone number",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    /// Phone Number Input with Country Code Dropdown
                    IntlPhoneField(
                      controller: _phoneController,
                      keyboardType:
                          TextInputType.number, // Forces numeric keyboard
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: kColorPrimary, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: kColorPrimary, width: 1.5),
                        ),
                        labelStyle: const TextStyle(color: kColorPrimary),
                      ),
                      initialCountryCode: 'US', // Default country
                      onChanged: (phone) {
                        setState(() {
                          // Remove non-numeric characters
                          String rawNumber =
                              phone.number.replaceAll(RegExp(r'\D'), '');

                          // Ensure proper phone number format
                          if (rawNumber.length >= 6) {
                            _fullPhoneNumber = '${phone.countryCode} '
                                '${rawNumber.substring(0, 3)}-'
                                '${rawNumber.substring(3, 6)}-'
                                '${rawNumber.substring(6)}';
                          } else if (rawNumber.length >= 3) {
                            _fullPhoneNumber = '${phone.countryCode} '
                                '${rawNumber.substring(0, 3)}-'
                                '${rawNumber.substring(3)}';
                          } else {
                            _fullPhoneNumber =
                                '${phone.countryCode} $rawNumber';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.number.isEmpty) {
                          return "Please enter your phone number";
                        } else if (!RegExp(r'^\d+$').hasMatch(value.number)) {
                          return "Only numbers are allowed";
                        } else if (value.number.length < 10) {
                          return "Enter a valid phone number";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
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
                        onPressed: () => _submitPhoneNumber(context),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Onset-Regular',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
