import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readery/features/novels/chapter_view.dart';
import 'package:readery/features/novels/novel.dart';

import 'chapter.dart';

class NovelInfo extends StatelessWidget {
  final int novelId;
  final ScrollController _controller = ScrollController();
  NovelInfo(this.novelId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Novel?>(
          future: readNovel(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final novel = snapshot.data;
              final queryChapters = FirebaseFirestore.instance
                  .collection('Chapter')
                  .where('novelId', isEqualTo: novel?.novelId)
                  .orderBy('chapterIndex')
                  .withConverter(
                      fromFirestore: (snapshot, _) =>
                          Chapter.fromMap(snapshot.data()!),
                      toFirestore: (chapter, _) => chapter.toMap());
              return novel == null
                  ? const Center(child: Text('no novel found'))
                  : buildNovel(novel, context, queryChapters);
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

  Widget buildNovel(novel, context, queryChapters) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.playlist_add),
            label: const Text('Add to list'),
            onPressed: null),
        // child: ListView(controller: _controller, children: [
        body: Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.only(top: 30, right: 24, left: 24),
            child: Column(children: [
              Container(
                  margin: const EdgeInsets.only(top: 32, bottom: 16),
                  child: widgetInfoSection(novel, context)),
              Column(children: [
                const Divider(),
                widgetSectionHeader(context, 'Description'),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(novel.description.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      child: const Text('show more...'),
                      onPressed: () {
                        widgetModalDesc(context, novel);
                      }),
                ),
                const Divider(),
                widgetSectionHeader(context, 'Chapters'),
                SizedBox(
                    height: 345,
                    child: widgetChaptersSection(context, queryChapters)),
              ]),
            ])),
      );

  MediaQuery widgetChaptersSection(context, queryChapters) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: FirestoreListView<Chapter>(
          query: queryChapters,
          itemBuilder: (context, snapshot) {
            final chapter = snapshot.data();
            return Card(
                child: ListTile(
                    title: Text(chapter.chapterTitle),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReadChapter(
                                  chapterTitle: chapter.chapterTitle,
                                  chapterBody: chapter.chapterBody)));
                    }));
          }),
    );
  }

  Container widgetSectionHeader(context, text) {
    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall!.merge(
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ));
  }

  Row widgetInfoSection(novel, context) {
    return Row(children: [
      Container(
          margin: const EdgeInsets.only(right: 8),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(novel.coverUrl,
                  fit: BoxFit.cover, height: 200))),
      Expanded(
          child: Container(
        height: 200,
        alignment: Alignment.topLeft,
        child: Column(children: [
          Container(
              margin: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.topLeft,
              child: Text(
                novel.title,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              )),
          Container(
              margin: const EdgeInsets.only(bottom: 4),
              alignment: Alignment.topLeft,
              child: Text('Author: ${novel.author}',
                  style: Theme.of(context).textTheme.bodyMedium)),
          Container(
              alignment: Alignment.topLeft,
              child: Text('Status: ${novel.status}',
                  style: Theme.of(context).textTheme.bodyMedium))
        ]),
      ))
    ]);
  }

  void widgetModalDesc(context, novel) {
    showModalBottomSheet<void>(
        context: context,
        // isScrollControlled: true,
        builder: (_) {
          return DraggableScrollableSheet(
              expand: false,
              builder: (_, controller) {
                return Container(
                    padding: const EdgeInsets.only(
                        top: 32, bottom: 32, right: 30, left: 30),
                    child: SingleChildScrollView(
                        controller: controller,
                        child: Column(children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Text('Description',
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          Text(
                            novel.description.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ])));
              });
        });
  }
}
