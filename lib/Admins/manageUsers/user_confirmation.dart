import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_hosen/Admins/manageUsers/user_info.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';

class UserConfirmation extends StatefulWidget {
  final UserType type;
  const UserConfirmation({required this.type, Key? key}) : super(key: key);

  @override
  _UserConfirmationState createState() => _UserConfirmationState();
}

class _UserConfirmationState extends State<UserConfirmation> {
  Map<String, String> disabledUsers = {};

  @override
  void initState() {
    super.initState();
  }
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
                        Map<String, String> t =
                            snapshot.data as Map<String, String>;
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
                                              uid: t.keys.elementAt(index),
                                              userType: widget.type,
                                            )),
                                  ).then((value) => refreshState());
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(t.values.elementAt(index)),
                                    //subtitle: Text("מספר: " + tRegDate.values.elementAt(index)),
                                    //isThreeLine: true,
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        );
                      } else {
                        return const Text("אין משתמשים חדשים");
                      }
                    }
                    return const Text('');
                  },
                  future: loadDisabledUsers(),
                ))));
  }

  Future loadDisabledUsers() async {
    // await FirebaseFirestore.instance.terminate();
    // await FirebaseFirestore.instance.clearPersistence();
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.type.collectionStr)
        .collection(widget.type.collectionStr)
        .where('enabled', isEqualTo: false)
        .get()
        .then((event) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = event.docs;
      for (var doc in docs) {
        if (doc.data() != null) {
          var data = doc.data();
          disabledUsers.putIfAbsent(
              data['uid'], () => data['fname'] + " " + data['lname']);
        }
      }
      return disabledUsers;
    });
  }

  String setTitle() {
    if (widget.type == UserType.hosen) {
      return "אישור מטפלים במערכת";
    }
    if (widget.type == UserType.social) {
      return "אישור עובדים סוציאליים במערכת";
    }
    if (widget.type == UserType.reporter) {
      return "אישור מדווחים במערכת";
    }
    return "";
  }

  refreshState() {
    setState(() {
      disabledUsers = {};
      loadDisabledUsers();
    });
  }
}
