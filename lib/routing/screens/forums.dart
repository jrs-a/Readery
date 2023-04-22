import 'package:flutter/material.dart';

class ForumsPage extends StatefulWidget {
  const ForumsPage({Key? key}) : super(key: key);

  @override
  State<ForumsPage> createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> {
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
                "My Forums",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        )));
  }
}
