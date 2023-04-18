import 'package:cloud_firestore/cloud_firestore.dart';

class PublicCreatedRecipe {
  final String name;
  final String servings;
  final List<dynamic> ingredients;
  final String cookInstructions;
  final String image;
  final String totalTime;
  final String userId;

  PublicCreatedRecipe(
      {required this.name,
      required this.servings,
      required this.ingredients,
      required this.cookInstructions,
      required this.image,
      required this.totalTime,
      required this.userId});

  factory PublicCreatedRecipe.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return PublicCreatedRecipe(
        name: data?['title'],
        servings: data?['servings'],
        ingredients: data?['ingredients'],
        cookInstructions: data?['cookInstructions'],
        image: data?['thumbnailUrl'],
        totalTime: data?['cookTime'],
        userId: data?['userId']);
  }
}
