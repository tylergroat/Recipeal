import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:food_for_thought/login_page.dart';

class FeedPage extends StatefulWidget {
  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
          backgroundColor: Colors.grey,
          toolbarHeight: 35,
          centerTitle: true,
          title: Text(
            'Feed',
            style: TextStyle(
                color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Card(
            color: Colors.grey,
            child: SizedBox(
              width: 300,
              height: 350,
              child: Center(
                child: Image.asset('assets/logo/logo.png' //to display the image
                    ),
              ),
            ),
          ),
        ));
  }
}
