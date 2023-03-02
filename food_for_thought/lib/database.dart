import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/recipe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseService {
  static Future<List> getRecipesFromDB() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List recipes = [];

    var ref = FirebaseDatabase.instance.ref('user data');

    var snapshot = await ref.child('$uid/saved recipes').get();

    Map data = snapshot.value as Map<dynamic, dynamic>;
    print(data);

    recipes.add(data);

    return Recipe.recipesFromDB(recipes);
  }
}
