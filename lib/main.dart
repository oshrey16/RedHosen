import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:red_hosen/login.dart';
import 'dart:io' show Platform;

import 'package:red_hosen/welcome.dart';

const bool useEmulator = false;

Future _connectToFirebaseEmulator() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  // FirebaseFirestore.instance.settings = Settings(
  //   host: '$localHostString:8080',
  //   sslEnabled: false,
  //   persistenceEnabled: false,
  // );
  await FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);
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
    return MultiProvider(providers: [
      Provider<AuthService>(create: (_) => AuthService(FirebaseAuth.instance)),
      StreamProvider(create: (context) => context.read<AuthService>().authStateChanges, initialData: null)
    ],
    child: const MaterialApp(
      title: 'test',
      home: AuthWrapper(),
    ),);
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

class AuthWrapper extends StatelessWidget{
  const AuthWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    final user = context.watch<User?>();
    if(user != null){
      print("user: "  + user.toString());
      return const Welcome();
    }
    return const LoginPage();
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             LoginPage(),
//           ],
//         ),
//       ),
//     );
//   }
// }
