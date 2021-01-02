import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import "package:nynm_fapp/components/home/feeds.dart";
import "package:nynm_fapp/components/home/user_profile.dart";
import 'package:nynm_fapp/components/model/user.dart';
import "package:nynm_fapp/components/home/search_results.dart";
import 'package:nynm_fapp/podo/resolution.dart';

import '../util.dart';

class HomeRoot extends StatefulWidget {
  final String title;
  final String uid;

  HomeRoot({Key key, this.title, this.uid}) : super(key: key);

  _HomeRootState createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = Text("NYNM");

  List<Widget> _children = [
    FeedPageWidget(),
    // FeedPageWidget(),
    UserProfileWidget(uid: FirebaseAuth.instance.currentUser.uid),
  ];

  int _currentIndex = 0;

  final List<BottomNavigationBarItem> _navbar_items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    // BottomNavigationBarItem( icon: Icon(Icons.shop_rounded), label: "Marketplace"),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile")
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: search,
          ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addResolution
      ),
    );
  }

   void addResolution() async {
    await Navigator.pushNamed(context, "/addResolution").then((result) {
      Resolution resolution = result;
      if (resolution is! Resolution || resolution == null) return;
      Fluttertoast.showToast(msg: "Posting Resolution");
      var ref = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection("resolutions")
          .doc()
          .set({
        "resolution": resolution.toMap(),
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Resolution Updated", backgroundColor: Colors.green);
      }).catchError(handleError(context));
    }).catchError(handleError(context));
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void signout() {
    FirebaseAuth.instance
        .signOut()
        .then((result) => {Navigator.pushReplacementNamed(context, "/login")});
  }

  void search() {
    setState(() {
      if (this.actionIcon.icon == Icons.search) {
        this.actionIcon = new Icon(Icons.close);
        this.appBarTitle = new TextField(
          onSubmitted: showSearchResult,
          style: new TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintText: "Search...",
              hintStyle: new TextStyle(color: Colors.white)),
        );
      } else {
        this.actionIcon = new Icon(Icons.search);
        this.appBarTitle = new Text("NYNM");
      }
    });
  }

  void showSearchResult(String searchProfile){
    (FirebaseFirestore.instance.collection("users").orderBy("name").startAt([searchProfile]).endAt([searchProfile+'\uf8ff']).get()).then(
      (querysnapshot) => {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SearchResultPage(querySnapshots: querysnapshot.docs)
        ))
      });
  }


}
