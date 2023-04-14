import 'package:flutter/material.dart';
import 'package:readery/constants/colors.dart';
import 'package:readery/routing/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Readery',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme, //toggle for light-dark modes
        scaffoldBackgroundColor: Theme.of(context).colorScheme.background,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OnboardingScreen(),
    );
  }
}
