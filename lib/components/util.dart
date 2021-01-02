import 'package:flutter/material.dart';

void alertError(BuildContext context, dynamic e) {
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text(e.toString()),
    actions: [
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"))
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

Function handleError(context) {
  onError(e, stackTrace) {
    print(stackTrace.toString());
    alertError(context, e.message);
  }

  return onError;
}
