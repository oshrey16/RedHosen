import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:red_hosen/global.dart' as global;
import 'package:red_hosen/mytools.dart';

class AuthService {
  Stream<User?> get authStateChanges => FirebaseAuth.instance.idTokenChanges();

  Future<String> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password).then((value) {
            updateFCMToken(value);
            setUserName();
          });
      return "Logged In";
    } catch (e) {
      return e.toString();
    }
  }

  void setUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      global.name = user.displayName ?? '';
    }
  }

  Future<String> signUp(
      BuildContext context, Map<dynamic, dynamic> mapvars) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: mapvars['email'], password: mapvars['password'])
          .then((value) async {
        // if (FirebaseAuth.instance.currentUser != null) {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable("createUser");
        mapvars.remove('password');
        mapvars.remove('passwordv');
        mapvars.remove('emailv');
        final fcmToken = await FirebaseMessaging.instance.getToken();
        mapvars['fcmToken'] = fcmToken;
        return await callable({"mapvars": mapvars}).then((value) {
          return "User Created";
        });
        //   print("OK");
        //   HttpsCallable updatename =
        //       FirebaseFunctions.instance.httpsCallable("updateUserName");
        //   String email = mapvars['email'].toString();
        //   String fullName = mapvars['fname'] + " " + mapvars['lname'];
        //   return await updatename(
        //           <String, dynamic>{'name': fullName, 'email': email})
        //       .then((value) async {
        //     String type = mapvars['claimtype'];
        //     HttpsCallable updatetype =
        //         FirebaseFunctions.instance.httpsCallable("InsertUserType");
        //     return await updatetype(
        //         <String, dynamic>{'type': type, 'email': email}).then((value) {
        //       return "User Created";
        //     });
        //   });
        // });
      });
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
    global.usertype = UserType.nil;
    global.name = "";
    global.isAdmin = false;
    try {
      await FirebaseAuth.instance.signOut();
      return "Log Out";
    } catch (e) {
      return e.toString();
    }
  }

  Future sendResetPassword(String email) async{
      return FirebaseAuth.instance.sendPasswordResetEmail(email: email).catchError((error){return Future.error(error);});

  }

  Future updateFCMToken(UserCredential v){
    return _checkuser().then((value) {
    return FirebaseMessaging.instance.getToken().then((fcmToken) {
      if(fcmToken != null){
        String uid = v.user!.uid;
        FirebaseDatabase.instance.ref("FCMTokens").child(global.usertype.collectionStrSam).child(uid).update({"Token": fcmToken});
      }
    });
    });
  }

  Future _checkuser() async {
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user != null) {
      user.getIdTokenResult().then((value) async {
        String type = value.claims?['usertype'];
        // if (securityrole == false) {
          if (type == "Therapist") {
            global.usertype = UserType.hosen;
          } else {
            if (type == "SocialWorker") {
              global.usertype = UserType.social;
            } else {
              if (type == "Reporter") {
                global.usertype = UserType.reporter;
              }
            }
          }
        }
      );
    }
  });
}
}
