import 'package:flutter/material.dart';
import 'package:red_hosen/active_reports.dart';
import 'package:red_hosen/custom_icons_icons.dart';
import 'package:red_hosen/in_progress.dart';
import 'package:red_hosen/my_reports.dart';
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("צור דיווח",
                                      style: TextStyle(fontSize: 25)),
                                  Text("דווח על אירוע חירום"),
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: const Icon(
                                    Icons.report_gmailerrorred,
                                    color: Colors.white,
                                    size: 40,
                                  ))
                            ])),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportPage()),
                    );
                  },
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.amber.shade900,
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
                                  Text("דיווחים חדשים",
                                      style: TextStyle(fontSize: 25)),
                                  Text("צפה בדיווחים הדורשים טיפול"),
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: const Icon(
                                    CustomIcons.alarm_svgrepo_com__1_,
                                    color: Colors.white,
                                    size: 40,
                                  ))
                            ])),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ActiveReports()),
                    );
                  },
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.yellow.shade700,
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
                                  Text("דיווחים בטיפול",
                                      style: TextStyle(fontSize: 25)),
                                  Text("צפה בדיווחים שבתהליך טיפול"),
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: const Icon(
                                    CustomIcons.health_care_doctor_svgrepo_com,
                                    color: Colors.white,
                                    size: 40,
                                  ))
                            ])),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InProgressReports()),
                    );
                  },
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.green,
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
                                  Text("הדיווחים שלי",
                                      style: TextStyle(fontSize: 25)),
                                  Text("צפה בדיווחים שדווחו על ידי"),
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: const Icon(
                                    CustomIcons.documents_svgrepo_com,
                                    color: Colors.white,
                                    size: 40,
                                  ))
                            ])),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyReports()),
                    );
                  },
                ),
              ]),
            )));
  }
}
