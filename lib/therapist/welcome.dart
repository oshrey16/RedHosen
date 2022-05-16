import 'package:flutter/material.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
        appBar: AppBar(
          title: const Text("מטפל - ראשי"),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(children: [
                //TODO - DONT FORGET TO DELETE!!!!
                // SizedBox(
                //     height: 50,
                //     child: ElevatedButton(
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const SecretPage()),
                //         );
                //       },
                //       child: const Text("דף סודי"),
                //     )),
                // const SizedBox(height: 15),
                //TODO - DONT FORGET TO DELETE!!!!
              ]),
            )));
  }
}
