import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:food_for_thought/login_page.dart';

class ViewSavedRecipesPage extends StatefulWidget {
  @override
  ViewSavedRecipesPageState createState() => ViewSavedRecipesPageState();
}

class ViewSavedRecipesPageState extends State<ViewSavedRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
          backgroundColor: Colors.grey,
          toolbarHeight: 35,
          centerTitle: true,
          title: Text(
            'Saved Recipes',
            style: TextStyle(
                color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
          ),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.bug_report),
                    title: Text('Recipe 1'),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.food_bank),
                    title: Text('Recipe 1'),
                    onTap: () => {},
                  ),
                ],
              ),
            ],
          )),
        ));
  }
}
