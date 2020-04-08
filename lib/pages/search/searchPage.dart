import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../export.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Search", style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
    );
  }
}