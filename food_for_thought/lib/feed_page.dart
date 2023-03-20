import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/recipe_card.dart';
import 'api_config.dart';

//class to define how the recipe feed is presented to the user -- Implemented by : Gavin Fromm

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
        toolbarHeight: 25,
        centerTitle: true,
        title: Text(
          'Feed',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 17),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment(-.85, 0),
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 190, 189, 189),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_list),
                      SizedBox(
                        width: 5,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Center(
                            child: DropdownButton<String>(
                              onChanged: (s) {
                                print(s?.toLowerCase());
                                getRecipes(selectedTag?.toLowerCase());
                                setState(() {
                                  selectedTag = s;
                                });
                              },
                              items: dropDownMenuItems,
                              value: selectedTag,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              RecipeCard(
                title: recipes[index].name,
                servings: recipes[index].servings,
                ingredients: recipes[index].ingredients,
                preparationSteps: recipes[index].preparationSteps,
                cookTime: recipes[index].totalTime,
                thumbnailUrl: recipes[index].images,
                isVegetarian: recipes[index].isVegetarian,
                isDairyFree: recipes[index].isDairyFree,
                isHealthy: recipes[index].isVeryHealthy,
              ),
              SizedBox(
                height: 5,
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
                        color: Color.fromARGB(255, 190, 189, 189),
                        // Color.fromARGB(255, 115, 138, 219),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.thumb_down,
                          size: 35,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          print('Current Index: $index Last Index: $lastIndex');
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
                    width: 30,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(2.0),
                  //   child: Container(
                  //     height: 50,
                  //     width: 150,
                  //     decoration: BoxDecoration(
                  //       color: Color.fromARGB(255, 190, 189, 189),
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     child: StatefulBuilder(
                  //       builder: (context, setState) {
                  //         return Center(
                  //           child: DropdownButton<String>(
                  //             onChanged: (s) {
                  //               print(s?.toLowerCase());
                  //               getRecipes(selectedTag?.toLowerCase());
                  //               setState(() {
                  //                 selectedTag = s;
                  //               });
                  //             },
                  //             items: dropDownMenuItems,
                  //             value: selectedTag,
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 190, 189, 189),
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
                            savedRecipes.add(
                              Recipe(
                                name: recipes[index].name,
                                servings: recipes[index].servings,
                                ingredients: recipes[index].ingredients,
                                preparationSteps:
                                    recipes[index].preparationSteps,
                                images: recipes[index].images,
                                totalTime: recipes[index].totalTime,
                                isVegetarian: recipes[index].isVegetarian,
                                isVegan: recipes[index].isVegan,
                                isGlutenFree: recipes[index].isGlutenFree,
                                isDairyFree: recipes[index].isDairyFree,
                                isVeryHealthy: recipes[index].isVeryHealthy,
                              ),
                            );
                            setState(() {});
                          }

                          Map<String, dynamic> savedRecipe = {
                            'title': recipes[index].name,
                            'servings': recipes[index].servings,
                            'ingredients': recipes[index].ingredients,
                            'preparationSteps': recipes[index].preparationSteps,
                            'cookTime': recipes[index].totalTime,
                            'thumbnailUrl': recipes[index].images,
                            'isVegetarian': recipes[index].isVegetarian,
                            'isVegan': recipes[index].isVegan,
                            'isGlutenFree': recipes[index].isGlutenFree,
                            'isDairyFree': recipes[index].isDairyFree,
                            'isVeryHealthy': recipes[index].isVeryHealthy,
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
    );
  }
}
