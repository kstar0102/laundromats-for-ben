import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppBar(
        title: const Text("Pricing"),
        backgroundColor: kColorWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kColorPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Get The Premium Experience",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kColorPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose a plan that fits your needs, whether it’s monthly flexibility or the savings of a yearly subscription.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: kColorSecondary),
            ),
            const SizedBox(height: 20),

            // Pricing Cards
            _buildSubscriptionPlan(
              title: "Free",
              price: "\$0",
              benefits: [
                "Lorem ipsum dolor sit amet",
                "Lorem ipsum dolor sit amet"
              ],
              highlight: false,
              context: context,
            ),
            _buildSubscriptionPlan(
              title: "Basic",
              price: "\$10",
              discount: "-15%",
              benefits: [
                "Lorem ipsum dolor sit amet",
                "Lorem ipsum dolor sit amet"
              ],
              highlight: false,
              context: context,
            ),
            _buildSubscriptionPlan(
              title: "Pro",
              price: "\$15",
              discount: "-15%",
              benefits: [
                "Lorem ipsum dolor sit amet",
                "Lorem ipsum dolor sit amet"
              ],
              highlight: true,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionPlan({
    required String title,
    required String price,
    String? discount,
    required List<String> benefits,
    required bool highlight,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? kColorPrimary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kColorPrimary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.white : kColorPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            price,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.white : kColorPrimary,
            ),
          ),
          if (discount != null)
            Text(
              discount,
              style: TextStyle(
                fontSize: 14,
                color: highlight ? Colors.white : kColorPrimary,
              ),
            ),
          const SizedBox(height: 10),
          ...benefits.map((benefit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "✔ $benefit",
                  style: TextStyle(
                    color: highlight ? Colors.white : kColorSecondary,
                  ),
                ),
              )),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: highlight ? Colors.white : kColorPrimary,
            ),
            onPressed: () {},
            child: Text(
              "Get Started",
              style: TextStyle(color: highlight ? kColorPrimary : Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
