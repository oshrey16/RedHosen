import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
  final FirebaseAuth _auth;
  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email, String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("login");
      return "Logged In";
    }
    catch(e){
      return e.toString();
    }
  }

   Future<String> signUp(String email, String password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return "User Created!";
    }
    catch(e){
      return e.toString();
    }
  }

  Future<String> logout() async{
    try{
      await _auth.signOut();
      return "Log Out!";
    }
    catch(e){
      return e.toString();
    }
  }
}