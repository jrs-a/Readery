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
    final subColRef =
        collectionRef.doc('OgVcCaTeqyic7I0BSH2x').collection('comments');

    return FutureBuilder<DocumentSnapshot>(
      future: subColRef.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          return Text('${data['username']} \n - ${data['comment']}');
        }
        return Text('Loading...');
      },
    );
  }
}
