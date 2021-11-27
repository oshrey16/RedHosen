import 'package:flutter/material.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/register.dart';

//final _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                          border: OutlineInputBorder(),
                          labelText: 'הקלד אימייל'),
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
                          border: OutlineInputBorder(),
                          labelText: 'הקלד סיסמא'),
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
                  if (email.isNotEmpty && password.isNotEmpty) {
                    context.read<AuthService>().login(email, password);
                  } else {
                    if (email.isEmpty) {
                      print("Email Empty!");
                    } else {
                      print("password Empty!");
                    }
                  }
                },
                child: const Text('התחבר')),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text("הרשמה"),
            )
          ],
        ));
  }

  // Future _login() async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _emailController.text, password: _passwordController.text);
  //     _checkuser();

  //     await Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => const Welcome()));
  //   } on FirebaseAuthException catch (e) {
  //     showDialog(
  //         context: context,
  //         builder: (ctx) => AlertDialog(
  //               title: const Text("Ops! Login Failed"),
  //               content: Text('${e.message}'),
  //             ));
  //   }
  // }

  // _checkuser() async {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) async {
  //     if (user != null) {
  //       user.getIdTokenResult().then((value) async {
  //         var t = value.claims?['role'];
  //         if (t == 'admin') {
  //           await Navigator.of(context).pushReplacement(
  //               MaterialPageRoute(builder: (context) => const Welcome1()));
  //         } else {
  //           if (t == 'psy') {
  //             await Navigator.of(context).pushReplacement(
  //                 MaterialPageRoute(builder: (context) => const Welcome()));
  //           } else {
  //             await Navigator.of(context).pushReplacement(
  //                 MaterialPageRoute(builder: (context) => const Welcome()));
  //           }
  //         }
  //       });
  //     }
  //   });
  // }
}
