///Mixin for Created Recipe functionalities
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
