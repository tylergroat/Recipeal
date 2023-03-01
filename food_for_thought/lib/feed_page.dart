import 'package:firebase_database/firebase_database.dart';
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
  late List<Recipe> recipes = [];
  late List<String> ingredients = [];
  late int lastIndex = ingredients.length - 1;
  late DatabaseReference dbRef;
  late List<RecipeCard> recipeCards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
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
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 115, 138, 219),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                            size: 35,
                          ),
                          onPressed: () {
                            if (index >= lastIndex) {
                              index = 0;
                              getRecipes();
                            } else {
                              index++;
                              recipes.removeAt(index);
                            }
                            setState(() {
                              index = index;
                            });
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
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 115, 138, 219),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 35,
                          ),
                          onPressed: () {
                            if (index >= lastIndex) {
                              index = 0;
                              getRecipes();
                            } else {
                              index++;
                              recipes.removeAt(index);
                            }

                            Map<String, dynamic> savedRecipe = {
                              'title': recipes[index].name,
                              'servings': recipes[index].servings,
                              'ingredients': recipes[index].ingredients,
                              'preparationSteps':
                                  recipes[index].preparationSteps,
                              'cookTime': recipes[index].totalTime,
                              'thumbnailUrl': recipes[index].images,
                            };
                            dbRef
                                .child('$uid!/saved recipes')
                                .push()
                                .set(savedRecipe);

                            setState(() {
                              index = index;
                            });
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
