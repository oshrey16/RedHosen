
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:red_hosen/main.dart';

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
      body: Column(children: [ const Text("login ok!"),
      ElevatedButton(onPressed: () async {
        context.read<AuthService>().logout();
        await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthWrapper()));
        },
        child: const Text("LogOut"),
        )
      ]),
    );
  }
}