import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/feed_page.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/recipe_card.dart';
import 'authentification.dart';
import 'database.dart';

class ViewSavedRecipesPage extends StatefulWidget {
  @override
  ViewSavedRecipesPageState createState() => ViewSavedRecipesPageState();
}

class ViewSavedRecipesPageState extends State<ViewSavedRecipesPage> {
  late List<Recipe> recipes = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    recipes = await DatabaseService.getSavedRecipes(uid);
    setState(() {
      recipes;
    });
  }

  Future<void> searchByTitle(String query) async {
    recipes = await DatabaseService.searchRecipes(uid, query);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByAlpha() async {
    recipes = await DatabaseService.sortByAlpha(uid);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByServings() async {
    recipes = await DatabaseService.sortByServings(uid);
    setState(() {
      recipes;
    });
  }

  Future<void> sortByTime() async {
    recipes = await DatabaseService.sortByTime(uid);
    setState(() {
      recipes;
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
                                    Color.fromARGB(255, 115, 138, 219)),
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
                          TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 115, 138, 219)),
                            child: Text(
                              "Cook Time",
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
                      );
                    },
                  );
                },
                icon: Icon(Icons.sort))
          ],
          backgroundColor: Color.fromARGB(255, 115, 138, 219),
          foregroundColor: Colors.white,
          title: Text('Liked Recipes',
              style: TextStyle(
                  color: Color.fromARGB(255, 247, 247, 247), fontSize: 20)),
          onSearch: (value) {
            setState(() => searchValue = value);
            searchByTitle(value);
          }),
      body: RefreshIndicator(
        onRefresh: () => getRecipes(),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: recipes.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: RecipeCard(
                title: recipes[index].name,
                servings: recipes[index].servings,
                ingredients: recipes[index].ingredients,
                preparationSteps: recipes[index].preparationSteps,
                cookTime: recipes[index].totalTime,
                thumbnailUrl: recipes[index].images,
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
                              "Delete",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              final docs = FirebaseFirestore.instance
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
                              'title': recipes[index].name,
                              'servings': recipes[index].servings,
                              'ingredients': recipes[index].ingredients,
                              'preparationSteps':
                                  recipes[index].preparationSteps,
                              'cookTime': recipes[index].totalTime,
                              'thumbnailUrl': recipes[index].images,
                            };
                            final docs = FirebaseFirestore.instance
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
      ),
    );
  }
}
