import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class FeedPage extends StatefulWidget{

  final String title;
  final String uid;

  FeedPage({Key key, this.title, this.uid}): super(key: key);

  _FeedPageState createState() => _FeedPageState();

}

class _FeedPageState extends State<FeedPage>{

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Text("Log Out"),
            textColor: Colors.white,
            onPressed: (){
              // Sign out from App
              FirebaseAuth.instance.signOut()
              .then((result) => {
                Navigator.pushReplacementNamed(context, "/login")
              });
              
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Text("Welcome User " + widget.uid)
        )
      ),
    );
  }

}