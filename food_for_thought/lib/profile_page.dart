import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authentification.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
