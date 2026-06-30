import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  final String bloodGroup;
  const ContactScreen({super.key, required this.bloodGroup});

  final String adminPhone = '01700000000';
  final String adminWhatsApp = '8801700000000';

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/$adminWhatsApp?text=${Uri.encodeComponent("I need $bloodGroup blood. Please help!")}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:$adminPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$bloodGroup রক্ত'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red.shade50,
              child: Text('\u{1FA78}', style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 20),
            Text(
              '\u{1FA78} ব্লাড গ্রুপ: $bloodGroup',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\u{1F4DE} ডোনার হিসেবে নিবন্ধনের জন্য অ্যাডমিনের সাথে যোগাযোগ করুন',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchWhatsApp,
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text('\u{1F4AC} হোয়াটসঅ্যাপে যোগাযোগ করুন', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchPhone,
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text('\u{1F4F1} অ্যাডমিনকে কল করুন', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber.shade800),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'আপনার নাম, ছবি, ঠিকানা, ফোন ও ব্লাড গ্রুপ হোয়াটসঅ্যাপের মাধ্যমে অ্যাডমিনকে পাঠান।\nঅ্যাডমিন আপনাকে ডোনার হিসেবে নিবন্ধিত করবেন।',
                      style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
                    ),
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
