import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nynm_fapp/components/home/home_root.dart';
import 'package:nynm_fapp/components/util.dart';

class RegisterPage extends StatefulWidget {
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(title: Text("Register")),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Name'),
                      keyboardType: TextInputType.name,
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email Address'),
                      keyboardType: TextInputType.emailAddress,
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Password'),
                      obscureText: true,
                    )),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Register'),
                      onPressed: register,
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text("Already have an account?"),
                      onPressed: login,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }

  void login() {
    // Open Login Screen
    Navigator.popAndPushNamed(context, "/login");
  }

  void register() async {
    // perform Register action
    CircularProgressIndicator();

    try {
      User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text))
          .user;
      if (user != null) {
        // if user registered successfully
        // update in firestore
        (FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "name": nameController.text,
          "email": emailController.text,
          "avatar": "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
          "resolution_count": 0,
          "desc": "Hi! This is my new year resolution.",
          "following_count": 0,
          "followers_count": 0,
        })).then((result) => {
              // move to home page
              // load feed
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeRoot(title: "Feed", uid: user.uid)),
                  (_) => false),
              emailController.clear(),
              nameController.clear(),
              passwordController.clear()
            });
      } else {
        throw Exception("Failed to register.");
      }
    } catch (e) {
      alertError(context, e);
    }
  }
}
