import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_hosen/auth_services.dart';
import 'package:red_hosen/contactus.dart';
import 'package:red_hosen/main.dart';
import 'package:red_hosen/video_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'מסך זה בבניה',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.indigo,
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: AssetImage('assets/images/cover.jpg')
              //     )
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('מסך ראשי'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('פרופיל'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text('התקשר לאגף הרווחה'),
            onTap: () {
              launchUrlString("tel://086620297");
            },
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text('התקשר למרכז חוסן'),
            onTap: () {
              launchUrlString("tel://086611140");
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('דיווח על תקלה'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactUsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('מתן עזרה ראשונה - הדרכה'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const VideoPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('התנתק מהמערכת'),
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
