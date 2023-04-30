import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readery/features/novels/novel.dart';
import 'package:readery/features/novels/novel_info.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final queryNovel = FirebaseFirestore.instance.collection('Novel');
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: FirestoreQueryBuilder<Map<String, dynamic>>(
          query: queryNovel,
          pageSize: 20,
          builder: (context, snapshot, _) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.docs.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    childAspectRatio: 1 / 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  if (index + 1 == snapshot.docs.length) {
                    debugPrint(snapshot.docs.length.toString());
                  }
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    snapshot.fetchMore();
                  }
                  final novel = snapshot.docs[index].data();
                  return buildNovels(novel);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Stream<List<Novel>> readNovels() => FirebaseFirestore.instance
      .collection('Novel')
      .snapshots() //get the documents in a firebase collection
      .map((snapshot) => snapshot.docs
          .map<Novel>((doc) => Novel.fromJson(doc.data()))
          .toList());

  Widget buildNovels(dynamic novel) => GridTile(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NovelInfo(novel['novelId'])));
          },
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.outlineVariant)),
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
      );
}
