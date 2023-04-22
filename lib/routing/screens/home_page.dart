import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readery/features/auth/login_page.dart';
import 'package:readery/features/auth/logged_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return UserProfile();
              } else if (snapshot.hasError) {
                return const Center(child: Text('Somehing Went Wrong!'));
              } else {
                return const SignIn();
              }
            }),
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WidgetSearch(size: size),
                    const WidgetNotif(),
                  ])),
          //scrollable part here laters
        ])));
  }
}

//searchbar
class WidgetSearch extends StatelessWidget {
  const WidgetSearch({
    super.key,
    required this.size,
  });

  final Size size;

  @override
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
            const Expanded(
                //TODO: onclick goto full page search view
                child: TextField(
              showCursor: false,
              decoration: InputDecoration(
                  border: InputBorder.none, focusedBorder: InputBorder.none),
            )),
          ]),
    ));
  }
}

//notifications
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
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 40,
                child: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                )),
            SizedBox(
                width: 40,
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_outlined),
                  onPressed: () {},
                )),
            SizedBox(
                width: 40,
                child: IconButton(
                  icon: const Icon(Icons.person_2_outlined),
                  onPressed: () {},
                )),
          ]),
    );
  }
}
