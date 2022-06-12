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
              GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.green.shade400,
                  elevation: 14.0,
                  child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("אישור עובדים סוציאלים",
                                style: TextStyle(fontSize: 18)),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: const Icon(
                                  Icons.person_add_alt_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ))
                          ])),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserConfirmation(type: UserType.social)),
                  );
                },
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.orange.shade400,
                  elevation: 14.0,
                  child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("מחיקת עובדים סוציאלים",
                                style: TextStyle(fontSize: 18)),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: const Icon(
                                  Icons.person_add_disabled_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ))
                          ])),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserRejectionPage(type: UserType.social)),
                  );
                },
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.green.shade400,
                  elevation: 14.0,
                  child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("אישור צח\"ש",
                                style: TextStyle(fontSize: 18)),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: const Icon(
                                  Icons.person_add_alt_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ))
                          ])),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserConfirmation(type: UserType.reporter)),
                  );
                },
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.orange.shade400,
                  elevation: 14.0,
                  child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("מחיקת צח\"ש",
                                style: TextStyle(fontSize: 18)),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: const Icon(
                                  Icons.person_add_disabled_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ))
                          ])),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserRejectionPage(type: UserType.reporter)),
                  );
                },
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.red,
                  elevation: 14.0,
                  child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("הוספת מנהלים למערכת",
                                style: TextStyle(fontSize: 18)),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                child: const Icon(
                                  Icons.manage_accounts,
                                  color: Colors.white,
                                  size: 40,
                                ))
                          ])),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const AddAdminPage(type: UserType.social)),
                  );
                },
              ),
            ]))));
  }
}
