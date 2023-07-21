import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'At SafeStreets, we prioritize the privacy and security of our users. This Privacy Policy outlines how we collect, use, and protect your information when you use our application.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Collection:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may collect certain information to enhance your experience and provide a secure environment. This information may include anonymized data, such as usage patterns, device information, and user interactions. We do not collect personally identifiable information unless explicitly provided by you.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Usage:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'The data we collect is primarily used to improve our services and ensure the safety and security of our users. It helps us identify trends, detect potential risks, and develop measures to enhance the overall user experience. All data collected is processed in an anonymized and aggregated format to maintain user privacy.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Sharing:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We respect your privacy and will not disclose any personally identifiable information to third parties without your consent. However, we may share anonymized and aggregated statistics with government agencies, businesses, or organizations to facilitate the improvement of safety measures in specific regions. These statistics are general in nature and do not include any personally identifiable information.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Data Security:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We take extensive measures to safeguard the information we collect. We utilize industry-standard security protocols and employ strict data protection practices to prevent unauthorized access, disclosure, or alteration of your data.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Policy Updates:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements. We encourage you to review this policy periodically for any updates. By continuing to use our application, you acknowledge and agree to the terms outlined in this Privacy Policy.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you have any questions, concerns, or requests regarding your privacy or this policy, please contact us at [contact information].',
            ),
          ],
        ),
      ),
    );
  }
}
