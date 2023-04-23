import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readery/constants/colors.dart';
import 'package:readery/features/auth/google_signin.dart';
import 'package:readery/features/auth/user_profile.dart';
import 'package:readery/routing/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:readery/routing/screens/home_page.dart';

import 'features/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Readery',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme, //toggle for light-dark modes
            scaffoldBackgroundColor: Theme.of(context).colorScheme.background,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const CheckStatus(),
        ),
      );
}
