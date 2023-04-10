import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:food_for_thought/classes/user_class.dart';

import '../classes/created_recipe_class.dart';

//class to define database operations involivng recipes -- Implemented by : Gavin Fromm

class DatabaseService {
  static Future<List<Recipe>> getRecipes(String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
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

  static Future<List<Recipe>> getAllRecipes(String filter) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("recipes")
        .where(filter, isEqualTo: true)
        .where('isPopular', isEqualTo: true)
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

  static Future<List<CreatedRecipe>> getCreatedRecipes(String uid) async {
    late List<CreatedRecipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('created recipes')
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(CreatedRecipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  static Future<List<Recipe>> sortByAlpha(String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('title')
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

  static Future<List<Recipe>> sortByAlphaDescending(
      String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('title', descending: true)
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

  static Future<List<Recipe>> sortByTime(String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('cookTime')
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

  static Future<List<Recipe>> sortByTimeDescending(
      String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('cookTime', descending: true)
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

  static Future<List<Recipe>> sortByServings(String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('servings')
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

  static Future<List<Recipe>> filterBy(
      String uid, String path, String filter) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .where(filter, isEqualTo: true)
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

  /// method for searching recipes
  static Future<List<Recipe>> searchRecipes(
      String uid, String search, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .where('title', isGreaterThanOrEqualTo: search)
        .where('title', isLessThanOrEqualTo: '$search\uf8ff');

    await docs.get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    print(recipes);
    return recipes;
  }

  static Future<UserInformation> getUser(String uid) async {
    late UserInformation user;
    final doc = FirebaseFirestore.instance.collection("users").doc(uid).get();

    await doc.then((querySnapshot) {
      user = UserInformation.fromFirestore(querySnapshot);
    });
    return user;
  }
}
