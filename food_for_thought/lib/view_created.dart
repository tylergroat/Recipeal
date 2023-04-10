import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_for_thought/created_recipe_card.dart';
import 'package:food_for_thought/database.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/recipe_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_for_thought/created_recipe.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path/path.dart' as Path;
import 'package:food_for_thought/recipecreation_page.dart';

//Page for viewing your created recipes

class CreatedRecipesPage extends StatefulWidget {
  @override
  CreatedRecipesPageState createState() => CreatedRecipesPageState();
}

//Class with mixin CreatedRecipe because it can edit and delete created recipes
class CreatedRecipesPageState extends State<CreatedRecipesPage>
    with CreatedRecipeMixin {
  late List<CreatedRecipe> recipes = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String searchValue = '';
  String createdRecipes = 'created recipes';
  bool loaded = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => getRecipes());
  }

  //Load the created recipes from firebase
  Future<void> getRecipes() async {
    recipes = await DatabaseService.getCreatedRecipes(uid);
    setState(() {
      recipes;
      loaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Sort Options'),
                      content: Text('Sort data:'),
                      actions: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                          child: Text(
                            "Alphabetically",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            // sortByAlpha();
                          },
                        ),
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                          child: Text(
                            "Cook Time",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            // sortByTime();
                          },
                        ),
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                          child: Text(
                            "Servings",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            // sortByServings();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.sort))
        ],
        backgroundColor: Color.fromARGB(255, 244, 4, 4),
        foregroundColor: Colors.white,
        title: Center(
          child: Text('Created Recipes',
              style: TextStyle(
                  color: Color.fromARGB(255, 247, 247, 247), fontSize: 20)),
        ),
        onSearch: (value) {
          setState(() => searchValue = value);
          // searchByTitle(value);
        },
      ),

      body: RefreshIndicator(
        onRefresh: () => getRecipes(),
        child: recipes.isEmpty
            ? Center(child: Text('No Created Recipes'))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: recipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: CreatedRecipeCard(
                      title: recipes[index].name,
                      servings: recipes[index].servings,
                      ingredients: recipes[index].ingredients,
                      cookInstructions: recipes[index].cookInstructions,
                      cookTime: recipes[index].totalTime,
                      thumbnailUrl: recipes[index].image,
                    ),
                    onLongPress: () {
                      print(recipes[index].name);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Confirm"),
                              content: Text(
                                  "Are you sure you want to delete your ${recipes[index].name} recipe?"),
                              actions: [
                                TextButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 244, 4, 4)),
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
                                          Color.fromARGB(255, 244, 4, 4)),
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    //delete this recipe
                                    deleteRecipeFromFirebase(
                                        recipeName: recipes[index].name);
                                    //refresh the array after deleting the recipe
                                    getRecipes();
                                    setState(() {});
                                  },
                                )
                              ],
                            );
                          }); // show the dialog
                      // print(recipes[index].name);
                    },
                    onDoubleTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirm'),
                            content: Text(
                                'Do you want to add ${recipes[index].name} to your pinned recipes?'),
                            actions: [
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 244, 4, 4)),
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
                                        Color.fromARGB(255, 244, 4, 4)),
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Map<String, dynamic> createdRecipe = {
                                    'title': recipes[index].name,
                                    'servings': recipes[index].servings,
                                    'ingredients': recipes[index].ingredients,
                                    'cookInstructions':
                                        recipes[index].cookInstructions,
                                    'cookTime': recipes[index].totalTime,
                                    'thumbnailUrl': recipes[index].image,
                                  };
                                  //Add this created recipe to the pinned recipes doc in firebase
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(uid)
                                      .collection('pinned recipes')
                                      .doc(recipes[index].name)
                                      .set(createdRecipe);
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
                ),
    );
  }
}
