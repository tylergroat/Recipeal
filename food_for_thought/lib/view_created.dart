import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:food_for_thought/login_page.dart';

class CreatedRecipesPage extends StatefulWidget {
  @override
  CreatedRecipesPageState createState() => CreatedRecipesPageState();
}

class CreatedRecipesPageState extends State<CreatedRecipesPage> {
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
          'Created Recipes',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
