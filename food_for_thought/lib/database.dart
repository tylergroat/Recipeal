import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_for_thought/recipe.dart';

class DatabaseService {
  static Future<List<Recipe>> getSavedRecipes(String uid) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('saved recipes')
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }
}
