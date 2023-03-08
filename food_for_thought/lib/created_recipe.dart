/// this class creates an object to hold data from the recipe creation process
/// and sends the user-input data to the database
/// when the user finishes the process

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatedRecipe {
  //values begin as null
  String? name;
  int? servings;
  List<dynamic>? ingredients;
  String? preparationSteps;
  String? images;
  int? totalTime;

  //always want to do CreatedRecipe createdRecipeObject to create an object of this class
  CreatedRecipe(); //creates an object with default null values

  void clearCreatedRecipeValues() {
    name = null;
    servings = null;
    ingredients = null;
    preparationSteps = null;
    images = null;
    totalTime = null;
  }

//when the values are all set, cal this function to submit the recipe to the database
  Future sendToDatabase(FirebaseFirestore databaseObject) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Created Recipes')
        // .add(databaseObject)
        ;

    //clear values after sending to database
    clearCreatedRecipeValues();
  }
}
/**
 *   FirebaseFirestore db = FirebaseFirestore.instance;
 *                             db
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("saved recipes")
                                .doc(recipes[index].name)
                                .set(savedRecipe);
 */