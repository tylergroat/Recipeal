import 'dart:convert';
import 'package:food_for_thought/classes/nutrition_class.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  //get random recipes
  static Future<List<Recipe>> getRecipes() async {
    //connect to api
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/random', {
      "number": "5",
      "limitLicense": "false",
    });

    //get response with headers
    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "1e2f9da0ebmsh88019d09475fbafp1f5fb5jsn9fb0d28f588a",
      "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body); //decode json response
    List _temp = [];

    for (var i in data['recipes']) {
      //add each json object to array
      _temp.add(i);
    }

    return Recipe.recipesFromSnapshot(_temp); //return list of recipe objects
  }

  static Future<List<Recipe>> extractFromUrl(String url) async {
    //connect to api
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/extract', {
      "url": url,
    });

    //get response with headers
    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "326cf22eb1mshac86455f9f02e49p136e08jsnb6a08eb83b01",
      "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body); //decode json response
    List temp = [];
    temp.add(data);

    return Recipe.recipesFromSnapshot(temp); //return extrated recipe
  }

  static Future<Nutrition> nutritionById(int id) async {
    //connect to api
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/$id/nutritionWidget.json');

    //get response with headers
    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "326cf22eb1mshac86455f9f02e49p136e08jsnb6a08eb83b01",
      "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body); //decode json response
    List temp = [];
    temp.add(data);

    return Nutrition.fromJson(data); //return nutrition object
  }

//get recipes based on tag
  static Future<List<Recipe>> getRecipesByTag(String tag) async {
    //connect to api
    var uri = Uri.https('spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
        '/recipes/random', {
      "tags": tag,
      "number": "5",
      "limitLicense": "true",
    });

    //get response with headers
    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "1e2f9da0ebmsh88019d09475fbafp1f5fb5jsn9fb0d28f588a",
      "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body); //decode json response
    List _temp = [];

    for (var i in data['recipes']) {
      //add each json object to array
      _temp.add(i);
    }

    return Recipe.recipesFromSnapshot(_temp); //return list of recipe objects
  }
}
