import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readery/features/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readery/features/auth/user_profile.dart';
import 'package:readery/routing/screens/library.dart';

class CreateReadingListPage extends StatefulWidget {
  const CreateReadingListPage({super.key});

  @override
  State<CreateReadingListPage> createState() => _CreateReadingListPage();
}

User? user = FirebaseAuth.instance.currentUser;
String? uid = user?.uid;

//AddListToUserData() -> Adds the reading list to user data
//findDocId_UD() -> find user data document id
//findDocId_RL() -> finds reading list document id
// AddList() -> adds the reading list w their own unique id and current userID, also adds input reading list name

class _CreateReadingListPage extends State<CreateReadingListPage> {
  TextEditingController r_listName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reading List",
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
                  "Reading List Name", Icons.person_outline, false, r_listName),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final docId_rList =
                        await findDocID_RL('ReadingList', 'UserId', uid);
                    final docId = await findDocId_UD('UserData', 'UserId', uid);

                    if (docId != null) {
                      AddListToUserData(docId_rList, docId, 'UserData');
                      AddList(r_listName.text, docId, 'UserData');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LibraryPage()));
                    } else if (docId != uid) {
                      print("Error userid does not exist");
                    } else {
                      print('Error');
                    }
                  },
                  child: const Text('Add List')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserProfile()));
                  },
                  child: const Text('Return'))
            ]),
          ),
        ),
      ),
    );
  }

//create  user
  Future AddListToUserData(
      List<String> inputList, String docId, String collectionPath) async {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    final documentRef = collectionRef.doc(docId);
    final snapshot = await documentRef.get();

    final List<dynamic> currentValues =
        snapshot.data()?['ReadingListsId'] ?? [];

    for (var input in inputList) {
      if (currentValues.contains(input)) {
        print('$input already exist!');
        return;
      }
      await documentRef.update({
        'ReadingListsId': FieldValue.arrayUnion([input])
      });
      print('my input is $input');
    }
  }
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

Future<List<String>> findDocID_RL(
    String collectionPath, String field, dynamic value) async {
  final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
  final snapshot = await collectionRef.get();
  List<String> _docs = [];

  for (final doc in snapshot.docs) {
    final fieldValue = doc.data()[field];

    if (fieldValue == value) {
      print('Found document with $field the value is $value: ${doc.id}');
      _docs.add(doc.id);
    }
  }
  return _docs;
}

Future<String> AddList(String input, String doc_Rlist, String colpath) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference inputsCollection = firestore.collection('ReadingList');

  DocumentReference newInputRef = await inputsCollection.add({
    'name': input,
    'UserId': uid,
  });
  String docId = newInputRef.id;
  CollectionReference usersRef = FirebaseFirestore.instance.collection(colpath);
  DocumentReference userDocRef = usersRef.doc(doc_Rlist);

  userDocRef.update({
    'ReadingListsId': FieldValue.arrayUnion([docId])
  });

  if (docId == null) {
    return 'null';
  }

  return docId;
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
