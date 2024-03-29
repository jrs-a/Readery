import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readery/routing/root_page.dart';

import '../../features/auth/login_page.dart';
import '../../features/novels/novel_info.dart';

/*
  checkStatus() - checks status if logged in for redirection
                - i thought it fits on the starting page of an app and before the home page
  homePage() - show homepage
*/

class CheckStatus extends StatelessWidget {
  const CheckStatus({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return const RootPage();
              } else if (snapshot.hasError) {
                return const Center(child: Text('Somehing Went Wrong!'));
              } else {
                return const Login();
              }
            }),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Appbar
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //page structure here
          Container(
              //app bar part here
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Flexible(
                //search
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  // width: size.width * 0.6,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF1E9E7),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: const Color(0xFFF1E9E7), width: 1.5)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Icons.search_outlined,
                                color:
                                    Theme.of(context).colorScheme.onSurface)),
                        Expanded(
                          child: TextField(
                            showCursor: false,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WidgetSearch()));
                            },
                          ),
                        ),
                      ]),
                ),
              )

              // TextField(
              //   showCursor: false,
              //   decoration: const InputDecoration(
              //       border: InputBorder.none, focusedBorder: InputBorder.none),
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => WidgetSearch()));
              //   },
              // )
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       WidgetSearch(size: size),
              //       const WidgetNotif(),
              //     ]),
              ),
          //scrollable part here laters
        ])));
  }
}

//searchbar
/*Changes on the search bar
- Stateful instead of Stateless
- created a new state
these are necessary to use setState function  */
class WidgetSearch extends StatefulWidget {
  WidgetSearch({
    super.key,
    // required this.size,
  });

  // final Size size;

  @override
  State<StatefulWidget> createState() => _WidgetSearchState();
}

class _WidgetSearchState extends State<WidgetSearch> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              name = val;
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Novel').snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;
                    if (name.isEmpty) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NovelInfo(data['novelId'])));
                        },
                        title: Text(
                          data['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        subtitle: Text(
                          data['author'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(data['coverUrl'],
                                fit: BoxFit.cover, height: 180)),
                      );
                    }
                    if (data['title']
                        .toString()
                        .startsWith(name.toLowerCase())) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NovelInfo(data['novelId'])));
                        },
                        title: Text(
                          data['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        subtitle: Text(
                          data['author'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(data['coverUrl'],
                                fit: BoxFit.cover, height: 180)),
                      );
                    }
                    return Container();
                  });
        },
      ),
    );
  }
//original design
/*  @override
  Widget build(BuildContext context) {
    return Flexible(
      //search
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // width: size.width * 0.6,
        decoration: BoxDecoration(
            color: const Color(0xFFF1E9E7),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFF1E9E7), width: 1.5)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.search_outlined,
                      color: Theme.of(context).colorScheme.onSurface)),
              Expanded(
                child: TextField(
                  showCursor: false,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ]),
      ),
    );
  }*/
}

//notifications ->>>search bar
class WidgetNotif extends StatelessWidget {
  const WidgetNotif({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //profile notif
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant, width: 1.5),
      ),
      // child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       SizedBox(
      //           width: 40,
      //           child: IconButton(
      //             icon: const Icon(Icons.chat_bubble_outline),
      //             onPressed: () {},
      //           )),
      //       SizedBox(
      //           width: 40,
      //           child: IconButton(
      //             icon: const Icon(Icons.notifications_none_outlined),
      //             onPressed: () {},
      //           )),
      //     ]),
    );
  }
}

class NewSearch extends StatefulWidget {
  const NewSearch({super.key});

  @override
  State<NewSearch> createState() => _NewSearchState();
}

class _NewSearchState extends State<NewSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        showCursor: false,
        decoration: const InputDecoration(
            border: InputBorder.none, focusedBorder: InputBorder.none),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WidgetSearch()));
        },
      ),
    );
  }
}
