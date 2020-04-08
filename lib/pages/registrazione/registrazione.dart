import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../export.dart';
import 'package:intl/intl.dart';

class RegistrazionePage extends StatefulWidget {  

  RegistrazionePage({Key key}) : super(key: key);

  @override
  _RegistrazionePageState createState() => _RegistrazionePageState();
}

class _RegistrazionePageState extends State<RegistrazionePage> {

  DateTime birthdate;
  String date = "Date of birth";
  String error = "";

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _surnameController = TextEditingController();

  final TextEditingController _birthController = TextEditingController();

  void nextPage(){
    bool check = false;
    if(_nameController.text == ""){
      check = true;
      setState(() {
        error = "Insert a valid name";
      });
    }
    else if(_surnameController.text == ""){
      check = true;
      setState(() {
        error = "Insert a valid surname";
      });
    }
    else if(_birthController.text == "Date of birth"){
      check = true;
      setState(() {
        error = "Insert a valid date of birth";
      });
    }      
    if(check == false){
      setState(() {
        error = "";
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Registrazione2Page(birthdate: birthdate, name: _nameController.text, surname: _surnameController.text)),
      );
    }
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(2000),
        firstDate: new DateTime(1930),
        lastDate: new DateTime(2020)
    );
    if(picked != null) {
      birthdate = picked;
      setState(() => date = DateFormat("d MMMM yyyy").format(picked));
    }
  }

  Widget customTextfield(String text, TextEditingController controller) => Container(
    height: 50,
    child: TextField(
      controller: controller,
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
        hintText: text,
        fillColor: Colors.white),
    ),
  );

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
            SizedBox(height: 100,),
            Text("Registration",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
            SizedBox(height: 30),
            customTextfield("Name", _nameController),
            SizedBox(height: 20,),
            customTextfield("Surname", _surnameController),
            SizedBox(height: 20,),
            InkWell(
              onTap: () {
                _selectDate();   // Call Function that has showDatePicker()
              },
              child: IgnorePointer(
                child: customTextfield(date, _birthController),
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
                onPressed: nextPage,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.transparent)),
                textColor: Colors.white,
                child: Text(
                  "Continua",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(error,
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ],
        ),
      ),
    ));
  }
}