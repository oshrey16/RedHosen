import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:red_hosen/main.dart';

enum MsgType {
  error,
  ok,
  alert,
}

extension MsgTypEx on MsgType {
  String get str {
    switch (this) {
      case MsgType.alert:
        return "התראה";
      case MsgType.error:
        return "שגיאה";
      case MsgType.ok:
        return "אישור";
      default:
        return "";
    }
  }
}

Future showDialogMsg(BuildContext context, MsgType title, String t) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title.str),
        actionsAlignment: MainAxisAlignment.center,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(t),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('אישור'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

enum UserType {
  hosen,
  social,
  reporter,
  nil,
}

extension UserTypeEx on UserType {
  String get collectionStr {
    switch (this) {
      case UserType.hosen:
        return "UsersTherapist";
      case UserType.social:
        return "UsersSocialWorker";
      case UserType.reporter:
        return "UsersReporter";
      case UserType.nil:
        return "UsersReporter";
    }
  }
}

/////EorD - enabled or diabled
enum EorD {
  enabled,
  disabled,
}

Widget logoutButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () async {
      context.read<AuthService>().logout();
      await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthWrapper()));
    },
    child: const Text("התנתק"),
  );
}

enum institution {
  hosen,
  social,
}

// TODO SET in report
enum ReportPriority {
  high,
  medium,
  low,
}
