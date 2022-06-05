import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:red_hosen/mytools.dart';

class MakeAdminconf extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
  final String uid;
  final UserType userType;
  const MakeAdminconf({required this.uid, required this.userType, Key? key})
      : super(key: key);
}

class _UserInfoState extends State<MakeAdminconf> {
  var mapvars = {};
  @override
  void initState() {
    super.initState();
    f();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          makeAdmin();
                      },
                      child: const Text("הוספת אדמין")
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
        Text(title, style: const TextStyle(fontSize: 16)),
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

  Future<void> makeAdmin() async {
    HttpsCallable enableuser =
        FirebaseFunctions.instance.httpsCallable('makeAdmin');
    await enableuser({"uid": widget.uid}).then((value) {
      showDialogMsg(context, MsgType.ok, "אישור משתמש בוצע בהצלחה")
          .then((value) {
        Navigator.pop(context);
      });
    });
  }

  Future<void> umMakeAdmin() async {
    HttpsCallable disableuser =
        FirebaseFunctions.instance.httpsCallable('unMakeAdmin');
    await disableuser({"uid": widget.uid}).then((value) {
      showDialogMsg(context, MsgType.ok, "אישור משתמש בוצע בהצלחה")
          .then((value) {
        Navigator.pop(context);
      });
    });
  }
}
