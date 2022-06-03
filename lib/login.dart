import 'package:flutter/material.dart';
import 'package:red_hosen/Admins/manageUsers/manageAdmins/secret/secret_page.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/register.dart';
import 'package:red_hosen/mytools.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('כניסה למערכת'), centerTitle: true),
        body: Container(
          alignment: AlignmentDirectional.center,
          width: MediaQuery.of(context).size.width - 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              loginRegline(_emailController, "אימייל"),
              const SizedBox(height: 15),
              loginReglinePassword(_passwordController, "סיסמא"),
              const SizedBox(
                height: 30,
              ),
              loginButton(),
              const SizedBox(height: 15),
              registerButton(),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassPage()));
                },
                child: const Text(
                  'שכחתי סיסמא',
                ),
              ),
            ],
          ),
        ));
  }

  Widget registerButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width / 2, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          )),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      child: const Text("הרשמה"),
    );
  }

  Widget loginButton() {
    return ElevatedButton(
        key: const Key("LoginButton"),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width / 2, 50),
            primary: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            )),
        onPressed: () async {
          final String email = _emailController.text.trim();
          final String password = _passwordController.text.trim();
          if (email.isNotEmpty && password.isNotEmpty) {
            context.read<AuthService>().login(email, password).then((value) {
              if (value != "Logged In") {
                showDialogMsg(
                    context, MsgType.error, "שם משתמש או סיסמא לא נכונים");
              }
            });
          } else {
            if (email.isEmpty) {
              showDialogMsg(context, MsgType.error, "אימייל לא תקין");
            } else {
              showDialogMsg(context, MsgType.error, "סיסמה לא תקינה");
            }
          }
        },
        child: const Text('התחבר'));
  }

  Widget loginRegline(TextEditingController controller, String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          key: const Key("Email"),
          maxLength: 45,
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          autofocus: false,
          decoration: InputDecoration(
            counterText: "",
            border: const OutlineInputBorder(),
            labelText: title,
          ),
        ),
      ),
    );
  }

  Widget loginReglinePassword(TextEditingController controller, String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          maxLength: 45,
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          autofocus: false,
          obscureText: _passwordVisible,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: title,
              counterText: "",
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )),
        ),
      ),
    );
  }
}
