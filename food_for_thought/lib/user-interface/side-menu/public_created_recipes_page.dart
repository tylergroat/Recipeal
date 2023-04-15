import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/created_recipe_class.dart';
import 'package:food_for_thought/user-interface/create-recipes/created_recipe_card.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../classes/public_created_recipe_class.dart';
import '../create-recipes/public_created_recipe_card.dart';

//Page for viewing your created recipes

class PublicCreatedRecipesPage extends StatefulWidget {
  @override
  PublicCreatedRecipesPageState createState() =>
      PublicCreatedRecipesPageState();
}

//Class with mixin CreatedRecipe because it can edit and delete created recipes
class PublicCreatedRecipesPageState extends State<PublicCreatedRecipesPage>
    with CreatedRecipeMixin {
  List<PublicCreatedRecipe> verifiedRecipes = [];
  List<PublicCreatedRecipe> pendingRecipes = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool loaded = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
        () async => {await getVerifiedRecipes(), await getPendingRecipes()});
    for (int i = 0; i < pendingRecipes.length; i++) {
      print(pendingRecipes[i]);
    }
  }

  //Load the created recipes from firebase
  Future<void> getVerifiedRecipes() async {
    verifiedRecipes = await DatabaseService.getMyVerifiedCreatedRecipes(uid);
    setState(() {
      verifiedRecipes = verifiedRecipes;
      loaded = false;
    });
  }

  //Load the created recipes from firebase
  Future<void> getPendingRecipes() async {
    pendingRecipes =
        await DatabaseService.getMyCreatedRecipesForVerification(uid);
    setState(() {
      pendingRecipes = pendingRecipes;
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
                                backgroundColor:
                                    Color.fromARGB(255, 244, 4, 4)),
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
                                backgroundColor:
                                    Color.fromARGB(255, 244, 4, 4)),
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
                                backgroundColor:
                                    Color.fromARGB(255, 244, 4, 4)),
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
            child: Text('My Public Recipes',
                style: TextStyle(
                    color: Color.fromARGB(255, 247, 247, 247), fontSize: 20)),
          ),
          onSearch: (value) {
            // setState(() => searchValue = value);
            // searchByTitle(value);
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getVerifiedRecipes();
            getPendingRecipes();
          },
          child: Column(
            children: [
              // First child widget - Verified recipes ListView
              verifiedRecipes.isEmpty
                  ? Center(child: Text('You Have No Verified Recipes'))
                  : Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: verifiedRecipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: PublicCreatedRecipeCard(
                                title: verifiedRecipes[index].name,
                                servings: verifiedRecipes[index].servings,
                                ingredients: verifiedRecipes[index].ingredients,
                                cookInstructions:
                                    verifiedRecipes[index].cookInstructions,
                                cookTime: verifiedRecipes[index].totalTime,
                                thumbnailUrl: verifiedRecipes[index].image,
                                userId: verifiedRecipes[index].userId,
                              ),
                              onLongPress: () {
                                print(verifiedRecipes[index].name);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirm"),
                                        content: Text(
                                            "Do you want to delete your ${verifiedRecipes[index].name} recipe from the public verified feed? This will not delete the recipe in your personal created recipes collection."),
                                        actions: [
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 244, 4, 4)),
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
                                                backgroundColor: Color.fromARGB(
                                                    255, 244, 4, 4)),
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              //todo: delete the recipe from verified collection
                                              //todo: if the recipe does not exist in the personal collection, delete the image
                                              //refresh the array after deleting the recipe
                                              getPendingRecipes();
                                              getVerifiedRecipes();
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                            );
                          })),
              // Second child widget - Pending recipes ListView
              pendingRecipes.isEmpty
                  ? Center(child: Text('You Have No Pending Recipes'))
                  : Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: pendingRecipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: PublicCreatedRecipeCard(
                                title: verifiedRecipes[index].name,
                                servings: verifiedRecipes[index].servings,
                                ingredients: verifiedRecipes[index].ingredients,
                                cookInstructions:
                                    verifiedRecipes[index].cookInstructions,
                                cookTime: verifiedRecipes[index].totalTime,
                                thumbnailUrl: verifiedRecipes[index].image,
                                userId: verifiedRecipes[index].userId,
                              ),
                              onLongPress: () {
                                print(verifiedRecipes[index].name);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirm"),
                                        content: Text(
                                            "Do you want to remove your ${verifiedRecipes[index].name} recipe from the verification process? You will still have this recipe in your personal created recipes collection."),
                                        actions: [
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 244, 4, 4)),
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
                                                backgroundColor: Color.fromARGB(
                                                    255, 244, 4, 4)),
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              //todo: delete the recipe from pending collection only
                                              //refresh the array after deleting the recipe
                                              getPendingRecipes();
                                              getVerifiedRecipes();
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                            );
                          })),
            ],
          ),
        ));
  }
}
