import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:nynm_fapp/components/model/user.dart';
import "package:nynm_fapp/components/home/user_profile.dart";

class SearchResultPage extends StatefulWidget{
  final List<QueryDocumentSnapshot> querySnapshots;

  SearchResultPage({Key key, this.querySnapshots});

  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>{

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: _getSearchResultItems(),
      )
    );
  }

  List<Widget> _getSearchResultItems(){
    List<Widget> items = [];
    for(int i=0;i<widget.querySnapshots.length;i++){
      QueryDocumentSnapshot snapshot = widget.querySnapshots[i];
      UserModel user = UserModel.fromMap(snapshot.data(), snapshot.id);
      items.add(
        GestureDetector(
          onTap: (){
            // open user profile
            launchUserProfile(context, user.uid);
          },
          child: Card(
            child: Row(
            children: [
            Padding(padding: EdgeInsets.all(10), child: CircleAvatar(backgroundImage: NetworkImage(user.avatar),),),
            Text(user.name),
          ],
          )
          ) 
        )
      );
    }

    if(items.length == 0){
      return [Container(child: Text("No Results found.."), alignment: Alignment.center, height: 100,)];
    }
    return items;
  }

  void launchUserProfile(BuildContext context, String uid){
    Navigator.push(context, MaterialPageRoute(builder: 
    (context) => Scaffold(
      appBar: AppBar(),
      body: Container(
        child: UserProfileWidget(uid: uid)
      )
    )
    ));
  }

}