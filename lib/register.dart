import 'package:flutter/material.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/mytools.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailControllerValid = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordControllerValid = TextEditingController();
  final _phoneController = TextEditingController();
  final List<String> usertypes = ['בחר', 'מטפל', 'מדווח', 'עובד סוציאלי'];
  String selectedUsertype = 'בחר';
  final PasswordVisible _p1 = PasswordVisible();
  final PasswordVisible _p2 = PasswordVisible();
  //bool _passwordVisible = true;
  //bool _passwordVisible2 = true;
  var mapvars = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text('הרשמה למערכת'), centerTitle: true),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
            child: Column(children: [
              const SizedBox(height: 15),
              loginRegline(_fnameController, "שם פרטי"),
              const SizedBox(height: 15),
              loginRegline(_lnameController, "שם משפחה"),
              const SizedBox(height: 15),
              loginRegline(_idController, "ת.ז"),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                DropdownButton<String>(
                    value: selectedUsertype,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUsertype = newValue!;
                      });
                    },
                    items:
                        usertypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
                const Text(" :סוג משתמש", style: TextStyle(fontSize: 16)),
              ]),
              const SizedBox(height: 15),
              loginRegline(_emailController, "דואר אלקטרוני"),
              const SizedBox(height: 15),
              loginRegline(_emailControllerValid, "אימות דואר אלקטרוני"),
              const SizedBox(height: 15),
              loginReglinePassword(_passwordController, "סיסמא", _p1),
              const SizedBox(height: 15),
              loginReglinePassword(
                  _passwordControllerValid, "אימות סיסמא", _p2),
              const SizedBox(height: 15),
              loginRegline(_phoneController, "מספר טלפון"),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    mapvars = {
                      'fname': _fnameController.text,
                      'lname': _lnameController.text,
                      'idcon': _idController.text,
                      'email': _emailController.text.trim(),
                      'emailv': _emailControllerValid.text.trim(),
                      'password': _passwordController.text,
                      'passwordv': _passwordControllerValid.text,
                      'phone': _phoneController.text,
                      'usertype': selectedUsertype == "בחר"
                          ? mapvars['usertype'] = 'בחר'
                          : userTypedb(),
                      'claimtype': _convertusertype(),
                    };
                    if (procvars()) {
                      context
                          .read<AuthService>()
                          .signUp(context, mapvars)
                          .then((value) {
                        showDialogMsg(context, MsgType.ok,
                                "ההרשמה התבצעה בהצלחה\nתוכל להתחבר למערכת לאחר אישור המנהל")
                            .then((value) => Navigator.pop(context));
                        //Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('הירשם')),
            ])));
  }

  Widget loginRegline(TextEditingController controller, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
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
        Text("   :" + title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget loginReglinePassword(TextEditingController controller, String title,
      PasswordVisible passwordVisible) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
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
              obscureText: passwordVisible.value,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "הקלד " + title,
                  counterText: "",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible.value = !passwordVisible.value;
                      });
                    },
                  )),
            ),
          ),
        ),
        Text("   :" + title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  bool _checkvars() {
    List<String> e = [];
    if (mapvars['fname'] == '') {
      e.add('שם פרטי');
    }
    //check lname
    if (mapvars['lname'] == '') {
      e.add('שם משפחה');
    }
    //check idcon
    if (mapvars['idcon'] == '') {
      e.add('תעודת זהות');
    }
    //check email
    if (mapvars['email'] == '') {
      e.add('אימייל');
    }
    //check emailv
    if (mapvars['emailv'] == '') {
      e.add('איימיל שנית');
    }
    //check password
    if (mapvars['password'] == '') {
      e.add('סיסמא');
    }
    //check passwordv
    if (mapvars['passwordv'] == '') {
      e.add('סיסמא שנית');
    }
    //check phone
    if (mapvars['phone'] == '') {
      e.add('טלפון');
    }
    //check selecteduser
    if (mapvars['usertype'] == "בחר") {
      e.add('סוג משתמש');
    }

    if (e.isNotEmpty) {
      showDialogMsg(context, MsgType.error, "אנא הזן: " + e.join(' ,'));
      return false;
    }
    return true;
  }

  bool procvars() {
    if (_checkvars()) {
      if (_checkid()) {
        if (_checkemail()) {
          if (_checkEmailv()) {
            if (_checkPassword()) {
              if (_checkPasswordv()) {
                if (_checkphone()) {
                  return true;
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  _checkid() {
    bool secure = RegExp(r"^[0-9]{9}$").hasMatch(mapvars['idcon']);
    if (secure == false) {
      showDialogMsg(context, MsgType.error, "תעודת זהות לא תקינה");
    }
    return secure;
  }

  _checkemail() {
    bool secure = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(mapvars['email']);
    if (secure == false) {
      showDialogMsg(context, MsgType.error, "אימייל לא חוקי");
    }
    return secure;
  }

  _checkEmailv() {
    bool secure = mapvars['email'] == mapvars['emailv'];
    if (secure == false) {
      showDialogMsg(context, MsgType.error,
          "אימייל לא תואם\n אנא הקלד שוב את כתובת הדואר");
    }
    return secure;
  }

  _checkPassword() {
    bool secure =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(mapvars['password']);
    if (secure == false) {
      showDialogMsg(context, MsgType.error,
          ":סיסמא לא תקינה, אנא הזן סיסמא בעלת\n אות גדולה אחת-\n אות קטנה אחת-\n תו מיוחד-\n ספרה אחת- \n לפחות 8 ספרות-");
    }
    return secure;
  }

  _checkPasswordv() {
    bool secure = mapvars['password'] == mapvars['passwordv'];
    if (secure == false) {
      showDialogMsg(
          context, MsgType.error, "סיסמא לא תואמת\n אנא הקלד שוב את הסיסמא");
    }
    return secure;
  }

  _checkphone() {
    bool secure = RegExp(r"^[0-9]{10}$").hasMatch(mapvars['phone']);
    if (secure == false) {
      showDialogMsg(context, MsgType.error, "מספר טלפון לא תקין");
    }
    return secure;
  }

  _convertusertype() {
    if (selectedUsertype == 'מטפל') {
      return 'Therapist';
    }
    if (selectedUsertype == 'מדווח') {
      return 'Reporter';
    }
    if (selectedUsertype == 'עובד סוציאלי') {
      return 'SocialWorker';
    }
    return 'erroruser';
  }

  String userTypedb() {
    String st = "Users";
    st += _convertusertype();
    return st;
  }
}

class PasswordVisible {
  bool value;
  PasswordVisible({this.value = true});
}