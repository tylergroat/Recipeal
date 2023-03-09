import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String name;
  final int servings;
  final List<dynamic> ingredients;
  final String preparationSteps;
  final String images;
  final int totalTime;

  Recipe(
      {required this.name,
      required this.servings,
      required this.ingredients,
      required this.preparationSteps,
      required this.images,
      required this.totalTime});

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
      name: json['title'] as String,
      servings: json['servings'],
      ingredients: json['extendedIngredients'],
      preparationSteps: json['instructions'] as String,
      images: json['image'] as String,
      totalTime: json['readyInMinutes'],
    );
  }

  factory Recipe.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Recipe(
        name: data?['title'],
        servings: data?['servings'],
        ingredients: data?['ingredients'],
        preparationSteps: data?['preparationSteps'],
        images: data?['thumbnailUrl'],
        totalTime: data?['cookTime']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "title": name,
      if (servings != null) "servings": servings,
      if (ingredients != null) "ingredients": ingredients,
      if (preparationSteps != null) "preparationSteps": preparationSteps,
      if (images != null) "images": images,
      if (totalTime != totalTime) "regions": totalTime,
    };
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }
}
