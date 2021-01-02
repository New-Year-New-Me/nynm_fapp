import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:nynm_fapp/components/home/edit_profile.dart';
import "package:nynm_fapp/components/model/user.dart";
import 'package:nynm_fapp/components/util.dart';

final int STATE_EDIT = 1;
final int STATE_FOLLOW = 2;
final int STATE_UNFOLLOW = 3;

class UserProfileWidget extends StatelessWidget {
  final String uid;

  dynamic actionText;

  int resolution_count, followers_count, following_count;

  UserProfileWidget({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        else if (snapshot.hasError)
          alertError(context, snapshot.error);
        else {
          // show container
          return _getUserProfile(
              ctx, UserModel.fromMap(snapshot.data.data(), uid));
        }
      },
    );
  }

  Widget _getUserProfile(BuildContext context, UserModel user) {
    resolution_count = user.resolution_count;
    following_count = user.following_count;
    followers_count = user.followers_count;

    return Container(
        color: Colors.white70,
        child: Center(
            child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20)),
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
              radius: 50,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text(user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                  ],
                )),
                Column(
                  children: [actionButton(context, user)],
                ),
                Padding(padding: EdgeInsets.only(right: 10))
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(user.desc, style: new TextStyle()),
            Divider(
              color: Colors.black,
            ),
            Row(
              children: <Widget>[
                rowCell(resolution_count, "Resolutions"),
                rowCell(following_count, "Following"),
                rowCell(followers_count, "Followers"),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        )));
  }

  Widget rowCell(int count, String type) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(
            '$count',
            style: new TextStyle(color: Colors.black),
          ),
          new Text(type,
              style: new TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal))
        ],
      ));

  Widget actionButton(BuildContext context, UserModel user) {
    actionText = (uid == FirebaseAuth.instance.currentUser.uid)
        ? Text("Edit")
        : followStatusText();
    return RaisedButton(
        onPressed: () {
          performAction(context, user);
        },
        color: Colors.blue,
        colorBrightness: Brightness.dark,
        child: actionText);
  }

  Widget followStatusText() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection("follows")
            .doc(uid)
            .get()
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.data() != null) {
            return Text("Unfollow");
          } else {
            return Text("Follow");
          }
        });
  }

  void performAction(BuildContext context, UserModel user) {
    String current_uid = FirebaseAuth.instance.currentUser.uid;
    if (uid == current_uid) {
      // Edit Screen
      Navigator.push(
        context,
        MaterialPageRoute(
           builder: (context) => EditProfile(user: user)
        )
      );


    } else {
      // logic for creating follow status
      (FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection("follows")
              .doc(uid)
              .get())
          .then((snapshot) => {
                if (snapshot.data() == null)
                  {
                    // add follower
                    addFollower(context, current_uid)
                  }
                else
                  {
                    // delete from followe list
                    deleteFollower(context, current_uid)
                  }
              });
    }
  }

  void updateFollowerField(BuildContext context, String current_uid, String other_uid, int value){
    // update a field by one for user A
    FirebaseFirestore.instance
    .collection("users")
    .doc(current_uid)
    .update({"following_count": FieldValue.increment(value)})
    .whenComplete(() => {
      // update a field by one for other user
      FirebaseFirestore.instance
      .collection("users")
      .doc(other_uid)
      .update({"followers_count": FieldValue.increment(value)}).then((value) => {
        following_count += 1,
        (context as Element).markNeedsBuild()
      })
    });
  }

  void addFollower(BuildContext context, String current_uid) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(current_uid)
        .collection("follows")
        .doc(uid)
        .set({"followingSince": DateTime.now().millisecondsSinceEpoch}).then(
            (value) => {
                  actionText = Text("Unfollow"),
                  updateFollowerField(context, current_uid, uid, 1)
                });
  }

  void deleteFollower(BuildContext context, String current_uid) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(current_uid)
        .collection("follows")
        .doc(uid)
        .delete()
        .then((value) => {
              actionText = Text("Follow"),
              updateFollowerField(context, current_uid, uid, -1)
            });
  }
}
