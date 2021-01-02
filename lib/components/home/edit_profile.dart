import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:nynm_fapp/components/model/user.dart';
import 'package:nynm_fapp/components/util.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget{
    final UserModel user;

    EditProfile({Key key, this.user});

    _EditProfileState createState() => _EditProfileState();

}

class _EditProfileState extends State<EditProfile>{

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  File image=null;
  ImageProvider provider;

  Widget build(BuildContext context){
    nameController.text = widget.user.name;
    descController.text = widget.user.desc;
    provider = NetworkImage(widget.user.avatar);

    return Scaffold(
      appBar: AppBar(title: Text("Edit"),),
      body: Container(
        padding: EdgeInsets.all(15),
        color: Colors.white70,
        child: Center(
            child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20)),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: CircleAvatar(
                backgroundImage: provider,
                radius: 50,
              )
            ),
            
            Padding(padding: EdgeInsets.only(top: 20)),
            GestureDetector(
              onTap: null,
              child: TextField(
                controller: nameController,
              )
            ),


            
            Padding(padding: EdgeInsets.only(top: 20)),
            GestureDetector(
              onTap: null,
              child: TextField(
                controller: descController,
              )
            ),
            
            Padding(padding: EdgeInsets.only(top: 20)),
            RaisedButton(
              onPressed: (){
                save();
              },
              child: Text("Save")
            )

          ],
        )))
    );
  } 

  getImage() async{
    final _imagePicker = ImagePicker();

   //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if(permissionStatus.isGranted){
      PickedFile pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
      setState(() {
        image = File(pickedFile.path);
        provider = FileImage(image);
      });
    }
    else{
      alertError(context, Exception("Permission not granted."));
    }
  }

  save() async{
      final _storage = FirebaseStorage.instance;
      final _auth = FirebaseAuth.instance;

      if(image!= null){
        var snapshot = await _storage.ref().child("profile/" + _auth.currentUser.uid).putFile(image)
        .then((snapshot) => {
          snapshot.ref.getDownloadURL().then((url) => setText(url))
        });
      }else{
        setText(widget.user.avatar);
      }
      
  }

  setText(String avatar) async{
      final _cloudstore = FirebaseFirestore.instance;
      final _auth = FirebaseAuth.instance;

      _cloudstore.collection("users")
      .doc(_auth.currentUser.uid)
      .update({
        "name": nameController.text,
        "desc": descController.text,
        "avatar": avatar
      }).then((value) => {
        Navigator.pop(context, true)
      });

  }

}