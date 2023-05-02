import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetReadingListName extends StatelessWidget {
  final String documentId;

  GetReadingListName({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference readingList =
        FirebaseFirestore.instance.collection('ReadingList');

    return FutureBuilder<DocumentSnapshot>(
      future: readingList.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          return Text('${data['name']}');
        }
        return Text('Loading...');
      },
    );
  }
}
