import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:thews/model/profile.dart';

import 'home.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Scaffold(
                appBar: AppBar(
                  title: Text("Error"),
                  ),
                body: Center(child: Text("${snapshot.error}"),
                ),
            );
          }
          //check firebase connection !
          if (snapshot.connectionState == ConnectionState.done) { 
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () => 
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context){
                      return HomeScreen();
                    }))
                ),
                title: Text("Create Account"),
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email", style: TextStyle(fontSize: 20)),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Please fill email."),
                              EmailValidator(errorText: "Invalid Email format")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String email) {
                              profile.email = email;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text("Password", style: TextStyle(fontSize: 20)),
                          TextFormField(
                            validator: RequiredValidator(errorText: "Please fill password"),
                              obscureText: true,
                              onSaved: (String password) {
                              profile.password = password;
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("Register",style: TextStyle(fontSize: 20)),
                              onPressed: () async{
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  try{
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: profile.email, 
                                      password: profile.password
                                    ).then((value){
                                      formKey.currentState.reset();
                                      Fluttertoast.showToast(
                                        msg: "Create Account Successfully",
                                        gravity: ToastGravity.TOP
                                      );
                                      Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context){
                                          return HomeScreen();
                                      }));
                                    });
                                  }on FirebaseAuthException catch(e){
                                      print(e.code);
                                      String message;
                                      if(e.code == 'email-already-in-use'){
                                          message = "This Email already exist, Please try another email instead.";
                                      }else if(e.code == 'weak-password'){
                                          message = "Password must be at least 6 character.";
                                      }else{
                                          message = e.message;
                                      }
                                      Fluttertoast.showToast(
                                        msg: message,
                                        gravity: ToastGravity.CENTER
                                      );
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
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
