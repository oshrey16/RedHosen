import 'package:flutter/material.dart';
import 'package:red_hosen/Admins/manageUsers/user_confirmation.dart';
import 'package:red_hosen/Admins/manageUsers/user_rejection.dart';
import 'package:red_hosen/Admins/map.dart';
import 'package:red_hosen/active_reports.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/reporter/report_page.dart';
import 'package:red_hosen/slideBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
        appBar: AppBar(
          title: const Text("מנהל רווחה - ראשי"),
          centerTitle: true,
        ),
        body: Container(
            alignment: Alignment.topCenter,
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
                            builder: (context) => const UserConfirmation(type: UserType.social)),
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
                            builder: (context) => const UserRejectionPage(type: UserType.social)),
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
                            builder: (context) => const UserConfirmation(type:UserType.reporter)),
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
                            builder: (context) => const UserRejectionPage(type:UserType.reporter)),
                      );
                    },
                    child: const Text("מחיקת צח\"ש במערכת"),
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
                          builder: (context) =>
                              const ReportPage()),
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
                          builder: (context) =>
                              const ActiveReports()),
                    );
                  },
                  child: const Text("דיווחים פעילים"),
                ),
              ),
              ]),
            )));
  }
}
