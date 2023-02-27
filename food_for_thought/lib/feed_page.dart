import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/recipe_card.dart';
import 'api_config.dart';
import 'authentification.dart';

class FeedPage extends StatefulWidget {
  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  int index = 0;
  late List<Recipe> recipes;
  late List<String> ingredients = [];

  late List<RecipeCard> recipeCards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipes(); ///// will create button to refresh query -- accidentally got too many requests
  }

  Future<void> getRecipes() async {
    recipes = await RecipeApi.getRecipe();

    for (int i = 0; i < recipes.length; i++) {
      for (int j = 0; j < ingredients.length; j++) {
        String ingredient = recipes[i].ingredients[j];
        ingredients.add(ingredient);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> saveRecipe(List<Recipe> recipes, int index) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('saved recipes')
        .doc()
        .set({
      'title': recipes[index].name,
      'servings': recipes[index].servings,
      'ingredients': recipes[index].ingredients,
      'preparationSteps': recipes[index].preparationSteps,
      'cookTime': recipes[index].totalTime,
      'thumbnailUrl': recipes[index].images
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
        backgroundColor: Colors.grey,
        toolbarHeight: 35,
        centerTitle: true,
        title: Text(
          'Feed',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(children: [
                RecipeCard(
                  title: recipes[index].name,
                  servings: recipes[index].servings,
                  ingredients: recipes[index].ingredients,
                  preparationSteps: recipes[index].preparationSteps,
                  cookTime: recipes[index].totalTime,
                  thumbnailUrl: recipes[index].images,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 115, 138, 219),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                          ),
                          onPressed: () {
                            if (index == 0) {
                              print('error, already at first index');
                            } else {
                              index--;
                              setState(() {
                                index = index;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 115, 138, 219),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            if (index == recipes.length - 1) {
                              print('error, last index');
                            } else {
                              index++;
                              setState(() {
                                index = index;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
    );
  }
}
