import 'package:flutter/material.dart';
import 'package:readery/routing/screens/explore.dart';
import 'package:readery/routing/screens/forums.dart';
import 'package:readery/routing/screens/home_page.dart';
import 'package:readery/routing/screens/library.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int index = 0;

  List<Widget> pages = const [
    HomePage(),
    ExplorePage(),
    ForumsPage(),
    LibraryPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: index,
        onDestinationSelected: (index) => setState(() => this.index = index),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.explore),
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.forum),
            icon: Icon(Icons.forum_outlined),
            label: 'Forums',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.collections_bookmark),
            icon: Icon(Icons.collections_bookmark_outlined),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
