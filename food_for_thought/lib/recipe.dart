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

  factory Recipe.fromSnapshot(dynamic snapshot) {
    return Recipe(
      name: snapshot['title'],
      servings: snapshot['servings'],
      ingredients: snapshot['ingredients'],
      preparationSteps: snapshot['instructions'] as String,
      images: snapshot['image'] as String,
      totalTime: snapshot['readyInMinutes'],
    );
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  static List<Recipe> recipesFromDB(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromSnapshot(data);
    }).toList();
  }
}
