import 'dart:convert';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/similar_recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  static Future<List<Recipe>> getRecipes() async {
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/random', {
      "number": "5",
      "limitLicense": "false",
    });

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "1e2f9da0ebmsh88019d09475fbafp1f5fb5jsn9fb0d28f588a",
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

  static Future<List<SimilarRecipe>> getSimilarRecipes(int id) async {
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/$id/similar', {
      "number": "7",
      "limitLicense": "false",
    });

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "326cf22eb1mshac86455f9f02e49p136e08jsnb6a08eb83b01",
      "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
      "useQueryString": "true"
    });

    final dataList = jsonDecode(response.body);
    return SimilarRecipe.similarRecipesFromSnapshot(dataList);
  }

  static Future<List<Recipe>> extractFromUrl(String url) async {
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/extract', {
      "url": url,
    });

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "326cf22eb1mshac86455f9f02e49p136e08jsnb6a08eb83b01",
      "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    List temp = [];
    temp.add(data);

    return Recipe.recipesFromSnapshot(temp);
  }

  static Future<List<Recipe>> getRecipesByTag(String tag) async {
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/random', {
      "tags": tag,
      "number": "5",
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
