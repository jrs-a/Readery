import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:readery/features/auth/login_page.dart';

import 're_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var newUnameController = TextEditingController();
  var curPassController = TextEditingController();
  var newPassController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

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
                    actions: [widgetButtonSave(context)])
              ]))),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        // padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            const SizedBox(height: 130),
            Text('Edit Profile',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 32),
            TextFormField(
                controller: newUnameController,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edit Profile',
                )),
            const SizedBox(height: 8),
            reusableTextField("Current Password", true, curPassController),
            const SizedBox(height: 8),
            reusableTextField("New Password", true, newPassController),
            const SizedBox(height: 16),
            // FilledButton.tonal(
            //     onPressed: () {
            //       newUnameController.clear();
            //       newPassController.clear();
            //       curPassController.clear();
            //     },
            //     child: const Text('Reset Fields')),
            const SizedBox(height: 120),
            TextButton(
                onPressed: () {
                  widgetShowModal(context);
                },
                child: const Text('DELETE ACCOUNT')),
          ]),
        ),
      ),
    );
  }

  void widgetShowModal(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Wrap(children: [
            Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Center(
                    child: Column(children: [
                  const Text('Are you sure to delete your account?'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      widgetSnackbar(context, false,
                          'Sign in again to confirm account deletion');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReAuth()));
                    },
                    child: const Text('Yes, proceed to deletion'),
                  )
                ])))
          ]);
        });
  }

  TextButton widgetButtonSave(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return TextButton(
        onPressed: () async {
          if (newUnameController.value.text.isNotEmpty) {
            try {
              await db
                  .collection('UserData')
                  .doc(user?.uid)
                  .set({"displayName": newUnameController.text});
              if (!mounted) return;
              widgetSnackbar(context, true, 'Username change success');
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          }
          if (curPassController.value.text.isNotEmpty &&
              newPassController.value.text.isNotEmpty) {
            print(curPassController.text);
            print(newPassController.text);
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: FirebaseAuth.instance.currentUser!.email!,
                  password: curPassController.text);
            } on FirebaseAuthException {
              widgetSnackbar(context, false,
                  'Current password is incorrect. Please try again.');
              return;
            }

            try {
              await FirebaseAuth.instance.currentUser!
                  .updatePassword(newPassController.text);
            } on FirebaseAuthException {
              widgetSnackbar(
                  context, false, 'New password is weak. Please try again.');
              return;
            }

            if (!mounted) return;
            widgetSnackbar(context, true, 'Password change success');
          }
        },
        child: const Text('SAVE'));
  }

  void widgetSnackbar(BuildContext context, bool success, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            if (success == true) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
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
