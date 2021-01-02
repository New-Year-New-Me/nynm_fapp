import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nynm_fapp/podo/resolution.dart';

import '../util.dart';

class FeedPage extends StatefulWidget {
  final String title;
  final String uid;

  FeedPage({Key key, this.title, this.uid}) : super(key: key);

  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Text("Log Out"),
            textColor: Colors.white,
            onPressed: logout,
          )
        ],
      ),
      body: Center(child: Container(child: Text("Welcome User " + widget.uid))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addResolution,
      ),
    );
  }

  void logout() {
    FirebaseAuth.instance
        .signOut()
        .then((result) => {Navigator.pushReplacementNamed(context, "/login")});
  }

  void addResolution() async {
    Resolution resolution =
        await Navigator.pushNamed(context, "/addResolution");
    Fluttertoast.showToast(msg: "Posting Resolution");
    var ref = FirebaseFirestore.instance.collection("resolutions").doc();
    var id = ref.id;
    ref.set({
      "data": resolution,
      "users": [widget.uid]
    }).then((value) {
      FirebaseFirestore.instance.collection("users").doc(widget.uid).update({
        "resolutions": FieldValue.arrayUnion([id])
      }).then((value) {
        Fluttertoast.showToast(
            msg: "Resolution Updated", backgroundColor: Colors.green);
      }).catchError(handleError(context));
    }).catchError(handleError(context));
  }
}
