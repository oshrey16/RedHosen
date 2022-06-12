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
            // padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                            const Text("אישור מטפלים",
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
                            const UserConfirmation(type: UserType.hosen)),
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
                            
                                const Text("מחיקת מטפלים",
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
                            const UserRejectionPage(type: UserType.hosen)),
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
                   
                                const Text("הוספת מנהל מערכת",
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
                        builder: (context) => const AddAdminPage(
                              type: UserType.hosen,
                            )),
                  );
                },
              ),
            ]))));
  }
}
