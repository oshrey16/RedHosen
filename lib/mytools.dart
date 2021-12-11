import 'package:flutter/material.dart';

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