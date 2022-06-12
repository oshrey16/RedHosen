import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  // User Uid
  late String useruid;
  String? name;
  final _message = TextEditingController();

  @override
  void initState() {
    setUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: const Text("מנהל חוסן - ראשי"),
          centerTitle: true,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              // textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("שם:"),
                const SizedBox(width: 20),
                Text(name ?? "אנונימי")
              ],
            ),
            Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                width: MediaQuery.of(context).size.width - 40,
                child: TextField(
                  decoration:
                      const InputDecoration.collapsed(hintText: 'הקלד דיווח'),
                  keyboardType: TextInputType.multiline,

                  minLines: 4, //Normal textInputField will be displayed
                  maxLines: 5, // when user presses enter it will adapt to it
                  maxLength: 400,
                  controller: _message,
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  )),
              onPressed: () async {
                final Email email = Email(
                  body: _message.text,
                  subject: 'דיווח על תקלה',
                  recipients: ['foxGdev@gmail.com'],
                  isHTML: false,
                );
                await FlutterEmailSender.send(email);
              },
              child: const Text("שלח דיווח"),
            ),
          ]),
        ));
  }

  // Set Username To this report
  void setUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      useruid = user.uid;
      name = user.displayName ?? '';
    }
  }
}
