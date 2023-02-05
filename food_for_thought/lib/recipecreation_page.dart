import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authentification.dart';
import 'login_page.dart';

class RecipeCreation extends StatefulWidget {
  @override
  _RecipeCreationState createState() => _RecipeCreationState();
}

class _RecipeCreationState extends State<RecipeCreation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Your Recipe')),
    );
  }
}
