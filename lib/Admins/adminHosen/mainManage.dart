import 'package:flutter/material.dart';
import 'package:red_hosen/Admins/manageUsers/manageAdmins/secret/add_admin.dart';
import 'package:red_hosen/Admins/manageUsers/user_confirmation.dart';
import 'package:red_hosen/Admins/manageUsers/user_rejection.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';

class MainMagnageHosenPage extends StatefulWidget {
  const MainMagnageHosenPage({Key? key}) : super(key: key);

  @override
  State<MainMagnageHosenPage> createState() => _MainMagnageHosenPageState();
}

class _MainMagnageHosenPageState extends State<MainMagnageHosenPage> {
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
                                const UserConfirmation(type: UserType.hosen)),
                      );
                    },
                    child: const Text("אישור מטפלים במערכת"),
                  )),
              const SizedBox(height: 15),
              SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const UserRejectionPage(type: UserType.hosen)),
                      );
                    },
                    child: const Text("מחיקת מטפלים במערכת"),
                  )),
              const SizedBox(height: 15),
              SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAdminPage(
                                  type: UserType.hosen,
                                )),
                      );
                    },
                    child: const Text("הוספת מנהלים למערכת"),
                  )),
            ]))));
  }
}
