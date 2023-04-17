import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreateRecipeFromURLPage extends StatefulWidget {
  @override
  CreateRecipeFromURLPageState createState() => CreateRecipeFromURLPageState();
}

class CreateRecipeFromURLPageState extends State<CreateRecipeFromURLPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(80),
            ),
          ),
          backgroundColor: Colors.grey,
          toolbarHeight: 30,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'URL Upload',
            style: TextStyle(fontSize: 20),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center());
  }
}
