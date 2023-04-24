//Now let's create the article details page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thews/model/article_model.dart';
import 'package:flutter/material.dart';
import 'package:thews/pages/comments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thews/pages/write_comment.dart';
import 'package:thews/screen/display.dart';

class ArticlePage extends StatelessWidget {
  final Article article;
  final auth = FirebaseAuth.instance;

  ArticlePage({this.article});
  Comments comments = Comments();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  //let's add the height

                  image: DecorationImage(
                      image: NetworkImage(article.urlToImage),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),

              Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  article.source.name,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                article.description,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FormScreen();
                  }));
                },
                child: Text(
                  "Comment",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ShowComment();
                  }));
                },
                child: Text(
                  "Read Comment",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              //T0D0 - Add current comment from DB
              Row(
                children: [
                  Container(
                    color: Colors.green,
                    margin: EdgeInsets.all(50),
                    
                  )
                ],)
            ],
          ),
        ),
      ),
      
    );
  }
}

class ShowComment extends StatefulWidget {
  @override
  _ShowCommentState createState() => _ShowCommentState();
}

class _ShowCommentState extends State<ShowComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All comments")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("comments").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.docs.map((document) {
                return Container(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                        child: Text("?"),
                      ),
                    ),
                    title: Text(document["Owner"] + " :"),
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

class FetchComment extends StatefulWidget {
  @override
  _FetchComment createState() => _FetchComment();
}

class _FetchComment extends State<FetchComment> {
  final auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("แสดงรายการความคิดเห็น")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("comments").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.docs.map((document) {
                return Container(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                        child: Text("?"),
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




/*
buildPostFooter() {
  return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
          GestureDetector(
            onTap: () => print('Show comments'),
            child: Icon(
              Icons.chat,
              size: 28,
              color: Colors.grey,),

          )
        ],
    
      )
    ],
  );
}

showComments(BuildContext context,
    {String postId, String owner, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      owner: owner,
      mediaUrl: mediaUrl,
    );
  }));
}
*/
