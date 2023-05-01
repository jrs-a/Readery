import 'dart:ui';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
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

//addListToUserData() -> Adds the reading list to user data
//findDocId_UD() -> find user data document id
//findDocId_RL() -> finds reading list document id
// AddList() -> adds the reading list w their own unique id and current userID, also adds input reading list name

class _CreateReadingListPage extends State<CreateReadingListPage> {
  TextEditingController r_listName = TextEditingController();
  final queryNovel = FirebaseFirestore.instance.collection('Novel');
  List<String> novelsList = [];

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
                    actions: [widgetButtonCreateList(context)],
                  )
                ]))),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Text('Create a reading list',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: reusableTextField(
                      "Reading List Name", false, r_listName)),
              const SizedBox(height: 32),
              MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: FirestoreQueryBuilder<Map<String, dynamic>>(
                      query: queryNovel,
                      pageSize: 10,
                      builder: (context, snapshot, _) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong! ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return (GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    childAspectRatio: 1 / 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8),
                            itemBuilder: (context, index) {
                              if (index + 1 == snapshot.docs.length) {
                                debugPrint(snapshot.docs.length.toString());
                              }
                              if (snapshot.hasMore &&
                                  index + 1 == snapshot.docs.length) {
                                snapshot.fetchMore();
                              }
                              final novel = snapshot.docs[index].data();
                              return buildNovels(novel, index);
                            },
                          ));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })),
              const SizedBox(height: 60),
            ],
          ),
        ));
  }

  Widget buildNovels(novel, int index) => GridTile(
        child: InkWell(
          onTap: () {
            setState(() {
              if (!novelsList.contains(novel['novelId'].toString())) {
                novelsList.add(novel['novelId'].toString());
              } else {
                novelsList.remove(novel['novelId'].toString());
              }
            });
            print(novelsList);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.outlineVariant)),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity:
                  novelsList.contains(novel['novelId'].toString()) ? 0.2 : 1,
              child: Column(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(novel['coverUrl'],
                        fit: BoxFit.cover, height: 180)),
                Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                        '${novel['title']}'))
              ]),
            ),
          ),
        ),
      );
  TextButton widgetButtonCreateList(BuildContext context) {
    return TextButton(
        onPressed: () async {
          final docId_rList = await findDocID_RL('ReadingList', 'UserId', uid);
          // final docId = await findDocId_UD('UserData', 'UserId', uid);

          if (docId != null) {
            addListToUserData(docId_rList, docId, 'UserData');
            AddList(r_listName.text, docId, 'UserData');
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LibraryPage()));
          } else if (docId != uid) {
            print("Error userid does not exist");
          } else {
            print('Error');
          }
        },
        child: const Text('CREATE LIST'));
  }

//create  user
  Future addListToUserData(
      List<String> inputList, docId, String collectionPath) async {
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

// Future<String?> findDocId_UD(
//     String collectionPath, String field, dynamic value) async {
//   final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
//   final snapshot = await collectionRef.get();

//   for (final doc in snapshot.docs) {
//     final fieldValue = doc.data()[field];

//     if (fieldValue == value) {
//       print('Found document with $field the value is $value: ${doc.id}');
//       return doc.id;
//     }
//   }
//   print('Could not find any document with the $field and value of $value');
//   return null;
// }

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

TextFormField reusableTextField(
    String text, bool isPasswordType, TextEditingController controller) {
  return TextFormField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress);
}

void widgetSnackbar(BuildContext context, bool success, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          if (success == true) {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        }),
  ));
}
