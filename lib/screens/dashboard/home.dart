import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  static const String route="/home";
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title:const Text("Home"),
      ),
      body: Container(
        alignment: Alignment.center,
        child:const Text("Welcome to the App"),
      ),
    );
  }
}