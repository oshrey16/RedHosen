import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String usertype = 'בחר';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Register Page'),
        ),
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            DropdownButton<String>(
                value: usertype,
                onChanged: (String? newValue) {
                  setState(() {
                    usertype = newValue!;
                  });
                },
                items: <String>['בחר', 'מטפל', 'מדווח','צופה']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList())
          ]),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 30,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _emailController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'הקלד אימייל'),
                  ),
                ),
              ),
              const Text("   :אימייל", style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 30,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _passwordController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'הקלד סיסמא'),
                    obscureText: true,
                  ),
                ),
              ),
              const Text("  :סיסמא", style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                final String email = _emailController.text.trim();
                final String password = _passwordController.text.trim();
                if (email.isNotEmpty &&
                    password.isNotEmpty &&
                    usertype != 'בחר') {
                  context
                      .read<AuthService>()
                      .signUp(email, password)
                      .then((value) async {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      print("ok");
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .set({
                        'uid': user.uid,
                        'email': user.email,
                        'permissions' : _convertusertype(), 
                      });
                    }
                  });
                } else {
                  if (email.isEmpty) {
                    print("Email Empty!");
                  } else if (password.isEmpty) {
                    print("password Empty!");
                  } else {
                    print("select type!");
                  }
                }
              },
              child: const Text('הירשם')),
        ]));
  }

  _convertusertype(){
    if(usertype == 'מטפל'){
      return 'psy';
    }
    if(usertype == 'מדווח'){
      return 'reporter';
    }
  }
}
