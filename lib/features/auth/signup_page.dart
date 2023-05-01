import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readery/routing/screens/home_page.dart';

import 'google_signin.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

/*
reusableTextField() -> A reusable textfield function w decorations and style
signupbutton() > a signup button function w decorations and style


### WHATS NEW ###
FirebaseAuthentication create user - works

### Error ### but the app can run
Overflowing pixels in the layout, 
since u will redo the design just add the ,
function creatuser function on line 68 - 77

*/

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: Container(
              padding: const EdgeInsets.all(16),
              child: Stack(children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  scrolledUnderElevation: 0,
                  surfaceTintColor: Colors.transparent,
                )
              ]))),
      body: Container(
        height: double.infinity,
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
        child: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Image.asset('assets/images/cat.png')),
                Text('Create a new account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                reusableTextField("Username", false, usernameController),
                const SizedBox(height: 8),
                reusableTextField("Email", false, emailController),
                const SizedBox(height: 8),
                reusableTextField("Password", true, passwordController),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .whenComplete(() async {
                            final user = FirebaseAuth.instance.currentUser;
                            await db
                                .collection('UserData')
                                .doc(user?.uid.toString())
                                .set({
                              "displayName": usernameController.text,
                              "forumIds": ["0"],
                              "isAdmin": false,
                              "readingListsId": ["0"]
                            });
                            widgetSnackbar(
                                context,
                                'Sign up success! Please proceed to login',
                                () => Navigator.pop(context));
                          });
                        } on FirebaseAuthException catch (e) {
                          widgetSnackbar(context, e.toString(), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text('Sign up')),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.google,
                            color: Colors.red, size: 16),
                        label: const Text('Sign in with Google'),
                        onPressed: () async {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          await provider.googleLogin().whenComplete(() {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const CheckStatus()),
                                  (Route<dynamic> route) => false);
                            }
                          });
                        })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Log in"),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }

  void widgetSnackbar(BuildContext context, String message, Function ontap) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ontap();
          }),
    ));
  }

  TextFormField reusableTextField(
      String text, bool isPasswordType, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        obscureText: isPasswordType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: text,
        ),
        keyboardType: isPasswordType
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress);
  }
}
