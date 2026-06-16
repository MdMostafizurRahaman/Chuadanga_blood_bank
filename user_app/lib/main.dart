import 'package:flutter/material.dart';

void main() {
  runApp(BloodBankApp());
}

class BloodBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuadanga Blood Donation',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LandingScreen(),
    );
  }
}

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blood Donation - Chuadanga')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Blood Group to Search'),
            // Add grid of blood groups here
            ElevatedButton(
              onPressed: () {
                // Action for when the button is pressed goes here
              }, 
              child: Text('Contact Admin (WhatsApp)'),
            ),
          ],
        ),
      ),
    );
  }
}