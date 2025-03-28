import 'package:cloud_firestore/cloud_firestore.dart';

//class to facilitate operations involving recipes -- Implemeted by : Gavin Fromm

class Recipe {
  final int id;
  final String name;
  final int servings;
  final List<dynamic> ingredients;
  final String preparationSteps;
  final String images;
  final int totalTime;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isDairyFree;
  final bool isVeryHealthy;
  final bool isPopular;

  Recipe({
    required this.id,
    required this.name,
    required this.servings,
    required this.ingredients,
    required this.preparationSteps,
    required this.images,
    required this.totalTime,
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    required this.isDairyFree,
    required this.isVeryHealthy,
    required this.isPopular,
  });

  //method to create recipe object from json object

  factory Recipe.fromJson(dynamic json) {
    if (json['id'] != null &&
        json['title'] != null &&
        json['servings'] != null &&
        json['instructions'] != null &&
        json['image'] != null &&
        json['readyInMinutes'] != null &&
        json['vegetarian'] != null &&
        json['glutenFree'] != null &&
        json['dairyFree'] != null &&
        json['veryHealthy'] != null &&
        json['veryPopular'] != null) {
      return Recipe(
        id: json['id'],
        name: json['title'] as String,
        servings: json['servings'],
        ingredients: json['extendedIngredients'],
        preparationSteps: json['instructions'] as String,
        images: json['image'] as String,
        totalTime: json['readyInMinutes'],
        isVegetarian: json['vegetarian'],
        isVegan: json['vegan'],
        isGlutenFree: json['glutenFree'],
        isDairyFree: json['dairyFree'],
        isVeryHealthy: json['veryHealthy'],
        isPopular: json['veryPopular'],
      );
    } else {
      throw Exception('Error creating recipe from JSON');
    }
  }

  //method to create recipe object from firestore mapping

  factory Recipe.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Recipe(
        id: data?['id'],
        name: data?['title'],
        servings: data?['servings'],
        ingredients: data?['ingredients'],
        preparationSteps: data?['preparationSteps'],
        images: data?['thumbnailUrl'],
        totalTime: data?['cookTime'],
        isVegetarian: data?['isVegetarian'],
        isVegan: data?['isVegan'],
        isGlutenFree: data?['isGlutenFree'],
        isDairyFree: data?['isDairyFree'],
        isVeryHealthy: data?['isVeryHealthy'],
        isPopular: data?['isPopular']);
  }

  //method to turn recipes created from JSON, into a List of Recipe objects

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }
}
