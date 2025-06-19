import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digital_addressing_app/screens/login/login_screen.dart';
import 'package:digital_addressing_app/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(ThemeMode.light), // Default to light mode
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Apple's signature blue color
    const appleBlue = Color(0xFF0A84FF); // Updated to the vibrant iOS blue

    // --- LIGHT THEME DEFINITION ---
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: appleBlue,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(color: appleBlue),
      ),
      colorScheme: const ColorScheme.light(primary: appleBlue, secondary: appleBlue, background: CupertinoColors.systemGroupedBackground),
    );

    // --- DARK THEME DEFINITION ---
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: appleBlue,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: Colors.black, // True black for OLED screens
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(color: appleBlue),
      ),
      colorScheme: const ColorScheme.dark(primary: appleBlue, secondary: appleBlue, background: Colors.black, surface: CupertinoColors.darkBackgroundGray),
    );

    // Use the provider to listen for theme changes
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Digital Addressing System',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.themeMode, // This line does the magic!
      home: const LoginScreen(),
    );
  }
}