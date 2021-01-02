import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

import "package:nynm_fapp/components/home/feeds.dart";
import "package:nynm_fapp/components/home/user_profile.dart";

class HomeRoot extends StatefulWidget {
  final String title;
  final String uid;

  HomeRoot({Key key, this.title, this.uid}) : super(key: key);

  _HomeRootState createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {

  int _currentIndex = 0;

  // TODO: Feed, Leaderboard, UserProfile
  final List<Widget> _children = [
    FeedPageWidget(),
    FeedPageWidget(),
    UserProfileWidget(uid: FirebaseAuth.instance.currentUser.uid),
  ];

  final List<BottomNavigationBarItem> _navbar_items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home" ),
    BottomNavigationBarItem(icon: Icon(Icons.shop_rounded), label: "Marketplace" ),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile" )
  ];


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Text("Log Out"),
            textColor: Colors.white,
            onPressed: signout,
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _navbar_items,
        onTap: changeTab,
      ),
    );
  }

  void changeTab(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  void signout(){
      FirebaseAuth.instance.signOut().then((result) =>  
      {Navigator.pushReplacementNamed(context, "/login")});
  }
}
