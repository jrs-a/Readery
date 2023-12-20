import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ListNovels extends StatefulWidget {
  const ListNovels({super.key, this.docId});
  final docId;

  @override
  State<ListNovels> createState() => _ListNovelsState();
}

class _ListNovelsState extends State<ListNovels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(widget.docId)));
  }
}
