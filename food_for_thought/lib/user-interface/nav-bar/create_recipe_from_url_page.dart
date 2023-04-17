import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/api_config.dart';
import 'package:food_for_thought/user-interface/cards/recipe_card.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../back-end/authentification.dart';
import '../../classes/recipe_class.dart';

class CreateRecipeFromURLPage extends StatefulWidget {
  @override
  CreateRecipeFromURLPageState createState() => CreateRecipeFromURLPageState();
}

class CreateRecipeFromURLPageState extends State<CreateRecipeFromURLPage> {
  TextEditingController urlController = TextEditingController();

  final emptyInput = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please enter a recipe url!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  List<Recipe> extractedRecipe = [];
  bool loaded = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(80),
            ),
          ),
          backgroundColor: Colors.grey,
          toolbarHeight: 30,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'URL Upload',
            style: TextStyle(fontSize: 20),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.upload),
                      labelText: 'Recipe URL',
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromARGB(255, 244, 4, 4)),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (urlController.value.text.isNotEmpty) {
                            extractedRecipe = await RecipeApi.extractFromUrl(
                                urlController.value.text);
                            if (extractedRecipe.isNotEmpty) {
                              setState(() {
                                loading = false;
                                loaded = false;
                              });
                            } else {
                              print('error creating recipe');
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentMaterialBanner()
                              ..showMaterialBanner(emptyInput);
                            Timer(
                                Duration(seconds: 2),
                                () => ScaffoldMessenger.of(context)
                                    .hideCurrentMaterialBanner());
                          }
                        },
                        child: Text(
                          'Extract Recipe',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromARGB(255, 244, 4, 4)),
                      child: TextButton(
                        onPressed: () {
                          urlController.clear();
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                loaded
                    ? Text('')
                    : loading
                        ? Column(children: [
                            SizedBox(
                              height: 150,
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
                          ])
                        : Column(
                            children: [
                              RecipeCard(
                                id: extractedRecipe[0].id,
                                title: extractedRecipe[0].name,
                                servings: extractedRecipe[0].servings,
                                ingredients: extractedRecipe[0].ingredients,
                                preparationSteps:
                                    extractedRecipe[0].preparationSteps,
                                cookTime: extractedRecipe[0].totalTime,
                                thumbnailUrl: extractedRecipe[0].images,
                                isVegetarian: extractedRecipe[0].isVegetarian,
                                isDairyFree: extractedRecipe[0].isDairyFree,
                                isPopular: extractedRecipe[0].isPopular,
                                isGlutenFree: extractedRecipe[0].isGlutenFree,
                                isVegan: extractedRecipe[0].isVegan,
                                isVeryHealthy: extractedRecipe[0].isVeryHealthy,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color.fromARGB(255, 244, 4, 4)),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color.fromARGB(255, 244, 4, 4)),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Add to Liked Recipes',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ));
  }
}
