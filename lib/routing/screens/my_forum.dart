import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readery/features/read%20data/get_myforum.dart';
import 'package:readery/routing/screens/create_rlist.dart';
import 'package:readery/routing/screens/up_del_myforum.dart';

//collection references
final CollectionReference libraryCollection =
    FirebaseFirestore.instance.collection('Forum');

//userID
User? user = FirebaseAuth.instance.currentUser;
String? uid = user?.uid;

class MyForum extends StatefulWidget {
  const MyForum({Key? key}) : super(key: key);

  @override
  State<MyForum> createState() => _MyForum();
}

class _MyForum extends State<MyForum> {
  List<String> docIDs = [];

  Future getDocId(String field, dynamic value) async {
    await FirebaseFirestore.instance
        .collection('Forum')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              final fieldValue = doc.data()[field];
              if (fieldValue == value) {
                print(
                    'Found document with $field the value is $value: ${doc.id}');
                docIDs.add(doc.id);
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Forums'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: FutureBuilder(
            future: getDocId('UserId', uid),
            builder: ((context, snapshot) {
              return ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: GetMyForum(documentId: docIDs[index]),
                      tileColor: Colors.grey[200],
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditForum()));
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.indigo,
                          ),
                          IconButton(
                            onPressed: () {
                              final docUser = FirebaseFirestore.instance
                                  .collection('Forum')
                                  .doc(
                                      'OgVcCaTeqyic7I0BSH2x'); //replace this w docid variable after referencing

                              docUser.delete();
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ))
        ],
      )),
    );
  }
}
