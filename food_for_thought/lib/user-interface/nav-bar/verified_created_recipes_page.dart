import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/user_class.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../back-end/authentification.dart';
import '../../classes/created_recipe_class.dart';
import '../../classes/public_created_recipe_class.dart';
import '../cards/created_recipe_card.dart';
import '../cards/public_created_recipe_card.dart';

class CommunityFeedPage extends StatefulWidget {
  @override
  CommunityFeedPageState createState() => CommunityFeedPageState();
}

class CommunityFeedPageState extends State<CommunityFeedPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late UserInformation user;

  late List<PublicCreatedRecipe> recipes = [];
  late List<String> names = [];
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool _isLoading = true;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> getRecipes() async {
    FirebaseFirestore.instance
        .collection('verified-created-recipes')
        .get()
        .then((querySnapshot) async {
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
      for (int i = 0; i < recipes.length; i++) {
        String name = await DatabaseService.getUsersName(recipes[i].userId);
        print(name);
        names.add(name);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> getUser(String uid) async {
    user = await DatabaseService.getUser(uid);
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
            recipes.clear();
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
                        onDoubleTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm'),
                                content: Text(
                                    'Do you want to add ${recipes[index].name} to your liked recipes?'),
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
                                      print(recipes[index].name);
                                      Navigator.pop(context);
                                      Map<String, dynamic> savedRecipe = {
                                        'title': recipes[index].name,
                                        'servings': recipes[index].servings,
                                        'ingredients':
                                            recipes[index].ingredients,
                                        'cookInstructions':
                                            recipes[index].cookInstructions,
                                        'thumbnailUrl': recipes[index].image,
                                        'cookTime': recipes[index].totalTime,
                                        'userId': recipes[index].userId,
                                      };
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(uid)
                                          .collection('liked recipe (user)')
                                          .doc(recipes[index].name)
                                          .set(savedRecipe);
                                      _isLoading = true;
                                      recipes.clear();
                                      getRecipes();
                                      setState(() {});
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: Column(children: [
                          PublicCreatedRecipeCard(
                            title: recipes[index].name,
                            servings: recipes[index].servings,
                            ingredients: recipes[index].ingredients,
                            cookInstructions: recipes[index].cookInstructions,
                            cookTime: recipes[index].totalTime,
                            thumbnailUrl: recipes[index].image,
                            userId: recipes[index].userId,
                          ),
                          Container(
                            height: 50,
                            width: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 244, 4, 4),
                            ),
                            child: SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      'Created By: ${names[index]}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 375,
                            child: Divider(
                              thickness: 2,
                            ),
                          )
                        ]),
                      );
                    },
                  ),
                ),
    );
  }
}
