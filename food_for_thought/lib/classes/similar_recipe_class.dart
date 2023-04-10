//class to facilitate operations involving recipes -- Implemeted by : Gavin Fromm

class SimilarRecipe {
  final int id;
  final String imageType;
  final String title;
  final int readyInMinutes;
  final int servings;
  final String sourceUrl;

  SimilarRecipe({
    required this.id,
    required this.imageType,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
  });

  //method to create recipe object from json object

  factory SimilarRecipe.fromJson(dynamic json) {
    return SimilarRecipe(
      id: json['id'],
      imageType: json['imageType'],
      title: json['title'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      sourceUrl: json['sourceUrl'],
    );
  }

  static List<SimilarRecipe> similarRecipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return SimilarRecipe.fromJson(data);
    }).toList();
  }
}
