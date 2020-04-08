import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../export.dart';
class LoginPage extends StatefulWidget {  

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String errorText = "";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    var email = _emailController.text;
    var password = _passwordController.text;
    api.login(email, password).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage()
        )
      );}
    ).catchError((error){
      setState(() {
        errorText = error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          colors: <Color>[
            Color.fromRGBO(30, 53, 118, 1), 
            Color.fromRGBO(75, 107, 195, 1)],
          ), 
        ),
        child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 300,),
            Container(
              height: 50,
              child: TextField(
                controller: _emailController,
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[600], fontSize: 18, ),
                  hintText: "Email",
                  fillColor: Colors.white),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 50,
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[600], fontSize: 18, ),
                  hintText: "Password",
                  fillColor: Colors.white),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(color: Colors.transparent),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromRGBO(49, 241, 255, 1), 
                    Color.fromRGBO(65, 144, 231, 1)],
                ), 
                boxShadow: [
              ]),
              child: FlatButton(
                onPressed: login,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.transparent)),
                textColor: Colors.white,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            FlatButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrazionePage()),
                );
              },
              child: Text("Registrati",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 20,),
            Text(errorText,
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ],
        ),
      ))
    );
  }
}