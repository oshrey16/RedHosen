import 'package:flutter/material.dart';
import 'package:red_hosen/Admins/manageUsers/manageAdmins/secret/add_admin.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/Admins/manageUsers/user_confirmation.dart';

class SecretPage extends StatefulWidget {
  const SecretPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SecretPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('התחברות'),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 60, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///////////////SECRET!!!//////////////
                const SizedBox(height: 15),
                ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 150, height: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const UserConfirmation(type: UserType.hosen)),
                        );
                      },
                      child: const Text("אישור חוסן"),
                    )),
                const SizedBox(height: 15),
                ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 150, height: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserConfirmation(
                                  type: UserType.social)),
                        );
                      },
                      child: const Text("אישור רווחה"),
                    )),

                const SizedBox(height: 15),
                ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 150, height: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddAdminPage(
                                    type: UserType.hosen,
                                  )),
                        );
                      },
                      child: const Text("מנהל חוסן"),
                    )),
                const SizedBox(height: 15),
                ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 150, height: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddAdminPage(
                                    type: UserType.social,
                                  )),
                        );
                      },
                      child: const Text("מנהל רווחה"),
                    )),
              ],
            )));
  }
}
