import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:red_hosen/login.dart';
import 'package:red_hosen/adminhosen/welcome.dart' as adminpage;
import 'package:red_hosen/therapist/welcome.dart' as therapistpage;
import 'package:red_hosen/reporter/welcome.dart' as reporterpage;
import 'dart:io' show Platform;

const bool useEmulator = true;

Future _connectToFirebaseEmulator() async {
  final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8080);
  FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);
  // FirebaseFirestore.instance.settings = Settings(
  //   host: '$localHostString:8080',
  //   sslEnabled: false,
  //   persistenceEnabled: false,
  // );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (useEmulator) {
    await _connectToFirebaseEmulator();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null)
      ],
      child: const MaterialApp(
        title: 'test',
        home: AuthWrapper(),
      ),
    );
    //   return MaterialApp(
    //     title: 'Red Hosen',
    //     theme: ThemeData(
    //       primarySwatch: Colors.teal,
    //     ),
    //     home: const MyHomePage(title: 'Red Hosen'),
    //   );
    // }
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    if (user != null) {
      _checkuser(context);
    }
    return const LoginPage();
  }
}

Future _checkuser(BuildContext context) async {
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user != null) {
      user.getIdTokenResult().then((value) async {
        var role = value.claims?['role'];
        if (role == 'admin') {
          await Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const adminpage.HomePage()));
        } else {
          if (role == 'therapist') {
            await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const therapistpage.HomePage()));
          } else {
            if (role == 'reporter') {
              await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const reporterpage.HomePage()));
            } else {
              //TODO
            }
          }
        }
      });
    }
  });
}
