import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nynm_fapp/components/home/home_root.dart';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: Center(
                    child: Text("Logo Here"),
                  ),
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
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      color: Colors.blue,
                      colorBrightness: Brightness.dark,
                      child: Text('Login'),
                      onPressed: login,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
      Fluttertoast.showToast(msg: "Logging in...");
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((UserCredential userCredential) => {
                // load feed
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeRoot(
                            title: "Feed", uid: userCredential.user.uid)),
                    (_) => false)
              })
          .catchError((err) => {alertError(context, err.message)});
    } catch (e) {
      alertError(context, e);
    }
  }
}
