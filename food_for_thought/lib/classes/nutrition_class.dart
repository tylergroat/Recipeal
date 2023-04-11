class Nutrition {
  final String calories;
  final String carbs;
  final String fat;
  final String protein;

  Nutrition({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  //method to create recipe object from json object

  factory Nutrition.fromJson(dynamic json) {
    return Nutrition(
      calories: json['calories'],
      carbs: json['carbs'],
      fat: json['fat'],
      protein: json['protein'],
    );
  }
}
