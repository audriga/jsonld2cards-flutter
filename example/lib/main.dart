import 'package:flutter/material.dart';

import 'Util/globals.dart';
import 'card_samples.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Logo Colors
  static const _darkRed = Color(0xFFAD2300);
  static const _orange = Color(0xFFE14B00);
  static const _brightOrange = Color(0xFFFF6600);
  // static const _brightRed = Color(0xFFd50000);
  static const _darkBlue = Color(0xFF00286c);
  // static const _reddishBrown = Color(0xFF330000);

  // Additional Colors
  static const _brightOrangeAlt = Color(0xFFf39c12);

  @override
  Widget build(BuildContext context) {
    final ColorScheme audrigaSchemeLight = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: _orange,
      primary: _orange,
      secondary: _darkRed,
    );

    final ColorScheme audrigaSchemeDark = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _darkBlue,
      primary: _brightOrange,
      secondary: _brightOrangeAlt,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Rajdhani',
        colorScheme: audrigaSchemeLight,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Rajdhani',
        colorScheme: audrigaSchemeDark,
        useMaterial3: true,
      ),
      home: const CardSamples(),
      scaffoldMessengerKey: snackBarKey,
    );
  }
}
