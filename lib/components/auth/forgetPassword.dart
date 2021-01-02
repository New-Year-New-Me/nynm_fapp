import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ForgotPassword"),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                )),
            Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('Send Reset Mail'),
                  onPressed: sendResetMail,
                )),
          ],
        ),
      ),
    );
  }

  void sendResetMail() {
    Fluttertoast.showToast(msg: "Sending Reset Mail to your email");
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text)
        .then((value) {
      Fluttertoast.showToast(
          msg: "Reset link sent to ${emailController.text}",
          backgroundColor: Colors.green);
      Navigator.pop(context);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Reset link cannot be sent, Please check you email address",
          backgroundColor: Colors.red);
    });
  }
}
