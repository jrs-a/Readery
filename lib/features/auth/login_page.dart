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
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            return const LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

//CLASS LOGINSCREEN: the actual login form and function
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

    return Container(
      height: double.infinity,
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
      child: SingleChildScrollView(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                  height: 350, child: Image.asset('assets/images/hello.png')),
              Text('Welcome back!',
                  textAlign: TextAlign.center,
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
                        User? user = await loginAttempt(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context);
                        print(user);
                        if (!mounted) return;
                        if (user != null) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const CheckStatus()),
                              (Route<dynamic> route) => false);
                        }
                      },
                      child: const Text("Login"))),
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
              signUpOption()
            ]),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account?"),
        TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignupPage()));
          },
          child: const Text("Sign up"),
        )
      ],
    );
  }
}
