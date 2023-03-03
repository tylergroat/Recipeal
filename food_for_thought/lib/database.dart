import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/recipe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseService {
  static List<Recipe> getSavedRecipes(String uid) {
    List<Recipe> recipes = [];
    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('saved recipes')
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print(Recipe.fromFirestore(docSnapshot));
          recipes.add(Recipe.fromFirestore(docSnapshot));
          // print('${docSnapshot.id} => ${docSnapshot.data()}');
          print(recipes);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return recipes;
  }
}
