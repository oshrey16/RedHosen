import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GrapghsPage extends StatefulWidget {
  const GrapghsPage({Key? key}) : super(key: key);

  @override
  State<GrapghsPage> createState() => _GrapghsPageState();
}

class _GrapghsPageState extends State<GrapghsPage> {
  final List<DateTime> dates = [];
  final Map mapdates = {};
  final List<DateCount> dt = <DateCount>[];

  final List<ReportPriority> prioritylst = [];
  final Map mapPriority = {};
  final List<PriorityCount> pr = <PriorityCount>[];
  @override
  void initState() {
    FirebaseFirestore.instance.clearPersistence();
    super.initState();
  }

  // List<DateTime,String> ddd = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("גרפים"),
          centerTitle: true
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          FutureBuilder(
              future: loadReports(),
              builder: (context, snapshot) {
                //Initialize the chart widget
                return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                    child: Column(
                      children: [
                        SfCartesianChart(
                            primaryXAxis: DateTimeAxis(),
                            // Chart title
                            title: ChartTitle(text: 'מספר אירועים שדווחו'),
                            // Enable legend
                            // legend: Legend(isVisible: true),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<DateCount, DateTime>>[
                              LineSeries<DateCount, DateTime>(
                                dataSource: dt,
                                xValueMapper: (DateCount data, _) => data.date,
                                yValueMapper: (DateCount data, _) => data.count,
                              )
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("מספר דיווחים לפי רמת חומרה"),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <ChartSeries<PriorityCount, String>>[
                                  StackedColumnSeries<PriorityCount, String>(
                                    dataSource: pr,
                                    xValueMapper: (PriorityCount item, _) =>
                                        item.priority.collectionStr,
                                    yValueMapper: (PriorityCount item, _) =>
                                        item.count,
                                  ),
                                ])),
                      ],
                    ));
              })
        ])));
  }

  Future loadReports() async {
    dates.clear();
    prioritylst.clear();
    await FirebaseFirestore.instance.collection("Reports").get().then((value) {
      var f = value.docs.map((doc) => doc.data()).toList();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      for (var item in f) {
        Timestamp ts = item['time'];
        String dateformatted = formatter.format(ts.toDate());
        DateTime ff = DateTime.parse(dateformatted);
        dates.add(ff);

        // Load Priority
        var pstr = item['priority'];
        prioritylst.add(convertPriority(pstr));
      }
      _calcCountDate();
      _calcCountPriority();
    });
  }

  void _calcCountDate() {
    mapdates.clear();
    for (var element in dates) {
      if (!mapdates.containsKey(element)) {
        mapdates[element] = 1;
      } else {
        mapdates[element] += 1;
      }
    }
    setDateTimecls();
  }

  void setDateTimecls() {
    dt.clear();
    for (var element in mapdates.entries) {
      dt.add(DateCount(element.key, element.value));
    }

    dt.sort((a,b) => a.date.compareTo(b.date));
    for(var d in dt){
      print(d.date);
    }
  }

  ReportPriority convertPriority(String str) {
    if (str == "גבוה") return ReportPriority.high;
    if (str == "בינוני") return ReportPriority.medium;
    return ReportPriority.low;
  }

  void _calcCountPriority() {
    mapPriority.clear();
    for (var element in prioritylst) {
      if (!mapPriority.containsKey(element)) {
        mapPriority[element] = 1;
      } else {
        mapPriority[element] += 1;
      }
    }
    setPrioritycls();
  }

  void setPrioritycls() {
    pr.clear();
    for (var element in mapPriority.entries) {
      pr.add(PriorityCount(element.key, element.value));
    }
  }
}

class DateCount {
  final DateTime date;
  final int count;
  DateCount(this.date, this.count);
}

class PriorityCount {
  final ReportPriority priority;
  final int count;
  PriorityCount(this.priority, this.count);
}
