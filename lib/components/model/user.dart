import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class UserModel{
  final String name;
  final String avatar;
  final String desc;
  final int resolution_count, following_count, followers_count;
  final String uid;

  UserModel({this.name, this.avatar, this.desc, this.resolution_count, this.uid, this.followers_count, this.following_count});

  UserModel.fromMap(Map snapshot, String uid) :
    uid = uid ?? "",
    name = snapshot['name'],
    avatar = snapshot['avatar'] ?? "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
    desc = snapshot['desc'] ?? "Hi! This is my new year resolution.",
    resolution_count = snapshot['resolution_count'] ?? 0,
    following_count = snapshot['following_count'] ?? 0,
    followers_count = snapshot['followers_count'] ?? 0;

}