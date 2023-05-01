import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetCommentData extends StatelessWidget {
  final String documentId;

  GetCommentData({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Comments');

    return FutureBuilder<DocumentSnapshot>(
      future: collectionRef.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          return Text('${data['comment']}');
        }
        return Text('Loading...');
      },
    );
  }
}
