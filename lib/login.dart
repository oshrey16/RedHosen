import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_hosen/welcome.dart';
import 'package:red_hosen/Admin/welcome.dart';

//final _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _firstNamebox = TextEditingController();
  final _lastNamebox = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // //Positioned(bottom: 10, right: 10, child: Text("123")),
        // Expanded(child: AnimatedPositioned(child: Text("asd"), duration: Duration(milliseconds: 500),bottom: 100,top: 100,)
        // ),
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
                  controller: _firstNamebox,
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
                  controller: _lastNamebox,
                  autofocus: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'הקלד סיסמא'),
                ),
              ),
            ),
            const Text("  :סיסמא", style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () => _login(), child: const Text('התחבר'))
      ],
    );
  }

  Future _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _firstNamebox.text, password: _lastNamebox.text);
      _checkuser();

      await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Welcome()));
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Ops! Login Failed"),
                content: Text('${e.message}'),
              ));
    }
  }

  _checkuser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        user.getIdTokenResult().then((value) async {
          var t = value.claims?['role'];
          if (t == 'admin') {
            await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Welcome1()));
          } else {
            if (t == 'psy') {
              await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Welcome()));
            } else {
              await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Welcome()));
            }
          }
        });
      }
    });
  }
}
