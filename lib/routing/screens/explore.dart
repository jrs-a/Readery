import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
                "Explore Novels",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        )));
  }
}
