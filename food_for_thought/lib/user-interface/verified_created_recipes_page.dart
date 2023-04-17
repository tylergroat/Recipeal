import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../classes/created_recipe_class.dart';
import '../classes/public_created_recipe_class.dart';
import 'create-recipes/created_recipe_card.dart';
import 'create-recipes/public_created_recipe_card.dart';

class CommunityFeedPage extends StatefulWidget {
  @override
  CommunityFeedPageState createState() => CommunityFeedPageState();
}

class CommunityFeedPageState extends State<CommunityFeedPage> {
  late List<PublicCreatedRecipe> recipes = [];
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool _isLoading = true;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> getRecipes() async {
    FirebaseFirestore.instance
        .collection('verified-created-recipes')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        PublicCreatedRecipe recipe = PublicCreatedRecipe(
          name: data['title'],
          servings: data['servings'],
          ingredients: data['ingredients'],
          cookInstructions: data['cookInstructions'],
          totalTime: data['cookTime'],
          image: data['thumbnailUrl'],
          userId: data['userId'],
        );
        recipes.add(recipe);
      }
      setState(() {});
    });
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
          onPressed: () {
            setState(() {
              _isLoading = true;
              recipes.clear();
            });
            getRecipes();
          },
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
          'Community Recipes',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Column(
              children: [
                SizedBox(
                  height: 220,
                ),
                Center(
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      strokeWidth: 2,
                      colors: [Color.fromARGB(255, 244, 4, 4)],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Loading Community Recipes...',
                  style: TextStyle(
                      color: Color.fromARGB(
                        255,
                        244,
                        4,
                        4,
                      ),
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          : recipes.isEmpty
              ? Center(child: Text('No Community Recipes Available'))
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
                        child: Column(
                          children: [
                            PublicCreatedRecipeCard(
                              title: recipes[index].name,
                              servings: recipes[index].servings,
                              ingredients: recipes[index].ingredients,
                              cookInstructions: recipes[index].cookInstructions,
                              cookTime: recipes[index].totalTime,
                              thumbnailUrl: recipes[index].image,
                              userId: recipes[index].userId,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 244, 4, 4),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                radius: 30,
                                onTap: () {
                                  Map<String, dynamic> savedRecipe = {
                                    'title': recipes[index].name,
                                    'servings': recipes[index].servings,
                                    'ingredients': recipes[index].ingredients,
                                    'cookInstructions':
                                        recipes[index].cookInstructions,
                                    'thumbnailUrl': recipes[index].image,
                                    'cookTime': recipes[index].totalTime,
                                    'userId': recipes[index].userId,
                                  };

                                  db
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection("liked recipe (user)")
                                      .doc(recipes[index].name)
                                      .set(savedRecipe);
                                },
                                splashColor: Colors.white,
                                highlightColor: Colors.grey,
                                child: Container(
                                  height: 65,
                                  width: 100,
                                  child: Icon(
                                    Icons.thumb_up_alt,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
