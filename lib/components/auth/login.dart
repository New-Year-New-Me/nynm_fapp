import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nynm_fapp/components/home/feeds.dart';
import 'package:nynm_fapp/components/util.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
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
                      child: Text('Login'),
                      onPressed: login,
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text("Don't have an account?"),
                      onPressed: signUp,
                    ),
                    FlatButton(
                        onPressed: forgotPassword,
                        textColor: Colors.blue,
                        child: Text('Forgot Password')),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }

  void forgotPassword() {
    Navigator.pushNamed(context, "/forgetPassword");
  }

  void signUp() {
    // Open Signup Screen
    Navigator.popAndPushNamed(context, "/register");
  }

  void login() {
    // Perform login action
    try {
      CircularProgressIndicator();

      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((UserCredential userCredential) => {
                // load feed
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeedPage(
                            title: "Feed", uid: userCredential.user.uid)),
                    (_) => false)
              })
          .catchError((err) => {alertError(context, err)});
    } catch (e) {
      alertError(context, e);
    }
  }
}
