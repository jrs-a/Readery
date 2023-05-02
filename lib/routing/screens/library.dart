import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readery/features/read%20data/get_RL_name.dart';
import 'package:readery/routing/screens/create_rlist.dart';
import 'package:readery/routing/screens/update_delete_rlist.dart';

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

class _LibraryPageState extends State<LibraryPage> {
  List<String> docIDs = [];

  Future getDocId(String field, dynamic value) async {
    await FirebaseFirestore.instance
        .collection('ReadingList')
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
                    actions: [
                      OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateReadingListPage()));
                          },
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('New list'))
                    ])
              ]))),
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
                      title: GetReadingListName(documentId: docIDs[index]),
                      tileColor: Colors.grey[200],
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UpdateRlist()));
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.indigo,
                          ),
                          IconButton(
                            onPressed: () {
                              final docUser = FirebaseFirestore.instance
                                  .collection('ReadingList')
                                  .doc(
                                      'tmAI6BniEEK1k1Ns9jhZ'); //replace this w docid variable after referencing

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

Future<void> addNoveltoList(String? userId, String novel) async {
  final docId_rList = await findDocID_RL('ReadingList', 'UserId', uid);
  var docId_RL = docId_rList.toString();

  DocumentReference userDoc =
      libraryCollection.doc(docId_RL); //change it to document id

  return userDoc
      .update({
        'Novels': FieldValue.arrayUnion([novel])
      })
      .then((value) => print('novel added to list'))
      .catchError((error) => print('Failed to novel: $error'));
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
