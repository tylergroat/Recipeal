import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/classes/public_created_recipe_class.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:food_for_thought/user-interface/cards/public_created_recipe_card.dart';
import 'package:food_for_thought/user-interface/cards/recipe_card.dart';
import '../../back-end/database.dart';
import 'package:loading_indicator/loading_indicator.dart';

//Page for viewing your liked recipes -- Implemeted by : Gavin Fromm

class ViewSavedRecipesPage extends StatefulWidget {
  @override
  ViewSavedRecipesPageState createState() => ViewSavedRecipesPageState();
}

class ViewSavedRecipesPageState extends State<ViewSavedRecipesPage> {
  late List<Recipe> recipes = [];
  late List<PublicCreatedRecipe> publicRecipes = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore db = FirebaseFirestore.instance;

  String searchValue = '';
  String savedRecipes = 'saved recipes';
  String likedRecipes = 'liked recipe (user)';
  bool loaded = true;
  bool _showingFeedLikes = true;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () => getRecipes());
  }

  Future<void> getRecipes() async {
    recipes = await DatabaseService.getRecipes(uid, savedRecipes);
    setState(() {
      recipes;
      _showingFeedLikes = true;
      loaded = false;
    });
  }

  Future<void> getUserCreatedRecipes() async {
    publicRecipes =
        await DatabaseService.getPublicCreatedRecipes(uid, likedRecipes);
    setState(() {
      publicRecipes;
      _showingFeedLikes = false;
      loaded = false;
    });
  }

  Future<void> searchByTitle(String query) async {
    recipes = await DatabaseService.searchRecipes(uid, query, savedRecipes);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByAlpha() async {
    recipes = await DatabaseService.sortByAlpha(uid, savedRecipes);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByServings() async {
    recipes = await DatabaseService.sortByServings(uid, savedRecipes);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByTime() async {
    recipes = await DatabaseService.sortByTime(uid, savedRecipes);
    setState(() {
      recipes;
    });
  }

  Future<void> filterByVegan() async {
    recipes = await DatabaseService.filterBy(uid, savedRecipes, 'isVegan');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByVegetarian() async {
    recipes = await DatabaseService.filterBy(uid, savedRecipes, 'isVegetarian');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByDairyFree() async {
    recipes = await DatabaseService.filterBy(uid, savedRecipes, 'isDairyFree');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByPopular() async {
    recipes = await DatabaseService.filterBy(uid, savedRecipes, 'isPopular');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByHealthy() async {
    recipes = await DatabaseService.filterBy(uid, savedRecipes, 'isVeryHealty');
    setState(() {
      recipes;
    });
  }

  Future<void> filterByGlutenFree() async {
    recipes = await DatabaseService.filterBy(uid, savedRecipes, 'isGlutenFree');
    setState(() {
      recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(),
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 4, 4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
          onPressed: _showingFeedLikes ? getUserCreatedRecipes : getRecipes,
          icon: _showingFeedLikes
              ? Icon(
                  Icons.verified,
                  color: Colors.white,
                  weight: 70,
                  size: 35,
                )
              : Icon(
                  Icons.feed,
                  color: Colors.white,
                  weight: 70,
                  size: 35,
                ),
        ),
      ),
    );
  }

  RefreshIndicator body() {
    return RefreshIndicator(
        onRefresh: _showingFeedLikes ? getRecipes : getUserCreatedRecipes,
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
                      'Loading Liked Recipes...',
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
            : _showingFeedLikes
                ? (recipes.isEmpty
                    ? Center(child: Text('No Liked Recipes'))
                    : Scrollbar(
                        interactive: true,
                        thumbVisibility: true,
                        thickness: 8,
                        radius: Radius.circular(12),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: recipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: RecipeCard(
                                id: recipes[index].id,
                                title: recipes[index].name,
                                servings: recipes[index].servings,
                                ingredients: recipes[index].ingredients,
                                preparationSteps:
                                    recipes[index].preparationSteps,
                                cookTime: recipes[index].totalTime,
                                thumbnailUrl: recipes[index].images,
                                isVegetarian: recipes[index].isVegetarian,
                                isDairyFree: recipes[index].isDairyFree,
                                isPopular: recipes[index].isPopular,
                                isGlutenFree: recipes[index].isGlutenFree,
                                isVegan: recipes[index].isVegan,
                                isVeryHealthy: recipes[index].isVeryHealthy,
                              ),
                              onLongPress: () {
                                print(recipes[index].name);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirm"),
                                        content: Text(
                                            "Are you sure you want to remove ${recipes[index].name} from your liked recipes?"),
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
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              final docs = FirebaseFirestore
                                                  .instance
                                                  .collection("users")
                                                  .doc(uid)
                                                  .collection('saved recipes')
                                                  .doc(recipes[index].name)
                                                  .delete();
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
                                            "Confirm",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Map<String, dynamic> savedRecipe = {
                                              'id': recipes[index].id,
                                              'title': recipes[index].name,
                                              'servings':
                                                  recipes[index].servings,
                                              'ingredients':
                                                  recipes[index].ingredients,
                                              'preparationSteps': recipes[index]
                                                  .preparationSteps,
                                              'cookTime':
                                                  recipes[index].totalTime,
                                              'thumbnailUrl':
                                                  recipes[index].images,
                                              'isVegetarian':
                                                  recipes[index].isVegetarian,
                                              'isVegan': recipes[index].isVegan,
                                              'isGlutenFree':
                                                  recipes[index].isGlutenFree,
                                              'isDairyFree':
                                                  recipes[index].isDairyFree,
                                              'isVeryHealthy':
                                                  recipes[index].isVeryHealthy,
                                              'isPopular':
                                                  recipes[index].isPopular
                                            };
                                            final docs = FirebaseFirestore
                                                .instance
                                                .collection("users")
                                                .doc(uid)
                                                .collection('pinned recipes')
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
                            );
                          },
                        ),
                      ))
                : (publicRecipes.isEmpty
                    ? Center(child: Text('No Liked Community Verified Recipes'))
                    : Scrollbar(
                        interactive: true,
                        thumbVisibility: true,
                        thickness: 8,
                        radius: Radius.circular(12),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: publicRecipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: PublicCreatedRecipeCard(
                                title: publicRecipes[index].name,
                                servings: publicRecipes[index].servings,
                                ingredients: publicRecipes[index].ingredients,
                                cookInstructions:
                                    publicRecipes[index].cookInstructions,
                                cookTime: publicRecipes[index].totalTime,
                                thumbnailUrl: publicRecipes[index].image,
                                userId: publicRecipes[index].userId,
                              ),
                              onLongPress: () {
                                print(publicRecipes[index].name);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirm"),
                                        content: Text(
                                            "Are you sure you want to remove ${publicRecipes[index].name} from your liked community verified recipes?"),
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
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              db
                                                  .collection("users")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection(
                                                      "liked recipe (user)")
                                                  .doc(
                                                      publicRecipes[index].name)
                                                  .delete();
                                              getUserCreatedRecipes();
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                            );
                          },
                        ),
                      )));
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
                    title: Text('Sorting/Filtering'),
                    content: Text('Sort data:'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                              sortByAlpha();
                            },
                          ),
                          SizedBox(
                            width: 5,
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
                              sortByTime();
                            },
                          ),
                          SizedBox(
                            width: 5,
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
                              sortByServings();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment(-.85, 0),
                        child: Text(
                          'Filter by:',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Vegan",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByVegan();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Gluten Free",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByGlutenFree();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Popular",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByPopular();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Vegetarian",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByVegetarian();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Healthy",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByHealthy();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 35,
                            width: 90,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                "Dairy Free",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                filterByDairyFree();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
        child: Text(
          'Liked Recipes',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
      ),
      onSearch: (value) {
        setState(() => searchValue = value);
        searchByTitle(value);
      },
    );
  }
}
