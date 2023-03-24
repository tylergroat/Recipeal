import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/api_config.dart';
import 'package:food_for_thought/database.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/recipe_card.dart';
import 'package:food_for_thought/similar_recipe.dart';

class RecommendationPage extends StatefulWidget {
  @override
  RecommendationPageState createState() => RecommendationPageState();
}

class RecommendationPageState extends State<RecommendationPage> {
  late List<SimilarRecipe> similarRecipes = [];
  late List<Recipe> displayRecipes = [];
  late List<Recipe> recipes = [];
  Random random = new Random();
  int randomNumForRecipes = 0;
  int randomNumForRecommendations = 0;
  int maxForRecipes = 0;
  int maxForRecommendations = 0;
  int min = 0;
  int index = 0;
  bool _isLoading = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> getRecipes() async {
    //get recipes from users liked/saved recipes
    recipes = await DatabaseService.getRecipes(uid, 'saved recipes');

    //getting the length of array, for random choice selection
    maxForRecipes = recipes.length - 1;

    //getting random number in range
    randomNumForRecipes = min + random.nextInt(maxForRecipes - min);
    print('Range: $min - $maxForRecipes, Random Number: $randomNumForRecipes');

    //getting random recipes based on randomly chosen liked recipe
    print('Getting similar recipes to: ${recipes[randomNumForRecipes].name}');
    similarRecipes =
        await RecipeApi.getSimilarRecipes(recipes[randomNumForRecipes].id);

    maxForRecommendations = similarRecipes.length - 1;
    randomNumForRecommendations =
        min + random.nextInt(maxForRecommendations - min);
    print(
        'Range: $min - $maxForRecommendations, Random Number: $randomNumForRecommendations');

    print('similar recipes: ${similarRecipes.length}');

    //extracting that recipe into usable form
    print(
        'Extracting recipe: ${similarRecipes[randomNumForRecommendations].title} from  ${similarRecipes[randomNumForRecommendations].sourceUrl}');

    displayRecipes = await RecipeApi.extractFromUrl(
        similarRecipes[randomNumForRecommendations].sourceUrl);

    print(
        'Liked Recipe: ${recipes[randomNumForRecipes].name}  Recommendation: ${displayRecipes[0].name}');

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
        backgroundColor: Colors.grey,
        toolbarHeight: 30,
        centerTitle: true,
        title: Text(
          'Recommendations',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    child: RecipeCard(
                      id: recipes[index].id,
                      title: displayRecipes[index].name,
                      servings: displayRecipes[index].servings,
                      ingredients: displayRecipes[index].ingredients,
                      preparationSteps: displayRecipes[index].preparationSteps,
                      cookTime: displayRecipes[index].totalTime,
                      thumbnailUrl: displayRecipes[index].images,
                      isVegetarian: displayRecipes[index].isVegetarian,
                      isDairyFree: displayRecipes[index].isDairyFree,
                      isPopular: displayRecipes[index].isPopular,
                      isGlutenFree: displayRecipes[index].isGlutenFree,
                      isVegan: displayRecipes[index].isVegan,
                      isVeryHealthy: displayRecipes[index].isVeryHealthy,
                    ),
                    onDoubleTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirm'),
                            content: Text(
                                'Do you want to add ${displayRecipes[index].name} to your saved recipes?'),
                            actions: [
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 115, 138, 219)),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 115, 138, 219)),
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Map<String, dynamic> savedRecipe = {
                                    'id': displayRecipes[index].id,
                                    'title': displayRecipes[index].name,
                                    'servings': displayRecipes[index].servings,
                                    'ingredients':
                                        displayRecipes[index].ingredients,
                                    'preparationSteps':
                                        displayRecipes[index].preparationSteps,
                                    'cookTime': displayRecipes[index].totalTime,
                                    'thumbnailUrl':
                                        displayRecipes[index].images,
                                    'isVegetarian':
                                        displayRecipes[index].isVegetarian,
                                    'isVegan': displayRecipes[index].isVegan,
                                    'isGlutenFree':
                                        displayRecipes[index].isGlutenFree,
                                    'isDairyFree':
                                        displayRecipes[index].isDairyFree,
                                    'isVeryHealthy':
                                        displayRecipes[index].isVeryHealthy,
                                    'isPopular': displayRecipes[index].isPopular
                                  };
                                  final docs = FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(uid)
                                      .collection('saved recipes')
                                      .doc(recipes[index].name)
                                      .set(savedRecipe);

                                  getRecipes();
                                  setState(() {});
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    width: 400,
                    child: Center(
                      child: Text(
                        'Recomendation based on: \n${recipes[randomNumForRecipes].name}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      onPressed: getRecipes,
                      icon: Icon(
                        Icons.refresh_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
