import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_hosen/Admins/manageUsers/user_info.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';

class UserRejectionPage extends StatefulWidget {
  final UserType type;
  const UserRejectionPage({required this.type, Key? key}) : super(key: key);
  @override
  _UserRejectionPageState createState() => _UserRejectionPageState();
}

class _UserRejectionPageState extends State<UserRejectionPage> {
  @override
  void initState() {
    super.initState();
    enabledUsers = {};
    loadEnabledUsers();
  }

  Map<String, String> enabledUsers = {};
  //Map<String, String> enabledUsersRegDate = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(setTitle()), centerTitle: true),
        body: Padding(
            padding: const EdgeInsets.all(7),
            child: Container(
                padding: const EdgeInsets.all(25),
                alignment: Alignment.center,
                child: enabledUsers.isNotEmpty
                    ? ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: enabledUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserInfo(
                                            uid: enabledUsers.keys
                                                .elementAt(index),
                                            userType: widget.type,
                                          )),
                                ).then((value) => refreshState());
                              },
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(
                                      enabledUsers.values.elementAt(index)),
                                  //subtitle: Text("מספר: " + enabledUsersRegDate.values.elementAt(index)),
                                  //isThreeLine: true,
                                ),
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      )
                    : const Text("לא קיימים משתמשים חדשים"))));
  }

  void loadEnabledUsers() async {
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.type.collectionStr)
        .collection(widget.type.collectionStr)
        .where('enabled', isEqualTo: true)
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> docs = event.docs;
      for (var doc in docs) {
        if (doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          enabledUsers.putIfAbsent(
              data['uid'], () => data['fname'] + " " + data['lname']);
        }
      }
      setState(() {});
    });
  }

  String setTitle() {
    if (widget.type == UserType.hosen) {
      return "מחיקת מטפלים במערכת";
    }
    if (widget.type == UserType.social) {
      return "מחיקת עובדים סוציאליים במערכת";
    }
    if (widget.type == UserType.reporter) {
      return "מחיקת מדווחים במערכת";
    }
    return "";
  }
  
  refreshState() {
    setState(() {
      enabledUsers = {};
      loadEnabledUsers();
    });
  }
}
