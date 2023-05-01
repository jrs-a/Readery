import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
  GoogleSignInProvider class
  googleLogin() - google login functionality
  signOut() - sigout functionality
*/

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!; //getting user

  //google login function
  Future googleLogin() async {
    try {
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

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() async {
        await db
            .collection('UserData')
            .doc(auth.currentUser?.uid)
            .set({"displayName": _user?.email});
      });
    } catch (e) {
      print(e.toString());
    }

    notifyListeners(); //update the UI
  }

  Future<void> signOut() async {
    if (googleSignIn.currentUser != null) {
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    } else {
      await FirebaseAuth.instance.signOut();
    }
  }
}
