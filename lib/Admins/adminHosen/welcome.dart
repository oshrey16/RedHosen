import 'package:flutter/material.dart';
import 'package:red_hosen/Admins/graphs.dart';
import 'package:red_hosen/Admins/manageUsers/manageAdmins/secret/secret_page.dart';
import 'package:red_hosen/Admins/manageUsers/user_confirmation.dart';
import 'package:red_hosen/Admins/manageUsers/user_rejection.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/Admins/map.dart';
import 'package:red_hosen/reporter/report_page.dart';
import 'package:red_hosen/active_reports.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("מנהל חוסן - ראשי"),
          centerTitle: true,
        ),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: SingleChildScrollView(
              child: Column(children: [
                //TODO - DONT FORGET TO DELETE!!!!
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SecretPage()),
                        );
                      },
                      child: const Text("דף סודי"),
                    )),
                const SizedBox(height: 15),
                //TODO - DONT FORGET TO DELETE!!!!
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
                              builder: (context) => const UserRejectionPage(
                                  type: UserType.hosen)),
                        );
                      },
                      child: const Text("מחיקת מטפלים במערכת"),
                    )),
                const SizedBox(height: 15),
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapPage()),
                        );
                      },
                      child: const Text("מפת הכאב"),
                    )),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportPage()),
                      );
                    },
                    child: const Text("צור דיווח"),
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
                            builder: (context) => const ActiveReports()),
                      );
                    },
                    child: const Text("דיווחים פעילים"),
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
                            builder: (context) => const GrapghsPage()),
                      );
                    },
                    child: const Text("גרפים"),
                  ),
                ),
                const SizedBox(height: 15),
                logoutButton(context),
              ]),
            )));
  }
}
