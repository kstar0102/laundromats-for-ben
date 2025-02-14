import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/utils/index.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class CardInputScreen extends StatefulWidget {
  const CardInputScreen({super.key});

  @override
  CardInputScreenState createState() => CardInputScreenState();
}

class CardInputScreenState extends State<CardInputScreen> {
  Map<String, dynamic>? paymentIntent;
  final logger = Logger();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // Function to format card number as XXXX-XXXX-XXXX-XXXX
  String formatCardNumber(String text) {
    text = text.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write('-'); // Add separator every 4 digits
      }
    }
    return buffer.toString();
  }

  // Function to format expiration date as MM/YY
  String formatExpiryDate(String text) {
    text = text.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    if (text.length > 4) {
      text = text.substring(0, 4); // Limit to 4 characters
    }
    if (text.length >= 3) {
      return '${text.substring(0, 2)}/${text.substring(2)}';
    }
    return text;
  }

  void _onCardNumberChanged(String value) {
    final formatted = formatCardNumber(value);
    _cardNumberController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void _onExpiryDateChanged(String value) {
    final formatted = formatExpiryDate(value);
    _expiryDateController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void onBackClicked() {
    Navigator.pop(context);
  }

  /// **Stripe API: Create Payment Intent**
  Future<void> createPaymentIntent() async {
    try {
      const String stripeSecretKey =
          "sk_test_51PwmEYGOr74zlXKwu6k9mk3urv58cIFvxOLhoImPeBjkAtu8ZRZCdCEWnlQJwnliSMI9KHDkh2bCIAbKVj9PCxNq00Dg3cD6bf"; // Replace with your Stripe Secret Key

      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: {
          "Authorization": "Bearer $stripeSecretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "amount": "1000", // Amount in cents (1000 = $10)
          "currency": "usd",
          "payment_method_types[]": "card",
        },
      );

      final jsonResponse = jsonDecode(response.body);
      setState(() {
        paymentIntent = jsonResponse;
      });

      logger.i("Payment Intent Created: $paymentIntent");
    } catch (e) {
      logger.e("Error creating payment intent: $e");
    }
  }

  /// **Process Payment with Stripe**
  Future<void> processPayment() async {
    try {
      if (paymentIntent == null) {
        await createPaymentIntent();
      }

      // Initialize Stripe Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          merchantDisplayName: 'Your Business',
        ),
      );

      // Display the Stripe Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Successful!")),
      );
    } on StripeException catch (e) {
      logger.e("Stripe Exception: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: ${e.error.localizedMessage}")),
      );
    } catch (e) {
      logger.e("Payment Error: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(
                  role: true,
                  isLogoutBtn: false,
                  backIcon: true,
                ),
                SizedBox(
                  height: vh(context, 5),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Card Number",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kColorBlack),
                      ),
                      SizedBox(
                        height: vh(context, 1),
                      ),
                      SizedBox(
                        height: 60, // Set desired height
                        child: TextField(
                          controller: _cardNumberController,
                          keyboardType: TextInputType.number,
                          maxLength: 19,
                          onChanged: _onCardNumberChanged,
                          decoration: const InputDecoration(
                            hintText: "1234-5678-9012-3456",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: kEnableBorder,
                            focusedBorder: kFocusSearchBorder,
                            filled: false,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expiry Date (MM/YY)",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kColorBlack),
                      ),
                      SizedBox(
                        height: vh(context, 1),
                      ),
                      SizedBox(
                        height: 60, // Set desired height
                        child: TextField(
                          controller: _expiryDateController,
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          onChanged: _onExpiryDateChanged,
                          decoration: const InputDecoration(
                            hintText: "12/24",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: kEnableBorder,
                            focusedBorder: kFocusSearchBorder,
                            filled: false,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "CVV",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kColorBlack),
                      ),
                      SizedBox(
                        height: vh(context, 1),
                      ),
                      SizedBox(
                        height: 60, // Set desired height
                        child: TextField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          decoration: const InputDecoration(
                            hintText: "123",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: kEnableBorder,
                            focusedBorder: kFocusSearchBorder,
                            filled: false,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: vMin(context, 40),
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
                        onPressed: onBackClicked,
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
                    SizedBox(
                      width: vMin(context, 40),
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
                        onPressed: processPayment,
                        child: const Text(
                          "Add Payment",
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
        ));
  }
}
