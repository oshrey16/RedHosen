import 'package:flutter/material.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReadPage extends StatelessWidget {
  const PdfReadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(title: const Text("אוגדן"), centerTitle: true),
        body: SfPdfViewer.asset('assets/ogdan.pdf'));
  }
}