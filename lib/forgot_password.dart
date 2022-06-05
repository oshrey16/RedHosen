import 'package:flutter/material.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/mytools.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<ForgotPassPage> {
  final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('שכחתי סיסמא'), centerTitle: true),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 60, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              loginRegline(_emailController, "אימייל"),
              const SizedBox(height: 15),
              ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 160, height: 40),
                  child: forgotButton()),
              const SizedBox(height: 15),
            ],
          )),
    );
  }

  Widget forgotButton() {
    return ElevatedButton(
        onPressed: () async {
          if (_checkemail()) {
            context
                .read<AuthService>()
                .sendResetPassword(_emailController.text)
                .then((value) {
                showDialogMsg(context, MsgType.ok,
                        "אימייל נשלח! אנא בדוק את תיבת המייל")
                    .then((value) => Navigator.pop(context));
            }).catchError((error) {
              showDialogMsg(context, MsgType.error, "תיאור השגיאה: ${error.toString()}");
            });
          }
        },
        child: const Text('אפס סיסמא'));
  }

  Widget loginRegline(TextEditingController controller, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title + " :", style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        SizedBox(
          width: 200,
          height: 45.0,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TextField(
              maxLength: 45,
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                counterText: "",
                border: const OutlineInputBorder(),
                labelText: "הקלד " + title,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _checkemail() {
    bool secure = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text);
    if (secure == false) {
      showDialogMsg(context, MsgType.error, "אימייל לא חוקי");
    }
    return secure;
  }
}
