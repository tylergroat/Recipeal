import 'dart:convert';
import 'package:food_for_thought/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  static Future<List<Recipe>> getRecipes() async {
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/random', {
      "number": "10",
      "limitLicense": "true",
    });

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "326cf22eb1mshac86455f9f02e49p136e08jsnb6a08eb83b01",
      "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data['recipes']) {
      _temp.add(i);
    }

    return Recipe.recipesFromSnapshot(_temp);
  }

  static Future<List<Recipe>> getFeaturedRecipe() async {
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/random', {
      "number": "1",
      "limitLicense": "true",
    });

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "326cf22eb1mshac86455f9f02e49p136e08jsnb6a08eb83b01",
      "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data['recipes']) {
      _temp.add(i);
    }

    return Recipe.recipesFromSnapshot(_temp);
  }
}
