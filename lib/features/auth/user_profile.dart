import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:readery/features/auth/google_signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readery/features/auth/login_page.dart';
import 'package:readery/features/auth/edit_page.dart';
/*
  UserProfile() - display profile info and logout btn
*/

class UserProfile extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  UserProfile({super.key});

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

      print("user deleted succesfully!");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged In'),
        centerTitle: true,
        actions: [
          TextButton(
            child: const Text('Logout'),
            onPressed: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              await provider.signOut();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Login()));
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blueGrey.shade900,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Profile',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 32),
          // CircleAvatar(
          //   radius: 40,
          //   backgroundImage: NetworkImage(user!.photoURL!),
          // ),
          // const SizedBox(height: 8),
          //Text('Name: ${user?.displayName!}',
          //    style: const TextStyle(color: Colors.white, fontSize: 16)),
          //const SizedBox(height: 8),
          Text('Email: ${user?.email!}',
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text('ID: ${user?.uid}',
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: () {
                deleteUser(user?.email!, user?.uid).then((value) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));
                });
              },
              child: const Text('Delete')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              },
              child: const Text('Edit')),
        ]),
      ),
    );
  }
}
