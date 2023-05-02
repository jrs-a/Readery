import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readery/features/read%20data/get_forum_data.dart';
import 'package:readery/features/forums/create_forum.dart';
import 'package:readery/features/forums/my_forum.dart';
import 'package:readery/features/forums/forums_comment.dart';

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
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
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
                      return Card(
                        child: ListTile(
                          title: GetForumData(documentId: docIDs[index]),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CommentsScreen()));
                          },
                        ),
                      );
                    },
                  );
                }),
              ))
            ],
          ))),
    );
  }
}
