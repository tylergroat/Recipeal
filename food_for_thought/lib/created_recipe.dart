/// this class creates an object to hold data from the recipe creation process
/// and sends the user-input data to the database
/// when the user finishes the process

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatedRecipe {
  //values begin as null
  String? title;
  int? servings;
  List<dynamic>? ingredients;
  String? preparationSteps;
  int? totalTime;
  //always want to do CreatedRecipe createdRecipeObject to create an object of this class
  CreatedRecipe({
    required this.title,
    required this.servings,
    required this.ingredients,
    required this.preparationSteps,
    required this.totalTime,
  }); //creates an object with default null values

  factory CreatedRecipe.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CreatedRecipe(
        title: data?['title'],
        servings: data?['servings'],
        ingredients: data?['ingredients'],
        preparationSteps: data?['preparationSteps'],
        totalTime: data?['totalTime']);
  }
}
