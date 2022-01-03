import 'package:flutter/material.dart';
import 'package:red_hosen/adminHosen/user_confirmation.dart';

import '../mytools.dart';

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
          title: const Text("מנהל חוסן - ראשי"),
          centerTitle: true,
        ),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserConfirmation()),
                        );
                      },
                      child: const Text("אישור מטפלים במערכת"),
                    )),
                const SizedBox(height: 15),
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserDeletePage()),
                        );
                      },
                      child: const Text("מחיקת מטפלים במערכת"),
                    )),
                const SizedBox(height: 15),
                logoutButton(context),
              ]),
            )));
  }
}
