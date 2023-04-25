import 'package:flutter/material.dart';
import 'package:readery/features/auth/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:readery/features/auth/login_page.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var newUnameController = TextEditingController();
  var curPassController = TextEditingController();
  var newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Edit Page",
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
              reusableTextField("New Username", Icons.person_outline, false,
                  newUnameController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Current Password", Icons.lock_outline, true,
                  curPassController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "New Password", Icons.lock_outline, true, newPassController),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      newUnameController.clear();
                      newPassController.clear();
                      curPassController.clear();
                    },
                    child: const Text('Reset',
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (newUnameController.value.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance.currentUser!
                              .updateDisplayName(newUnameController.text);
                          if (!mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      }
                      if (curPassController.value.text.isNotEmpty &&
                          newPassController.value.text.isNotEmpty) {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: FirebaseAuth.instance.currentUser!.email!,
                            password: curPassController.text);
                        await FirebaseAuth.instance.currentUser!
                            .updatePassword(newPassController.text);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Update Success')));
                      }
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )
                ],
              )
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
}
