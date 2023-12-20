import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:readery/features/auth/google_signin.dart';
import 'package:readery/features/auth/login_page.dart';
import 'package:readery/features/auth/edit_page.dart';

import 'user.dart';
/*
  UserProfile() - display profile info and logout btn
*/

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('https://iili.io/HS3WOQe.jpg')),
              ),
              child: Stack(children: [
                AppBar(backgroundColor: Colors.transparent, actions: [
                  IconButton(
                      icon: const Icon(Icons.more_horiz_rounded),
                      onPressed: () {
                        widgetShowModal(context);
                      })
                ])
              ]))),
      body: Container(
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Text(
            // getUserData().toString(),
            // '${user?.displayName!}',
            // style: Theme.of(context).textTheme.headlineLarge,
            // style: Theme.of(context).textTheme.labelSmall),
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EditProfilePage()));
              },
              child: const Text('EDIT PROFILE'),
            )
          ]),
          // Text('Email: ${user?.email!}'),
          // Text('ID: ${user?.uid}'),
        ]),
      ),
    );
  }

  void widgetShowModal(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.only(
                  top: 32, bottom: 32, right: 30, left: 30),
              child: FilledButton(
                onPressed: () async {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  await provider.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false);
                },
                child: const Text('Log out'),
              ));
        });
  }
}
