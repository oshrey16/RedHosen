import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_hosen/Admins/manageUsers/manageAdmins/secret/make_admin.dart';
import 'package:red_hosen/mytools.dart';

class AddAdminPage extends StatefulWidget {
  final UserType type;
  const AddAdminPage({required this.type, Key? key}) : super(key: key);

  @override
  _UserConfirmationState createState() => _UserConfirmationState();
}

class _UserConfirmationState extends State<AddAdminPage> {
  Map<String, String> _users = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text("הוספת אדמין"), centerTitle: true),
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
                          itemCount: _users.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MakeAdminconf(
                                              uid: _users.keys.elementAt(index),
                                              userType: widget.type,
                                            )),
                                  ).then((value) => refreshState());
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(_users.values.elementAt(index)),
                                    //subtitle: Text("מספר: " + disabledUsersRegDate.values.elementAt(index)),
                                    //isThreeLine: true,
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        );
                      } else {
                        return const Text("לא נמצאו משתמשים");
                      }
                    }
                    return const Text('');
                  },
                  future: loadUsers(),
                ))));
  }

  Future<Map<String, String>> loadUsers() async {
    // await FirebaseFirestore.instance.terminate();
    // await FirebaseFirestore.instance.clearPersistence();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(UserType.hosen.collectionStr)
        .collection(UserType.hosen.collectionStr)
        .where('enabled', isEqualTo: true)
        .get()
        .then((event) {
      List<QueryDocumentSnapshot> docs = event.docs;
      for (var doc in docs) {
        if (doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          _users.putIfAbsent(
              data['uid'], () => data['fname'] + " " + data['lname']);
        }
      }
    });
    FirebaseFirestore.instance
        .collection("Users")
        .doc(UserType.social.collectionStr)
        .collection(UserType.social.collectionStr)
        .where('enabled', isEqualTo: true)
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> docs = event.docs;
      for (var doc in docs) {
        if (doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          _users.putIfAbsent(
              data['uid'], () => data['fname'] + " " + data['lname']);
        }
      }
    });
    return _users;
  }

  refreshState() {
    setState(() {
      _users = {};
      loadUsers();
    });
  }
}
