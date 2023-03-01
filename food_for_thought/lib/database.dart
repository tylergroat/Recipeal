import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_for_thought/recipe.dart';

class DatabaseService {
  static Future<List<Recipe>> getRecipesFromDB(String uid) async {
    final List<Recipe> recipes = [];

    final snapshot =
        await FirebaseDatabase.instance.ref('user data/$uid').get();

    Map data = jsonDecode(snapshot.toString());

    for (var i in data['saved recipes']) {
      recipes.add(i);
    }
    return Recipe.recipesFromSnapshot(recipes);
  }
}
