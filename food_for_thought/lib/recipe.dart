class Recipe {
  final String name;
  final int servings;
  // final List<String> ingredients;
  // final List<String> preparationSteps;
  final String images;
  final double rating;
  final String totalTime;

  Recipe(
      {required this.name,
      required this.servings,
      // required this.ingredients,
      // required this.preparationSteps,
      required this.images,
      required this.rating,
      required this.totalTime});

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
        name: json['details']['name'] as String,
        servings: json['details']['numberOfServings'],
        // ingredients: json['ingredientLines'][0]['wholeLine'],
        // preparationSteps: json['preparationSteps'],
        images: json['details']['images'][0]['hostedLargeUrl'] as String,
        rating: json['details']['rating'] as double,
        totalTime: json['details']['totalTime'] as String);
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }
}
