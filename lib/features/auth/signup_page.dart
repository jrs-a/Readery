import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readery/features/auth/login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

/*
reusableTextField() -> A reusable textfield function w decorations and style
signupbutton() > a signup button function w decorations and style


### WHATS NEW ###
FirebaseAuthentication create user - works

### Error ### but the app can run
Overflowing pixels in the layout, since u will redo the design just add the function creatuser function on line 68 - 77

*/

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Username", Icons.person_outline, false, usernameController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Email", Icons.person_outline, false, emailController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Password", Icons.lock_outline, true, passwordController),
              const SizedBox(
                height: 20,
              ),
              signUpbutton(context, false, () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                }).onError((error, stackTrace) {
                  print("Error ${(error).toString()}");
                });
              })
            ]),
          ),
        ),
      ),
    );
  }

  TextField reusableTextField(String text, IconData icon, bool isPasswordType,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white70,
          ),
          labelText: text,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }

  Container signUpbutton(BuildContext context, bool isLogin, Function ontap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          ontap();
        },
        child: Text(
          isLogin ? 'LOG IN' : 'SIGN UP',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
      ),
    );
  }
}
