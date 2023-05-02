import 'package:flutter/material.dart';

class ReadChapter extends StatefulWidget {
  const ReadChapter(
      {super.key, required this.chapterTitle, required this.chapterBody});

  final String chapterTitle;
  final String chapterBody;

  @override
  State<ReadChapter> createState() => _ReadChapterState();
}

class _ReadChapterState extends State<ReadChapter> {
  double progressValue = 0.0;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      progressValue =
          scrollController.offset / scrollController.position.maxScrollExtent;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: LinearProgressIndicator(value: progressValue),
              ))),
      body: Container(
          color: Theme.of(context).colorScheme.background,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 30, left: 24, right: 24),
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 24, top: 24),
                      child: Text(widget.chapterTitle,
                          style: Theme.of(context).textTheme.titleLarge)),
                  Text(widget.chapterBody,
                      style: Theme.of(context).textTheme.bodyMedium)
                ])),
          )),
    );
  }
}
