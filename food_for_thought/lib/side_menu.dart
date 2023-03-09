import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/change_info.dart';
import 'package:food_for_thought/pinned_recipes.dart';
import 'package:food_for_thought/profile_page.dart';
import 'package:food_for_thought/read_data/get_user_name.dart';
import 'package:food_for_thought/view_created.dart';
import 'package:food_for_thought/view_saved.dart';
import 'about_us.dart';
import 'authentification.dart';
import 'login_page.dart';

//class that defines the side bar menu of the applicaton -- Implemeted by : Gavin Fromm

class NavDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();
  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 115, 138, 219)),
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget confirmButton = TextButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 115, 138, 219)),
      child: Text(
        "Logout",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
        signOut();
        ScaffoldMessenger.of(context).showSnackBar(logOutMessage);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you want to logout?"),
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
            leading: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            title: Text('User Details'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfilePage()))
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: Text('Liked Recipes'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ViewSavedRecipesPage()))
            },
          ),
          ListTile(
            leading: Icon(
              Icons.push_pin,
              color: Colors.orange,
            ),
            title: Text('Pinned Recipes'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ViewPinnedRecipesPage()))
            },
          ),
          ListTile(
            leading: Icon(
              Icons.create,
              color: Colors.green,
            ),
            title: Text('Created Recipes'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CreatedRecipesPage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Update Email'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ChangeInfoPage()))
            },
          ),
          ListTile(
            leading: Icon(
              Icons.question_mark,
              color: Colors.purple,
            ),
            title: Text('About Us'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AboutUs()))
            },
          ),
          SizedBox(
            height: 180,
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
