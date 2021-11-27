import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/auth_services.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("avc"),
        centerTitle: true,
      ),
      body: Column(children: [const Text("login ok!"),
      ElevatedButton(onPressed: () {
        context.read<AuthService>().logout();
        },
        child: const Text("LogOut"),
        )
      
      ]),
    );
  }
}