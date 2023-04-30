import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetMyForum extends StatelessWidget {
  final String documentId;

  GetMyForum({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference readingList =
        FirebaseFirestore.instance.collection('Forum');

    return FutureBuilder<DocumentSnapshot>(
      future: readingList.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          return Text('${data['Title']}');
        }
        return Text('Loading...');
      },
    );
  }
}
