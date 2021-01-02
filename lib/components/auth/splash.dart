import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nynm_fapp/components/home/feeds.dart';
import 'package:nynm_fapp/components/util.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FirebaseAuth auth;
  FirebaseFirestore firestore;

  @override
  void initState() {
    // Login based on auth state
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;

    auth.authStateChanges().listen((User user) {
      if (user == null) {
        // user has not logged in...
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // user is signed in...
        try {
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get()
              .then((DocumentSnapshot snapshot) => {
                    // load feed
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FeedPage(title: "Feed", uid: user.uid)),
                        (_) => false)
                  });
        } catch (e) {
          alertError(context, e);
        }
      }
    });

    super.initState();
  }

  Widget build(BuildContext ctx) {
    return Scaffold(
        body: Center(child: Container(child: CircularProgressIndicator())));
  }
}
