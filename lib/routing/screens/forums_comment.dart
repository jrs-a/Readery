import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readery/features/read%20data/get_comments.dart';
import 'package:readery/routing/screens/create_comment.dart';
import 'package:readery/routing/screens/my_forum.dart';

/*

NOTE: since Forum document id is == comment document id, we can just get forum documentid of list tile
REPLACE DOC ID OF COMMENTS WITH ForumDocId refer to NOTE

Firebase structure: 
Comments(parent collection) -> ForumDocId(parent document) -> comments(sub collection) -> commentDocId -> Field data
New functions:
AddCommentIdToUserData() -> adds the commentDocId into user data *can be removed but used for verification*
Create_AddComment() -> creates and adds comment and userId into the 'Comment' collection and adds the commentDocId into the userdata
findDoc_Comment() -> finds the docID of the Comment corresponding with the UserID of the current user *similar to findDocId_UD && findDocId_RL*
findDocId_UD -> finds the docID of UserData corresponding wih the userID
findSubDoc -> finds the subcollection of the parent document *ForumDocID*
getDisplayName() -> gets the display name corresponding to the userID
getComment() -> gets the comment corresponding to the userID

Goals:
- Get display name and comment - done
- Create a comment and add it inside the subcollection 'comments' -done
- Add the newly created comment id into user data - done
- update/edit comment function -done
- delete comment function -done
- display comment function -done


*/

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreen();
}

User? user = FirebaseAuth.instance.currentUser;
String? uid = user?.uid;

class _CommentsScreen extends State<CommentsScreen> {
  List<String> docIDs = [];

  Future<dynamic> getDisplayName(DocumentReference ref, String field) async {
    DocumentSnapshot snapshot = await ref.get();
    return snapshot.get(field);
  }

  Future getDocId() async {
    final collectionRef = FirebaseFirestore.instance.collection('Comments');
    final subColRef = collectionRef
        .doc('OgVcCaTeqyic7I0BSH2x') //replace this w referenced doc id btw
        .collection('comments');

    await subColRef.get().then((snapshot) => snapshot.docs.forEach((doc) {
          docIDs.add(doc.id);
          print('Found document with ${doc.id}');
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment Page'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateComment()));
            },
            child: const Icon(Icons.add),
          ),
          GestureDetector(
            onTap: () {},
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
                      title: GetCommentData(documentId: docIDs[index]),
                      //subtitle: Text(name),
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
  CollectionReference usersRef = FirebaseFirestore.instance.collection(colpath);
  DocumentReference userDocRef = usersRef.doc(doc_Rlist);

  userDocRef.update({
    'commentsId': FieldValue.arrayUnion([docId])
  });

  if (docId == null) {
    return 'null';
  }

  return docId;
}

Future<List<String>> findDoc_Comment(
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

Future<String?> findSubDoc(String collectionPath, String subColPath,
    String field, dynamic value) async {
  final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
  final subColRef =
      collectionRef.doc('OgVcCaTeqyic7I0BSH2x').collection(subColPath);

  final snapshot = await subColRef.get();
  for (final doc in snapshot.docs) {
    final fieldValue = doc.data()[field];

    if (fieldValue == value) {
      print(
          'Found document with $field on the subcollection $subColPath the value is $value: ${doc.id}');
      return doc.id;
    }
  }
  print('Could not find any document with the $field and value of $value');
  return null;
}

Future<dynamic> getDisplayName(DocumentReference ref, String field) async {
  DocumentSnapshot snapshot = await ref.get();
  return snapshot.get(field);
}

Future<dynamic> getComment(DocumentReference parentRef,
    String subcollectionName, String? subdocumentId, String field) async {
  DocumentSnapshot subdocumentSnapshot =
      await parentRef.collection(subcollectionName).doc(subdocumentId).get();
  return subdocumentSnapshot.get(field);
}
