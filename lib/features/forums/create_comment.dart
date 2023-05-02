import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readery/features/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readery/features/auth/user_profile.dart';

class CreateComment extends StatefulWidget {
  const CreateComment({super.key});

  @override
  State<CreateComment> createState() => _CreateComment();
}

User? user = FirebaseAuth.instance.currentUser;
String? uid = user?.uid;

class _CreateComment extends State<CreateComment> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Create Comment",
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
                  "Title", Icons.person_outline, false, inputController),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final docref_ud =
                        await findDocId_UD('UserData', 'UserId', uid);
                    Create_AddComment(
                        inputController.text, docref_ud, 'UserData');
                    print("Added Succesfully");
                  },
                  child: const Text('Create')),
              ElevatedButton(
                  onPressed: () {
                    inputController.clear();
                  },
                  child: const Text('Reset'))
            ]),
          ),
        ),
      ),
    );
  }

//createComment
  Future AddCommentIdToUserData(
      List<String> inputList, String? docId, String collectionPath) async {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    final documentRef = collectionRef.doc(docId);
    final snapshot = await documentRef.get();

    final List<dynamic> currentValues = snapshot.data()?['commentsId'] ?? [];

    for (var input in inputList) {
      if (currentValues.contains(input)) {
        print('$input already exist!');
        return;
      }
      await documentRef.update({
        'commentsId': FieldValue.arrayUnion([input])
      });
      print('my input is $input');
    }
  }

  Future<dynamic> getDisplayName(DocumentReference ref, String field) async {
    DocumentSnapshot snapshot = await ref.get();
    return snapshot.get(field);
  }

  Future<String> Create_AddComment(
      String input, String? doc_Rlist, String colpath) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference newInputsCollection = firestore.collection('Comments');
    final parentDocument = newInputsCollection
        .doc('OgVcCaTeqyic7I0BSH2x'); //replace this with forum document id

    final newDocRef = parentDocument.collection('comments');

    final docref_ud = await findDocId_UD('UserData', 'UserId', uid);
    DocumentReference ref =
        FirebaseFirestore.instance.collection('UserData').doc(docref_ud);
    final d_name = await getDisplayName(ref, 'displayName');

    DocumentReference newInputRef = await newDocRef.add({
      'comment': input,
      'UserId': uid,
      'username': d_name,
      'createdAt': FieldValue.serverTimestamp(),
    });

    String docId = newInputRef.id;
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection(colpath);
    DocumentReference userDocRef = usersRef.doc(doc_Rlist);

    userDocRef.update({
      'commentsId': FieldValue.arrayUnion([docId])
    });

    if (docId == null) {
      return 'null';
    }

    return docId;
  }

  Future<String?> findDocId_UD(
      String collectionPath, String field, dynamic value) async {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    final snapshot = await collectionRef.get();

    for (final doc in snapshot.docs) {
      final fieldValue = doc.data()[field];

      if (fieldValue == value) {
        print('Found document with $field the value is $value: ${doc.id}');
        return doc.id;
      }
    }
    print('Could not find any document with the $field and value of $value');
    return null;
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
