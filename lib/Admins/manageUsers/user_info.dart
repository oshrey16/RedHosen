import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
  final String uid;
  final UserType userType;
  const UserInfo({required this.uid, required this.userType, Key? key})
      : super(key: key);
}

class _UserInfoState extends State<UserInfo> {
  var mapvars = {};
  @override
  void initState() {
    super.initState();
    f();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('פרטי משתמש'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 60, 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                detailUserLine("שם פרטי", mapvars['fname']),
                detailUserLine("שם משפחה", mapvars['lname']),
                detailUserLine("תעודת זהות", mapvars['id']),
                detailUserLine("אימייל", mapvars['email']),
                detailUserLine("מספר טלפון", mapvars['phone']),
                ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 160, height: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        if (mapvars['enabled'] == false) {
                          enableUser();
                        } else {
                          if (mapvars['enabled'] == true) {
                            disableUser();
                          }
                        }
                      },
                      child: mapvars['enabled'] == false
                          ? const Text("הוסף משתמש")
                          : const Text("הסר משתמש"),
                    ))
              ])),
    );
  }

  Widget detailUserLine(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          width: 200,
          height: 45.0,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TextField(
              textAlign: TextAlign.center,
              maxLength: 45,
              controller: TextEditingController()..text = value,
              enabled: false,
              textAlignVertical: TextAlignVertical.center,
              autofocus: true,
            ),
          ),
        ),
        Text("   :" + title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  void f() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(widget.userType.collectionStr)
        .collection(widget.userType.collectionStr)
        .where("uid", isEqualTo: widget.uid)
        .get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    if (docs.length == 1) {
      if (docs[0].data() != null) {
        var data = docs[0].data() as Map<String, dynamic>;
        setState(() {
          mapvars = data;
        });
      }
    }
  }

  Future<void> enableUser() async {
    HttpsCallable enableuser =
        FirebaseFunctions.instance.httpsCallable('updateUserEnable');
    await enableuser(
            {"uid": widget.uid, "collection": widget.userType.collectionStr})
        .then((value) async {
      if (value.data == 'success') {
        showDialogMsg(context, MsgType.ok, "אישור משתמש בוצע בהצלחה")
            .then((value) {
          Navigator.pop(context);
        });
      }
    });
  }

  Future<void> disableUser() async {
    HttpsCallable disableuser =
        FirebaseFunctions.instance.httpsCallable('updateUserDisable');
    await disableuser(
            {"uid": widget.uid, "collection": widget.userType.collectionStr})
        .then((value) async {
      if (value.data == 'success') {
        showDialogMsg(context, MsgType.ok, "ביטול משתמש בוצע בהצלחה")
            .then((value) {
          Navigator.pop(context);
        });
      }
    });
    //     .then((value) async {
    //   if (value.data.result == 'success') {
    //     showDialogMsg(context, MsgType.ok, "רישום בוצע בהצלחה");
    //     // Navigator.pop(context);
    //   }
    // }
    // );
    // print(s.data);
  }
}
