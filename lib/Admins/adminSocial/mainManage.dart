import 'package:flutter/material.dart';
import 'package:red_hosen/Admins/manageUsers/manageAdmins/secret/add_admin.dart';
import 'package:red_hosen/Admins/manageUsers/user_confirmation.dart';
import 'package:red_hosen/Admins/manageUsers/user_rejection.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';

class MainMagnageSocialPage extends StatefulWidget {
  const MainMagnageSocialPage({Key? key}) : super(key: key);

  @override
  State<MainMagnageSocialPage> createState() => _MainMagnageSocialPageState();
}

class _MainMagnageSocialPageState extends State<MainMagnageSocialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(title: const Text("ניהול משתמשים"), centerTitle: true),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: SingleChildScrollView(
                child: Column(children: [
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const UserConfirmation(type: UserType.social)),
                    );
                  },
                  child: const Text("אישור עובדים סוציאלים במערכת"),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const UserRejectionPage(type: UserType.social)),
                    );
                  },
                  child: const Text("מחיקת עובדים סוציאלים במערכת"),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const UserConfirmation(type: UserType.reporter)),
                    );
                  },
                  child: const Text("אישור צח\"ש במערכת"),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const UserRejectionPage(type: UserType.reporter)),
                    );
                  },
                  child: const Text("מחיקת צח\"ש במערכת"),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAdminPage(
                                  type: UserType.social,
                                )),
                      );
                    },
                    child: const Text("הוספת מנהלים למערכת"),
                  )),
            ]))));
  }
}
