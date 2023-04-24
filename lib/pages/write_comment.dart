import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thews/model/article_model.dart';
import 'package:thews/pages/articles_details_page.dart';
import 'package:thews/pages/comments.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  Comments comments = Comments();
  //เตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _CommentCollection =
      FirebaseFirestore.instance.collection("comments");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                    onPressed: () => Navigator.pop(context,
                            MaterialPageRoute(builder: (context) {
                          return ArticlePage();
                        }))),
                title: Text("Account " + "${auth.currentUser.email.split("@").first}"),
              ),
              body: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Comment",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator:
                              RequiredValidator(errorText: "Please fill your comment."),
                          onSaved: (String text) {
                            comments.text = text;
                            comments.Owner =
                                auth.currentUser.email.split("@").first;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              child: Text(
                                "Send Comment",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  print("${comments.text}");
                                  print("${comments.Owner}");
                                  print("${comments.URL}");
                                  _CommentCollection.add({
                                    "text": comments.text,
                                    "Owner": comments.Owner,
                                    "URL": comments.URL,
                                  });
                                  formKey.currentState.reset();
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}


