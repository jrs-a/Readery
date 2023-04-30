import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readery/features/read%20data/get_forum_data.dart';
import 'package:readery/routing/screens/create_forum.dart';
import 'package:readery/routing/screens/my_forum.dart';

class ForumsPage extends StatefulWidget {
  const ForumsPage({Key? key}) : super(key: key);

  @override
  State<ForumsPage> createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> {
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('Forum')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              docIDs.add(doc.id);
              print('Found document with ${doc.id}');

              /* specific user
              final fieldValue = doc.data()[field];
              if (fieldValue == value) {
                print(
                    'Found document with $field the value is $value: ${doc.id}');
                docIDs.add(doc.id);
              }
          */
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forums'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreateForum()));
            },
            child: const Icon(Icons.add),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyForum()));
            },
            child: const Icon(Icons.person),
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: FutureBuilder(
            future: getDocId(),
            builder: ((context, snapshot) {
              return ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: GetForumData(documentId: docIDs[index]),
                      tileColor: Colors.grey[200],
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
