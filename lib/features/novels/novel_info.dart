import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readery/features/novels/novel.dart';

class NovelInfo extends StatelessWidget {
  final int novelId;

  const NovelInfo(this.novelId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Column(children: [
      //   Text('show here the $novelId'),
      // ]),
      body: FutureBuilder<Novel?>(
          future: readNovel(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final novel = snapshot.data;
              return novel == null
                  ? const Center(child: Text('no novel found'))
                  : buildNovel(novel);
            } else {
              return const Center(child: Text('loading . . .'));
            }
          }),
    );
  }

  Future<Novel?> readNovel() async {
    final docNovel =
        FirebaseFirestore.instance.collection('Novel').doc(novelId.toString());
    final snapshot = await docNovel.get();

    if (snapshot.exists) {
      return Novel.fromJson(snapshot.data()!);
    }
  }

  Widget buildNovel(Novel novel) => ListTile(
      // leading: CircleAvatar(),  TODO: display img here later
      title: Text(novel.title),
      subtitle: Text(novel.author));
}
