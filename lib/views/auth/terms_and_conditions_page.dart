import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: const Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome to our application! By downloading and using this app, you agree to be bound by the following terms and conditions:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Use of Location: This application requires access to your device\'s location to provide you with location-based services. By using this application, you grant us permission to access and use your device\'s location data. We will use this information only to provide you with our services and to improve your user experience.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '2. Data Collection: We may collect information about your device, including the device type, operating system, and version, as well as information about your use of the application, such as your search history and user preferences. We will use this information to improve our services and to personalize your user experience. We will not share your information with third parties, except as required by law.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '3. User Conduct: You agree to use this application in accordance with these terms and conditions and all applicable laws and regulations. You agree not to use this application for any illegal or unauthorized purpose, and you agree not to use this application in a way that could damage, disable, overburden, or impair our servers or networks.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '4. Indemnification: You agree to indemnify, defend, and hold harmless our company, its officers, directors, employees, agents, and affiliates from and against any and all claims, damages, liabilities, costs, and expenses arising from your use of this application.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '5. Limitation of Liability: To the fullest extent permitted by law, we will not be liable to you or any third party for any indirect, incidental, special, consequential, or punitive damages arising from your use of this application, even if we have been advised of the possibility of such damages.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '6. Changes to Terms and Conditions: We reserve the right to modify or amend these terms and conditions at any time without prior notice. Your continued use of this application after any such modification or amendment constitutes your acceptance of the new terms and conditions.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'By signing in, you acknowledge that you have read and understood these terms and conditions and agree to be bound by them. If you do not agree to these terms and conditions, please do not use this application.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )),
    );
  }
}
