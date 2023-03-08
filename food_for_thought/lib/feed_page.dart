import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/database.dart';
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
  late List<Recipe> savedRecipes = [];
  late List<Recipe> recipes = [];
  late List<String> ingredients = [];
  late int lastIndex = recipes.length - 3;
  late DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> tags = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Vegan',
    'Vegetarian',
    'Dairy Free'
  ];
  String? selectedTag = 'All';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipes(selectedTag);
  }

  Future<void> getRecipes(String? tag) async {
    if (selectedTag == "All") {
      recipes = await RecipeApi.getRecipes();
    } else {
      recipes = await RecipeApi.getRecipesByTag(tag!);
      print(recipes);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropDownMenuItems = tags
        .map((String item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList();
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
                            print(
                                'Current Index: $index Last Index: $lastIndex');
                            if (index >= lastIndex) {
                              index = 0;
                              getRecipes(selectedTag);
                              print('API Call');
                            } else {
                              index++;
                              recipes.removeAt(index);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
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
                            Icons.filter_list,
                            size: 35,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Filters'),
                                    content: Container(
                                      height: 50,
                                      width: 50,
                                      child: StatefulBuilder(
                                          builder: (context, setState) {
                                        return DropdownButton<String>(
                                          onChanged: (s) {
                                            print(s?.toLowerCase());
                                            setState(() {
                                              selectedTag = s;
                                            });
                                          },
                                          items: dropDownMenuItems,
                                          value: selectedTag,
                                        );
                                      }),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 115, 138, 219),
                                        ),
                                        child: Text('Apply'),
                                        onPressed: () {
                                          print(selectedTag?.toLowerCase());
                                          getRecipes(
                                              selectedTag?.toLowerCase());
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
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
                            print(
                                'Current Index:  + $index Last Index: $lastIndex');
                            if (index >= lastIndex) {
                              print(index);
                              index = 0;
                              getRecipes(selectedTag);
                              print('API Call');
                            } else {
                              index++;
                              recipes.removeAt(index);
                              savedRecipes.add(Recipe(
                                  name: recipes[index].name,
                                  servings: recipes[index].servings,
                                  ingredients: recipes[index].ingredients,
                                  preparationSteps:
                                      recipes[index].preparationSteps,
                                  images: recipes[index].images,
                                  totalTime: recipes[index].totalTime));
                              setState(() {});
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

                            db
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("saved recipes")
                                .doc(recipes[index].name)
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
