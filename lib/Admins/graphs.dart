import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class GrapghsPage extends StatefulWidget {
  const GrapghsPage({Key? key}) : super(key: key);

  @override
  State<GrapghsPage> createState() => _GrapghsPageState();
}

class _GrapghsPageState extends State<GrapghsPage> {
  final List<DateTime> dates = [];
  final Map mapdates = {};
  final List<DateCount> dt = <DateCount>[];
  final List<SalesData> chartData = <SalesData>[
    SalesData(DateTime(2006, 1, 1), 'India', 1.5, 21, 28, 680, 760),
    SalesData(DateTime(2006, 2, 1), 'China', 2.2, 24, 44, 550, 880),
    SalesData(DateTime(2006, 3, 1), 'USA', 3.32, 36, 48, 440, 788),
    SalesData(DateTime(2006, 4, 1), 'Japan', 4.56, 38, 50, 350, 560),
    SalesData(DateTime(2006, 5, 1), 'Russia', 5.87, 54, 66, 444, 566),
    SalesData(DateTime(2006, 6, 1), 'France', 6.8, 57, 78, 780, 650),
    SalesData(DateTime(2006, 7, 1), 'Germany', 8.5, 70, 84, 450, 800)
  ];

  @override
  void initState() {
    super.initState();
  }

  // List<DateTime,String> ddd = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("גרפים"),
          centerTitle: true,
        ),
        body: Column(children: [
          FutureBuilder(future: loadReports() ,
          builder: (context, snapshot) {
          //Initialize the chart widget
          return SfCartesianChart(
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
              ]);})
        ]));
  }

  Future loadReports() async {
    dates.clear();
    await FirebaseFirestore.instance.collection("Reports").get().then((value) {
      var f = value.docs.map((doc) => doc.data()).toList();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      for (var item in f) {
        Timestamp ts = item['time'];
        String dateformatted = formatter.format(ts.toDate());
        DateTime ff = DateTime.parse(dateformatted);
        dates.add(ff);
      }
      _calcCountDate();
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
    // print(mapdates);
  }
  void setDateTimecls(){
    dt.clear();
  for(var element in mapdates.entries){
    dt.add(DateCount(element.key,element.value));
  }
  for(var e in dt){
    print(e.date);
  }
}
}



class SalesData {
  SalesData(this.date, this.a, this.b, this.c, this.d, this.e, this.f);

  final DateTime date;
  final String a;
  final double b;
  final int c;
  final int d;
  final int e;
  final int f;
}

class DateCount{
  final DateTime date;
  final int count;
  DateCount(this.date,this.count);
}
