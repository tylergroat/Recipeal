import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:food_for_thought/user-interface/feed/recipe_card.dart';
import 'package:loading_indicator/loading_indicator.dart';

class RecommendationPage extends StatefulWidget {
  @override
  RecommendationPageState createState() => RecommendationPageState();
}

class RecommendationPageState extends State<RecommendationPage> {
  late List<Recipe> allRecipes = [];
  late List<Recipe> recipes = [];
  late List<Recipe> combinedRecipes = [];
  late List<Recipe> reducedRecipes = [];
  late List<Recipe> shuffledRecipes = [];

  int index = 0;
  bool _isLoading = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  int vegetarian = 0;
  int vegan = 0;
  int glutenFree = 0;
  int dairyFree = 0;
  int popular = 0;
  int healthy = 0;
  int none = 0;

  Future<void> getRecipes() async {
    vegetarian = 0;
    vegan = 0;
    glutenFree = 0;
    dairyFree = 0;
    popular = 0;
    healthy = 0;
    none = 0;

    recipes = await DatabaseService.getRecipes(uid, 'saved recipes');

    for (int i = 0; i < recipes.length - 1; i++) {
      if (recipes[i].isDairyFree == true) {
        dairyFree++;
      }
      if (recipes[i].isGlutenFree == true) {
        glutenFree++;
      }
      if (recipes[i].isPopular == true) {
        popular++;
      }
      if (recipes[i].isVegan == true) {
        vegan++;
      }
      if (recipes[i].isVegetarian == true) {
        vegetarian++;
      }
      if (recipes[i].isVeryHealthy == true) {
        healthy++;
      }
      if (recipes[i].isDairyFree &&
          recipes[i].isGlutenFree &&
          recipes[i].isPopular &&
          recipes[i].isVeryHealthy &&
          recipes[i].isVegan &&
          recipes[i].isVegetarian) {
        none++;
      }
    }

    Map<String, int> filters = {
      'isVegan': vegan,
      'isVegetarian': vegetarian,
      'isPopular': popular,
      'isGlutenFree': glutenFree,
      'isDairyFree': dairyFree,
      'isVeryHealthy': healthy,
    };

    var sortedByKeyMap = Map.fromEntries(filters.entries.toList()
      ..sort((e1, e2) => e1.value.compareTo(e2.value)));
    String filter = sortedByKeyMap.keys.toList().last;
    //finding most common tag
    print(filter);
    allRecipes = await DatabaseService.getAllRecipes(filter);
    print(allRecipes.length);
    shuffledRecipes = allRecipes..shuffle();
    print(shuffledRecipes[0].name);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () => getRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 4, 4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
          onPressed: getRecipes,
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
            weight: 70,
            size: 35,
          ),
        ),
      ),
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
          ? Center(
              child: SizedBox(
                height: 70,
                width: 70,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  strokeWidth: 2,
                  colors: [Color.fromARGB(255, 244, 4, 4)],
                ),
              ),
            )
          : Scrollbar(
              interactive: true,
              thumbVisibility: true,
              thickness: 8,
              radius: Radius.circular(12),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Column(
                      children: [
                        RecipeCard(
                          id: allRecipes[index].id,
                          title: allRecipes[index].name,
                          servings: allRecipes[index].servings,
                          ingredients: allRecipes[index].ingredients,
                          preparationSteps: allRecipes[index].preparationSteps,
                          cookTime: allRecipes[index].totalTime,
                          thumbnailUrl: allRecipes[index].images,
                          isVegetarian: allRecipes[index].isVegetarian,
                          isDairyFree: allRecipes[index].isDairyFree,
                          isPopular: allRecipes[index].isPopular,
                          isGlutenFree: allRecipes[index].isGlutenFree,
                          isVegan: allRecipes[index].isVegan,
                          isVeryHealthy: allRecipes[index].isVeryHealthy,
                        ),
                        Container(
                          width: 145,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 244, 4, 4),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rate,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'Recommended',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    onDoubleTap: () {
                      print(allRecipes[index].name);

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirm'),
                            content: Text(
                                'Do you want to add ${allRecipes[index].name} to your saved recipes?'),
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
                                  print(allRecipes[index].name);
                                  Navigator.pop(context);
                                  Map<String, dynamic> savedRecipe = {
                                    'id': allRecipes[index].id,
                                    'title': allRecipes[index].name,
                                    'servings': allRecipes[index].servings,
                                    'ingredients':
                                        allRecipes[index].ingredients,
                                    'preparationSteps':
                                        allRecipes[index].preparationSteps,
                                    'cookTime': allRecipes[index].totalTime,
                                    'thumbnailUrl': allRecipes[index].images,
                                    'isVegetarian':
                                        allRecipes[index].isVegetarian,
                                    'isVegan': allRecipes[index].isVegan,
                                    'isGlutenFree':
                                        allRecipes[index].isGlutenFree,
                                    'isDairyFree':
                                        allRecipes[index].isDairyFree,
                                    'isVeryHealthy':
                                        allRecipes[index].isVeryHealthy,
                                    'isPopular': allRecipes[index].isPopular
                                  };
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(uid)
                                      .collection('saved recipes')
                                      .doc(allRecipes[index].name)
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
            ),
    );
  }
}
