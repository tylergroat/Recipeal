import 'dart:async';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/created_recipe_class.dart';
import 'package:food_for_thought/user-interface/cards/created_recipe_card.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
    return Scaffold(appBar: appBar(context), body: body());
  }

  EasySearchBar appBar(BuildContext context) {
    return EasySearchBar(
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }

  RefreshIndicator body() {
    return RefreshIndicator(
      onRefresh: () => getRecipes(),
      child: loaded
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                  ),
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      strokeWidth: 2,
                      colors: [Color.fromARGB(255, 244, 4, 4)],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Loading Created Recipes...',
                    style: TextStyle(
                        color: Color.fromARGB(
                          255,
                          244,
                          4,
                          4,
                        ),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          : recipes.isEmpty
              ? Center(
                  child: Text('No Created Recipes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )))
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
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      //if the recipe is private only, delete the image from storage
                                      //else (the recipe is public and verified), keep the image in storage because it is still being used by the public verified recipe
                                      if (!(await publicVerifiedRecipeExists(
                                          recipes[index].name, user!.uid))) {
                                        //if public recipe does not exist, this deletes the image from storage
                                        deleteImageFromFirebaseByUrl(
                                            recipes[index].image);
                                      }
                                      //delete the recipe from private collection
                                      deletePrivateRecipeFromFirebase(
                                          recipeName: recipes[index].name);
                                      //refresh the array after deleting the recipe
                                      getRecipes();
                                      setState(() {});
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    );
                  }),
    );
  }
}
