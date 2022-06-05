import 'package:flutter/material.dart';
import 'package:red_hosen/Admins/adminSocial/mainManage.dart';
import 'package:red_hosen/Admins/export_reports.dart';
import 'package:red_hosen/Admins/graphs.dart';
import 'package:red_hosen/Admins/map.dart';
import 'package:red_hosen/custom_icons_icons.dart';
import 'package:red_hosen/slideBar.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar:
            AppBar(title: const Text("מנהל רווחה - דף מנהל"), centerTitle: true),
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
                    color: Colors.orange.shade400,
                    elevation: 14.0,
                    child: Container(
                        height: 80,
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("ניהול משתמשים",
                                      style: TextStyle(fontSize: 25)),
                                  Text("נהל את המשמשים במערכת"),
                                ],
                              ),
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
                          builder: (context) => const MainMagnageSocialPage()),
                    );
                  },
                ),
                const SizedBox(height: 15),

                GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.red.shade400,
                    elevation: 14.0,
                    child: Container(
                        height: 80,
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("מפת העיר",
                                      style: TextStyle(fontSize: 25)),
                                  Text("מפה ממופה לפי איזורי נפגעים"),
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: const Icon(
                                    Icons.map_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ))
                            ])),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapPage()),
                    );
                  },
                ),
                const SizedBox(height: 15),

                GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.blue.shade600,
                    elevation: 14.0,
                    child: Container(
                        height: 80,
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("גרפים", style: TextStyle(fontSize: 25)),
                                  Text("צפה בגרפי מידע"),
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: const Icon(
                                    CustomIcons.monitorGraphSvgrepo,
                                    color: Colors.white,
                                    size: 40,
                                  ))
                            ])),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GrapghsPage()),
                    );
                  },
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.green.shade300,
                    elevation: 14.0,
                    child: Container(
                        height: 80,
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("הפקת דוח",
                                      style: TextStyle(fontSize: 25)),
                                  Text("הפק דוחות השמורים במערכת"),
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: const Icon(
                                    CustomIcons.exportSvgrepo,
                                    color: Colors.white,
                                    size: 40,
                                  ))
                            ])),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExportReportsPage()),
                    );
                  },
                ),
              ]),
            )));
  }
}
