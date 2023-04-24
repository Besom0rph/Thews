import 'package:flutter/material.dart';
import 'package:thews/screen/login.dart';
import 'package:thews/screen/register.dart';

class HomeScreen extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("\t \t \t \t Welcome to Thews Application"),backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/news_logo.png"),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  label: Text("Login", style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context){
                          return LoginScreen();
                      })
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label:
                      Text("Register", style: TextStyle(fontSize: 20)),
                      onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context){
                          return RegisterScreen();
                      })
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
