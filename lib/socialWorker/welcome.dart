import 'package:flutter/material.dart';
import 'package:red_hosen/active_reports.dart';
import 'package:red_hosen/in_progress.dart';
import 'package:red_hosen/my_reports.dart';
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
        drawer: NavDrawer(),
        appBar:
            AppBar(title: const Text("עובד סוציאלי - ראשי"), centerTitle: true),
        body: Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(children: [
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
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyReports()),
                      );
                    },
                    child: const Text("הדוחות שלי"),
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
                            builder: (context) => const InProgressReports()),
                      );
                    },
                    child: const Text("דוחות בטיפול"),
                  ),
                ),
              ]),
            )));
  }
}
