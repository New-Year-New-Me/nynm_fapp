import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:nynm_fapp/components/model/user.dart";

class UserProfileWidget extends StatelessWidget {

  final UserModel user;

  const UserProfileWidget({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white70,
      child: Center(
        child: Column(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
            Text(user.name, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Text(user.desc, style: new TextStyle()),
            Divider(color: Colors.black,),
            Row(children: <Widget>[
              rowCell(user.resolution_count, "Resolutions"),

            ],)


          ],
        )
      )
    );
  }

    Widget rowCell(int count, String type) => new Expanded(child: new Column(children: <Widget>[
      new Text('$count',style: new TextStyle(color: Colors.black),),
      new Text(type,style: new TextStyle(color: Colors.black, fontWeight: FontWeight.normal))
    ],));

}