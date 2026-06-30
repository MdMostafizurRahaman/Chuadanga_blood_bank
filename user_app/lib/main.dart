import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';

const _emojiFallback = ['Noto Color Emoji'];

TextTheme _applyEmojiFallback(TextTheme t) {
  return TextTheme(
    displayLarge: t.displayLarge?.copyWith(fontFamilyFallback: _emojiFallback),
    displayMedium: t.displayMedium?.copyWith(fontFamilyFallback: _emojiFallback),
    displaySmall: t.displaySmall?.copyWith(fontFamilyFallback: _emojiFallback),
    headlineLarge: t.headlineLarge?.copyWith(fontFamilyFallback: _emojiFallback),
    headlineMedium: t.headlineMedium?.copyWith(fontFamilyFallback: _emojiFallback),
    headlineSmall: t.headlineSmall?.copyWith(fontFamilyFallback: _emojiFallback),
    titleLarge: t.titleLarge?.copyWith(fontFamilyFallback: _emojiFallback),
    titleMedium: t.titleMedium?.copyWith(fontFamilyFallback: _emojiFallback),
    titleSmall: t.titleSmall?.copyWith(fontFamilyFallback: _emojiFallback),
    bodyLarge: t.bodyLarge?.copyWith(fontFamilyFallback: _emojiFallback),
    bodyMedium: t.bodyMedium?.copyWith(fontFamilyFallback: _emojiFallback),
    bodySmall: t.bodySmall?.copyWith(fontFamilyFallback: _emojiFallback),
    labelLarge: t.labelLarge?.copyWith(fontFamilyFallback: _emojiFallback),
    labelMedium: t.labelMedium?.copyWith(fontFamilyFallback: _emojiFallback),
    labelSmall: t.labelSmall?.copyWith(fontFamilyFallback: _emojiFallback),
  );
}

void main() {
  runApp(const BloodBankApp());
}

class BloodBankApp extends StatelessWidget {
  const BloodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuadanga Blood Donation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        textTheme: _applyEmojiFallback(ThemeData.light().textTheme),
      ),
      home: const LandingScreen(),
    );
  }
}
