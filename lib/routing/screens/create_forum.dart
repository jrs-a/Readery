import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readery/features/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readery/features/auth/user_profile.dart';

class CreateForum extends StatefulWidget {
  const CreateForum({super.key});

  @override
  State<CreateForum> createState() => _CreateForum();
}

User? user = FirebaseAuth.instance.currentUser;
String? uid = user?.uid;

//CreateForum() -> creates a new forum

class _CreateForum extends State<CreateForum> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Create Forum",
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
                  "Title", Icons.person_outline, false, titleController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Body", Icons.person_outline, false, bodyController),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    CreateForum(titleController.text, bodyController.text);
                  },
                  child: const Text('Create')),
              ElevatedButton(
                  onPressed: () {
                    titleController.clear();
                    bodyController.clear();
                  },
                  child: const Text('Reset'))
            ]),
          ),
        ),
      ),
    );
  }

//createForum
  Future<String> CreateForum(String title, String body) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference inputsCollection = firestore.collection('Forum');

    DocumentReference newInputRef = await inputsCollection.add({
      'Title': title,
      'Body': body,
      'UserId': uid,
    });
    print("Added Sucessfuly");
    String docId = newInputRef.id;

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
}
