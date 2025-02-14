import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/utils/index.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0), // Adjust height as needed
          child: AppBar(
            backgroundColor: kColorWhite,
            elevation: 0, // Removes shadow for a flat UI
            automaticallyImplyLeading: true, // Keeps back button if applicable
            title: const Text(
              "Terms of Service",
              style: TextStyle(
                fontSize: 20, // Adjust font size for better fit in AppBar
                fontWeight: FontWeight.bold,
                color: Colors.black, // Ensure readability
              ),
            ),
            centerTitle: true, // Centers the title
          ),
        ),
        body: Container(
          color: kColorWhite,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Last Updated: December 5, 2024",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildSectionTitle("Purpose of the Website"),
                  _buildBulletPoint(
                      "Laundromats.ai provides expert answers about the laundromat industry."),
                  _buildBulletPoint(
                      "Users can submit questions, and ChatGPT provides responses."),
                  _buildSectionTitle("User Accounts and Login"),
                  _buildBulletPoint("Users must log in with a Google account."),
                  _buildBulletPoint(
                      "Only minimal personal data is stored for authentication purposes."),
                  _buildBulletPoint(
                      "Questions and answers are stored for reference and service improvement."),
                  _buildSectionTitle("Payment and Subscriptions"),
                  _buildBulletPoint(
                      "Subscription: \$1 per month or \$10 annually."),
                  _buildBulletPoint(
                      "Payments are non-refundable, including for banned users."),
                  _buildSectionTitle("Pricing and Service Changes"),
                  _buildBulletPoint(
                      "Laundromats.ai reserves the right to modify pricing."),
                  _buildBulletPoint(
                      "Users will be notified of changes through the website."),
                  _buildSectionTitle("User Conduct"),
                  _buildBulletPoint(
                      "Users must act respectfully and follow applicable laws."),
                  _buildBulletPoint(
                      "Abuse such as spamming or harassment may result in bans."),
                  _buildBulletPoint(
                      "Laundromats.ai reserves the right to block users at its discretion."),
                  _buildSectionTitle("Rights to Content"),
                  _buildBulletPoint(
                      "All submitted questions and answers are owned by Laundromats.ai."),
                  _buildBulletPoint(
                      "Users grant a perpetual, royalty-free license to store and use content."),
                  _buildSectionTitle("Limitation of Liability"),
                  _buildBulletPoint(
                      "Laundromats.ai does not guarantee accuracy or completeness of responses."),
                  _buildBulletPoint(
                      "The website is provided \"as is,\" without warranties."),
                  _buildSectionTitle("Privacy"),
                  _buildBulletPoint("Only login verification data is stored."),
                  _buildBulletPoint(
                      "Stored content is anonymized as much as possible."),
                  _buildSectionTitle("Modifications to Terms"),
                  _buildBulletPoint(
                      "Laundromats.ai reserves the right to update terms at any time."),
                  _buildBulletPoint(
                      "Continued use constitutes acceptance of changes."),
                  _buildSectionTitle("Contact Information"),
                  _buildBulletPoint(
                      "Laundromats.ai, 5935 South Blvd, Charlotte, NC 28217"),
                  const SizedBox(height: 10),
                  const Text(
                    "By using Laundromats.ai, you acknowledge and agree to these Terms of Service. Thank you for being part of our community! A product of Capulet Cleaning I LLC",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(vMin(context, 4)),
                    child: SizedBox(
                      width: vMin(context, 100),
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
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
