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
  Map<String, String> enabledUsers = {};
  //Map<String, String> enabledUsersRegDate = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(setTitle()), centerTitle: true),
        body: Padding(
            padding: const EdgeInsets.all(7),
            child: Container(
                padding: const EdgeInsets.all(25),
                alignment: Alignment.center,
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      if ((snapshot.data as Map<String, String>).isNotEmpty) {
                        Map<String, String> t = snapshot.data as Map<String, String>;
                        return ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: t.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserInfo(
                                              uid: t.keys
                                                  .elementAt(index),
                                              userType: widget.type,
                                            )),
                                  ).then((value) => refreshState());
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(
                                        t.values.elementAt(index)),
                                    //subtitle: Text("מספר: " + enabledUsersRegDate.values.elementAt(index)),
                                    //isThreeLine: true,
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        );
                      } else {
                        return const Text("לא קיימים משתמשים להסרה");
                      }
                    }
                    return const Text('');
                  },
                  future: loadEnabledUsers(),
                ))));
  }

  Future<Map<String, String>> loadEnabledUsers() async {
    // await FirebaseFirestore.instance.terminate();
    // await FirebaseFirestore.instance.clearPersistence();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.type.collectionStr)
        .collection(widget.type.collectionStr)
        .where('enabled', isEqualTo: true)
        .get()
        .then((event) {
      List<QueryDocumentSnapshot> docs = event.docs;
      for (var doc in docs) {
        if (doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          enabledUsers.putIfAbsent(
              data['uid'], () => data['fname'] + " " + data['lname']);
        }
      }
    });
    return enabledUsers;
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
