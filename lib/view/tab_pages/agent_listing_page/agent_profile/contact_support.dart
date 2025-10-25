// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();

  final _subjectCtl = TextEditingController();
  final _messageCtl = TextEditingController();
  String _priority = 'Medium';

  static const String _supportEmail = 'support@rentapp.example';
  static const String _supportPhone = '+1234567890';

  @override
  void dispose() {
    _subjectCtl.dispose();
    _messageCtl.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final subject = '[${_priority.toUpperCase()}] ${_subjectCtl.text}';
    final body = StringBuffer()
      ..writeln('')
      ..writeln(_messageCtl.text);

    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {'subject': subject, 'body': body.toString()},
    );

    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email client.')),
      );
    }
  }

  // ignore: unused_element
  Future<void> _callSupport() async {
    final uri = Uri(scheme: 'tel', path: _supportPhone);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start phone call.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Need help? Describe your issue below and our support team will get back to you.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _subjectCtl,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          prefixIcon: Icon(Icons.label),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _priority,
                        items: const [
                          DropdownMenuItem(value: 'Low', child: Text('Low')),
                          DropdownMenuItem(
                            value: 'Medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(value: 'High', child: Text('High')),
                        ],
                        onChanged: (v) =>
                            setState(() => _priority = v ?? 'Medium'),
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          prefixIcon: Icon(Icons.priority_high),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _messageCtl,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.message),
                        ),
                        maxLines: 6,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter a message';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: igBlue, // igBlue color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                              onPressed: _sendEmail,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.send, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Send Email',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /* const SizedBox(width: 12),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.call),
                            label: const Text('Call Support'),
                            onPressed: _callSupport,
                          ),*/
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We aim to respond within 24-48 hours.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
