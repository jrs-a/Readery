import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//collection references
final CollectionReference libraryCollection =
    FirebaseFirestore.instance.collection('ReadingList');
final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('UserData');
//userID
User? user = FirebaseAuth.instance.currentUser;
String? uid = user?.uid;

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

//Getting docID if is uid is equal to UserID field
//---note--- I failed to make this work

/*Future<String> getDocId(String uid) async {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('UserData');
  QuerySnapshot querySnapshot =
      await usersCollection.where(uid, isEqualTo: 'UserId').get();

  querySnapshot.docs.forEach((doc) {
    String documentId = doc.id;
  });
  return;
}*/

Future<String> getuid(String documentId) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('UserData')
      .doc(documentId)
      .get();
  String r_uid = snapshot.get('UserId');
  return r_uid;
}

class _LibraryPageState extends State<LibraryPage> {
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 60),
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SizedBox.expand(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Your Library",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: () async {
                  addNoveltoList(uid, 'one Piece');
                },
                child: const Text('Add novel to list'))
          ],
        )));
  }
}

Future<void> addNoveltoList(String? userId, String novel) async {
  DocumentReference userDoc =
      libraryCollection.doc('seVqX9wmIVFi4RKyvfdC'); //change it to document id

  return userDoc
      .update({
        'Novels': FieldValue.arrayUnion([novel])
      })
      .then((value) => print('novel added to list'))
      .catchError((error) => print('Failed to novel: $error'));
}
