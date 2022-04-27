import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:red_hosen/login.dart';
import 'package:red_hosen/Admins/adminHosen/welcome.dart' as admin_hosenpage;
import 'package:red_hosen/Admins/adminSocial/welcome.dart' as admin_socialpage;
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/therapist/welcome.dart' as therapistpage;
import 'package:red_hosen/socialWorker/welcome.dart' as socialpage;
import 'package:red_hosen/reporter/welcome.dart' as reporterpage;
import 'package:red_hosen/global.dart' as global;
import 'dart:io' show Platform;

const bool useEmulator = false;

Future _connectToFirebaseEmulator() async {
  final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8080);
  FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);
  FirebaseFunctions.instance.useFunctionsEmulator(localHostString, 5001);
  FirebaseDatabase.instance.useDatabaseEmulator(localHostString, 9000);
  FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: false));
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
        Provider<AuthService>(create: (_) => AuthService()),
        // create: (_) => AuthService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null)
      ],
      child: const MaterialApp(
        title: 'test',
        home: AuthWrapper(),
      ),
    );
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
        var securityrole = value.claims?['disabled'];
        //TODO
        if (true) {
          final DocumentSnapshot snapHosen = await FirebaseFirestore.instance
              .collection("Users")
              .doc(UserType.hosen.collectionStr)
              .collection(UserType.hosen.collectionStr)
              .doc(user.uid)
              .get();
          final DocumentSnapshot snapSocial = await FirebaseFirestore.instance
              .collection("Users")
              .doc(UserType.social.collectionStr)
              .collection(UserType.social.collectionStr)
              .doc(user.uid)
              .get();
          final DocumentSnapshot snapReporter = await FirebaseFirestore.instance
              .collection("Users")
              .doc(UserType.reporter.collectionStr)
              .collection(UserType.reporter.collectionStr)
              .doc(user.uid)
              .get();

          user.getIdTokenResult().then((value) async {
            var roleAdmin = value.claims?['isAdmin'];
            // var test = value.claims?['type'];
            // print(test);
            var roleTherapist = snapHosen.exists ? true : null;
            var roleSocial = snapSocial.exists ? true : null;
            var roleReporter = snapReporter.exists ? true : null;
            print(roleSocial);
            if (roleTherapist != null) {
              global.usertype = UserType.hosen;
              if (roleAdmin == true) {
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const admin_hosenpage.HomePage()));
              } else {
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const therapistpage.HomePage()));
              }
            } else {
              if (roleReporter != null) {
                global.usertype = UserType.reporter;
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const reporterpage.HomePage()));
              } else {
                if (roleSocial != null) {
                  global.usertype = UserType.social;
                  if (roleAdmin == true) {
                    await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                const admin_socialpage.HomePage()));
                  } else {
                    await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const socialpage.HomePage()));
                  }
                }
              }
            }
          });
        } else {
          context.read<AuthService>().logout();
        }
      });
    }
  });
}
