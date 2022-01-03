import 'package:flutter/material.dart';
import 'package:red_hosen/mytools.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("מדווח - ראשי"),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(children: [
              logoutButton(context),
            ]))));
  }
}
