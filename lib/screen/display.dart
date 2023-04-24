import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thews/pages/articles_details_page.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                leading: BackButton(
                  onPressed: () => 
                  Navigator.pop(context,
                    MaterialPageRoute(builder: (context){
                      return ArticlePage();
                    }))
                ),
      title:Text("แสดงรายการความคิดเห็น")
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("comments").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            return ListView(
              children: snapshot.data.docs.map((document){
                  return Container(
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: FittedBox(child: Text("?"),
                          ),
                        ),
                        title: Text(document["Owner"]),
                        subtitle: Text(document["text"]),
                    ),
                  );
              }).toList(),
          );
          }
        },
      ),
      );
  }
}