import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/read_data/get_user_name.dart';
import 'authentification.dart';
import 'login_page.dart';

class NavDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();
  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = TextButton(
      child: Text("Logout"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
        signOut();
        ScaffoldMessenger.of(context).showSnackBar(logOutMessage);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you want to log out?"),
      actions: [cancelButton, confirmButton],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
            onTap: () => {showAlertDialog(context)},
          ),
        ],
      ),
    );
  }
}
