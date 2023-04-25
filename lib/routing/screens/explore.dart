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
  // final queryNovel = FirebaseFirestore.instance.collection('Novel');
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      // child: FirestoreQueryBuilder<Novel>(
      //   query: queryNovel,
      //   pageSize: 5,
      //   builder: (context, snapshot, _) {
      //     if (snapshot.hasError) {
      //       return Text('Something went wrong! ${snapshot.error}');
      //     } else if (snapshot.hasData) {
      //       // final List<Novel> novels = snapshot.data!;
      //       return GridView.builder(
      //         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //             maxCrossAxisExtent: 150,
      //             childAspectRatio: 1 / 2,
      //             mainAxisSpacing: 8,
      //             crossAxisSpacing: 8),
      //         itemCount: snapshot.docs.length,
      //         itemBuilder: (context, index) {
      //           // return novels.map(buildNovels).toList()[index];
      //           final novel = snapshot.docs[index].data();
      //           return buildNovels(novel);
      //         },
      //       );
      //     } else {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      child: StreamBuilder<List<Novel>>(
          stream: readNovels(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final List<Novel> novels = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    childAspectRatio: 1 / 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return novels.map(buildNovels).toList()[index];
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          })),
    );
  }

  Stream<List<Novel>> readNovels() => FirebaseFirestore.instance
      .collection('Novel')
      .snapshots() //get the documents in a firebase collection
      .map((snapshot) => snapshot.docs
          .map<Novel>((doc) => Novel.fromJson(doc.data()))
          .toList());

  Widget buildNovels(Novel novel) => GridTile(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NovelInfo(novel.novelId)));
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
                  child: Image.network(novel.coverUrl,
                      fit: BoxFit.cover, height: 185)),
              Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          height: 1.15,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      novel.title))
            ]),
          ),
        ),
      );
}
