import 'package:flutter/material.dart';

import 'Util/globals.dart';
import 'card_samples.dart';

void main() {
  runApp(const CardsExampleApp());
}


// Logo Colors
const _darkRed = Color(0xFFAD2300);
const _orange = Color(0xFFE14B00);
const _brightOrange = Color(0xFFFF6600);
// static const _brightRed = Color(0xFFd50000);
const _darkBlue = Color(0xFF00286c);
// static const _reddishBrown = Color(0xFF330000);

// Additional Colors
const _brightOrangeAlt = Color(0xFFf39c12);


class CardsExampleApp extends StatefulWidget {
  const CardsExampleApp({super.key});

  @override
  State<CardsExampleApp> createState() => _CardsExampleAppState();
}

class _CardsExampleAppState extends State<CardsExampleApp> {
  ThemeMode themeMode = ThemeMode.system;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

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
  @override
  Widget build(BuildContext context) {


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
      themeMode: themeMode,
      home: CardSamples(handleBrightnessChange: handleBrightnessChange,),
      scaffoldMessengerKey: snackBarKey,
    );
  }
}
