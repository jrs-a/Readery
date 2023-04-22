import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!; //getting user

  //google login function
  Future googleLogin() async {
    final googleUser =
        await googleSignIn.signIn(); //prompt google accounts window
    if (googleUser == null) return; //making sure user selected an account
    _user = googleUser; //saving user account on user field

    final googleAuth = await googleUser.authentication; //awaiting information

    final credential = GoogleAuthProvider.credential(
      //getting credentials and id
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners(); //update the UI
  }
}
