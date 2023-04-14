import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 60),
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SizedBox.expand(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Your Library",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        )));
  }
}

