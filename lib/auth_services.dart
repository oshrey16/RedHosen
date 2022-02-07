import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(
      BuildContext context, Map<dynamic, dynamic> mapvars) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: mapvars['email'], password: mapvars['password'])
          .then((value) async {
        if (FirebaseAuth.instance.currentUser != null) {
          HttpsCallable callable =
              FirebaseFunctions.instance.httpsCallable("createUserStore");
          mapvars.remove('password');
          mapvars.remove('passwordv');
          mapvars.remove('emailv');
          await callable({"mapvars": mapvars});
          return "User Created";
        }
      });
      return "User Created";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> sendEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      user?.sendEmailVerification();
      return "sendEmailVerification";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> logout() async {
    try {
      await _auth.signOut();
      return "Log Out";
    } catch (e) {
      return e.toString();
    }
  }
}
