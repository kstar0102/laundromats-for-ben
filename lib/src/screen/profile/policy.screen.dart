import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/utils/index.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
              "Privacy Policy",
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  const Text(
                    "Effective Date: December 5, 2024",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildSectionTitle("Information We Collect"),
                  _buildBulletPoint(
                      "Account Information: We collect only the minimum information required for login authentication."),
                  _buildBulletPoint(
                      "User Questions and Answers: We store questions you ask and ChatGPT responses for reference and service improvement."),
                  _buildBulletPoint(
                      "Payment Information: Subscription payments are processed securely through third-party payment processors."),
                  _buildSectionTitle("How We Use Your Information"),
                  _buildBulletPoint(
                      "Providing Services: To deliver accurate answers and a personalized user experience."),
                  _buildBulletPoint(
                      "Improving the Platform: To refine and enhance the accuracy and relevance of the services."),
                  _buildBulletPoint(
                      "Communication: To notify you of updates, changes, or account-related information."),
                  _buildSectionTitle("Data Retention"),
                  _buildBulletPoint(
                      "Login Information: Retained as long as your account is active."),
                  _buildBulletPoint(
                      "User Questions and Answers: Stored indefinitely for reference and improvement."),
                  _buildSectionTitle("Data Sharing"),
                  _buildBulletPoint(
                      "We do not sell, rent, or share your personal information except when required by law or to protect user rights."),
                  _buildSectionTitle("Cookies and Tracking"),
                  _buildBulletPoint(
                      "Cookies: Used to enhance browsing experience; preferences can be managed in browser settings."),
                  _buildBulletPoint(
                      "Third-Party Analytics: Used to monitor traffic and usage patterns without accessing personal data."),
                  _buildSectionTitle("Data Security"),
                  _buildBulletPoint(
                      "We implement security measures to protect your data, but no method is entirely secure."),
                  _buildSectionTitle("User Rights"),
                  _buildBulletPoint(
                      "Access and Correction: Request access and corrections to your stored data."),
                  _buildBulletPoint(
                      "Account Deletion: Request account deletion by contacting us."),
                  _buildBulletPoint(
                      "Opt-Out: Adjust account settings to disable notifications."),
                  _buildSectionTitle("Children’s Privacy"),
                  _buildBulletPoint(
                      "Not intended for children under 13, and we do not knowingly collect information from them."),
                  _buildSectionTitle("Changes to This Policy"),
                  _buildBulletPoint(
                      "We may update this policy; continued use of our services constitutes acceptance of changes."),
                  _buildSectionTitle("Contact Information"),
                  _buildBulletPoint(
                      "Laundromats.ai, 5935 South Blvd, Charlotte, NC 28217"),
                  _buildBulletPoint("Email: amber@capuletcleaning.com"),
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
