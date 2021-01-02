import 'package:flutter/material.dart';

void alertError(BuildContext context, dynamic e) {
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(e.toString()),
    actions: [FlatButton(onPressed: null, child: Text("Cancel"))],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
