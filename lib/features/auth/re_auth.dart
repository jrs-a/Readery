import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:readery/features/auth/google_signin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readery/features/auth/signup_page.dart';
import 'package:readery/routing/screens/home_page.dart';

/*
  Login() -> wait for init and call login form after
  LoginScreen() -> login form go to the root page

  login credentials for testing
    email: test@hotmail.com
    password: test123
*/

/* CLASS LOGIN: is called on logging in to init firebase and show
  loading before the actual login form is shown */
class ReAuth extends StatefulWidget {
  const ReAuth({super.key});

  @override
  State<ReAuth> createState() => _ReAuthState();
}

class _ReAuthState extends State<ReAuth> {
  //initializing firebase
  Future<FirebaseApp> _initiliazeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initiliazeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const ReAuthScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

//CLASS ReAuthSCREEN: the actual ReAuth form and function
class ReAuthScreen extends StatefulWidget {
  const ReAuthScreen({super.key});

  @override
  State<ReAuthScreen> createState() => _ReAuthScreenState();
}

class _ReAuthScreenState extends State<ReAuthScreen> {
  static Future<User?> loginAttempt(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (email == "" || password == "") {
        widgetSnackbar(context, 'Please fill all fields');
      } else if (e.code == 'invalid-email') {
        widgetSnackbar(context, 'Invalid email');
      } else if (e.code == 'user-not-found') {
        widgetSnackbar(context, 'User not found');
      } else if (e.code == 'wrong-password') {
        widgetSnackbar(context, 'Wrong password');
      } else {
        widgetSnackbar(context, e.code);
      }
    }
    return user;
  }

  static void widgetSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //controllers
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Future<void> deleteUser(String? email, String? userId) async {
      try {
        await firebaseAuth.currentUser?.delete();

        QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
            .collection('ReadingList')
            .where('UserId', isEqualTo: userId)
            .get();

        for (QueryDocumentSnapshot docSnapshot in querySnapshot1.docs) {
          await docSnapshot.reference.delete();
        }

        QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
            .collection('UserData')
            .where('UserId', isEqualTo: userId)
            .get();

        for (QueryDocumentSnapshot docSnapshot in querySnapshot2.docs) {
          await docSnapshot.reference.delete();
        }

        print("[INFO MESSAGE HERE] user deleted succesfully!");
      } catch (e) {
        print('[ERROR MESSAGE HERE] $e');
      }
    }

    return Container(
      height: double.infinity,
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
      child: SingleChildScrollView(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              Text('Log in again to confirm account deletion',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email")),
              const SizedBox(height: 8),
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Password")),
              const SizedBox(height: 16.0),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () async {
                        // await user?.reauthenticateWithCredential(credential);

                        User? user = await loginAttempt(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context);
                        print(user);
                        if (!mounted) return;
                        if (user != null) {
                          //TODO HERE
                          deleteUser(user.email!, user.uid).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Account deleted successfully'),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  }),
                            ));
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const CheckStatus()),
                              (Route<dynamic> route) => false);
                        }
                      },
                      child: const Text("Confirn Delete Account"))),
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
                            //TODO HERE
                            deleteUser(user.email!, user.uid).then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text('Account deleted successfully'),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            });
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const CheckStatus()),
                                (Route<dynamic> route) => false);
                          }
                        });
                      }))
            ]),
      ),
    );
  }
}
