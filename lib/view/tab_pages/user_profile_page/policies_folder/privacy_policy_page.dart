import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This Privacy Policy explains how we collect, use, and protect your personal data when you use our RentApp. We are committed to complying with the UK General Data Protection Regulation (UK GDPR) and the Data Protection Act 2018.',
            ),
            SizedBox(height: 16),
            Text(
              'What Data We Collect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We may collect the following types of personal data:\n'
              '- Name, email address, and contact details.\n'
              '- Payment information (if applicable).\n'
              '- Location data (if you enable location services).\n'
              '- Usage data, such as app interactions and preferences.',
            ),
            SizedBox(height: 16),
            Text(
              'How We Use Your Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We use your data for the following purposes:\n'
              '- To provide and improve our services.\n'
              '- To process payments and manage your account.\n'
              '- To communicate with you about updates, offers, and support.\n'
              '- To comply with legal obligations.',
            ),
            SizedBox(height: 16),
            Text(
              'Sharing Your Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We do not sell your personal data. However, we may share your data with trusted third parties, such as payment processors or service providers, to deliver our services. We ensure that these parties comply with data protection laws.',
            ),
            SizedBox(height: 16),
            Text(
              'Your Rights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Under UK law, you have the following rights:\n'
              '- The right to access your personal data.\n'
              '- The right to rectify inaccurate data.\n'
              '- The right to request deletion of your data.\n'
              '- The right to restrict or object to data processing.\n'
              '- The right to data portability.\n'
              'To exercise these rights, please contact us at privacy@rentapp.com.',
            ),
            SizedBox(height: 16),
            Text(
              'Data Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We implement appropriate technical and organizational measures to protect your data from unauthorized access, loss, or misuse. However, no system is completely secure, and we cannot guarantee absolute security.',
            ),
            SizedBox(height: 16),
            Text(
              'Changes to This Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We may update this Privacy Policy from time to time. Any changes will be posted on this page, and we encourage you to review it regularly.',
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions or concerns about this Privacy Policy, please contact us at:\n'
              'Email: privacy@rentapp.com\n'
              'Address: RentApp Ltd, 123 Rent Street, London, UK',
            ),
          ],
        ),
      ),
    );
  }
}