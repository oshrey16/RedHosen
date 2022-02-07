import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_hosen/Admins/user_info.dart';
import 'package:red_hosen/mytools.dart';

class UserConfirmation extends StatefulWidget {
  const UserConfirmation({Key? key}) : super(key: key);
  @override
  _UserConfirmationState createState() => _UserConfirmationState();
}

class _UserConfirmationState extends State<UserConfirmation> {
  @override
  void initState() {
    super.initState();
    disabledUsers = {};
    loadDisabledUsers();
  }

  Map<String, String> disabledUsers = {};
  //Map<String, String> disabledUsersRegDate = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:
            AppBar(title: const Text('אישור מטפלים במערכת'), centerTitle: true),
        body: Padding(
            padding: const EdgeInsets.all(7),
            child: Container(
                padding: const EdgeInsets.all(25),
                alignment: Alignment.center,
                child: disabledUsers.isNotEmpty
                    ? ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: disabledUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserInfo(
                                            uid: disabledUsers.keys
                                                .elementAt(index),
                                            userType: UserType.hosen,
                                          )),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(
                                      disabledUsers.values.elementAt(index)),
                                  //subtitle: Text("מספר: " + disabledUsersRegDate.values.elementAt(index)),
                                  //isThreeLine: true,
                                ),
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      )
                    : const Text("לא קיימים משתמשים חדשים"))));
  }

  void loadDisabledUsers() async {
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    FirebaseFirestore.instance
        .collection("Userstherapist")
        .where('enabled', isEqualTo: false)
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> docs = event.docs;
      for (var doc in docs) {
        if (doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          disabledUsers.putIfAbsent(
              data['uid'], () => data['fname'] + " " + data['lname']);
        }
      }
      setState(() {});
    });
  }
}

class UserrejectionPage extends StatefulWidget {
  const UserrejectionPage({Key? key}) : super(key: key);
  @override
  _UserrejectionPageState createState() => _UserrejectionPageState();
}

class _UserrejectionPageState extends State<UserrejectionPage> {
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: const Text('מחיקת מטפלים במערכת'),
            centerTitle: true),
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
                                            userType: UserType.hosen,
                                          )),
                                );
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
                    : const Text("לא קיימים משתמשים"))));
  }

  void loadEnabledUsers() async {
        await FirebaseFirestore.instance.terminate();
        await FirebaseFirestore.instance.clearPersistence();
        FirebaseFirestore.instance
        .collection("Userstherapist")
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
  }