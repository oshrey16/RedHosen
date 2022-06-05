import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/Instruction/pdf_read.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:red_hosen/contactus.dart';
import 'package:red_hosen/main.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/Instruction/video_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'global.dart' as global;

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.indigo,
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: AssetImage('assets/images/cover.jpg')
              //     )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'תפריט',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Text("שלום ${global.name}",
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                global.isAdmin
                    ? RichText(
                        text: TextSpan(
                          text: 'תפקידך: ${global.usertype.collectionStrHeb} ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          children: const <TextSpan>[
                            TextSpan(
                                text: '- מנהל',
                                style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18)),
                          ],
                        ),
                      )
                    : Text("תפקידך: ${global.usertype.collectionStrHeb}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('מסך ראשי'),
            onTap: () =>
                {Navigator.of(context).popUntil((route) => route.isFirst)},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user, color: Colors.green),
            title: const Text('פרופיל'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(
              Icons.call,
              color: Colors.cyan,
            ),
            title: const Text('התקשר לאגף הרווחה'),
            onTap: () {
              launchUrlString("tel://086620297");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.call,
              color: Colors.cyan,
            ),
            title: const Text('התקשר למרכז חוסן'),
            onTap: () {
              launchUrlString("tel://086611140");
            },
          ),
          ListTile(
            leading: const Icon(Icons.call, color: Colors.cyan),
            title: const Text('התקשר למוקד שדרות'),
            onTap: () {
              launchUrlString("tel://086610991");
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('דיווח על תקלה'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactUsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_collection_sharp),
            title: const Text('מתן עזרה ראשונה - סרטון'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const VideoPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_information_rounded),
            title: const Text('מתן עזרה ראשונה - אוגדן'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PdfReadPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('הודעות אישיות'),
            onTap: () {
              showDialogMsg(context, MsgType.alert, "בקרוב!");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: const Text('התנתק מהמערכת'),
            onTap: () {
              AuthService().logout();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthWrapper()));
            },
          ),
        ],
      ),
    );
  }
}
