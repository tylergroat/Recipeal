import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/read_data/get_user_name.dart';
import 'login_page.dart';

class NavDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();
  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 110,
            child: DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 115, 138, 219)),
              child: FutureBuilder(
                builder: (context, snapshot) {
                  return SizedBox(
                      width: 500,
                      height: 100,
                      child: GetUserName(documentID: user.uid));
                },
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginPage())),
              ScaffoldMessenger.of(context).showSnackBar(logOutMessage)
            },
          ),
        ],
      ),
    );
  }
}
