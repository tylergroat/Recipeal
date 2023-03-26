import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_for_thought/created_recipe.dart'; //mixin with functions for firebase
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class RecipeCreation extends StatefulWidget {
  @override
  RecipeCreationState createState() => RecipeCreationState();
}

class RecipeCreationState extends State<RecipeCreation> with CreatedRecipe {
  TextEditingController recipeTitle = TextEditingController();
  TextEditingController recipe = TextEditingController();
  TextEditingController timeCook = TextEditingController();
  TextEditingController servings = TextEditingController();
  TextEditingController preparationSteps = TextEditingController();
  TextEditingController ingredients = TextEditingController();
  List<String> ingredientsList = [];

  List<TextField> fields = [];

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //For user to input an image
  late XFile image;
  final ImagePicker picker = ImagePicker();
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img!;
    });
  }

  void displayImageChoice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 115, 138, 219)),
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Text(' From Gallery'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 115, 138, 219)),
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          Text(' From Camera'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
        backgroundColor: Colors.grey,
        toolbarHeight: 35,
        centerTitle: true,
        title: Text(
          'Create a Recipe',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                TextField(
                  controller: recipeTitle,
                  //Text Field for recipe namer
                  maxLength: 50, //50 character limit
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Recipe Title'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: servings,
                  //Text Field for recipe name
                  maxLength: 3, // 3 digit number max length
                  keyboardType:
                      TextInputType.number, // number keyboard for easy input
                  // allows only numbers in the input, useful in the case of preventing copy/pasting text into the field
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Servings'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: timeCook,
                  //Text Field for recipe name
                  maxLength: 3, // 3 digit number max length
                  keyboardType:
                      TextInputType.number, // number keyboard for easy input
                  // allows only numbers in the input, useful in the case of preventing copy/pasting text into the field
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cook Time (Minutes)'),
                ),
                SizedBox(
                  height: 20,
                ),
                // addIngredient(),
                // Flexible(
                //   fit: FlexFit.loose,
                //   child: listView(),
                // ),
                TextField(
                  controller: ingredients,
                  maxLength: 50, //50 character max per ingredient entry
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Ingredients'),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        for (int i = 0; i < ingredientsList.length - 1; i++) {
                          print('$i: ${ingredientsList[i]}');
                        }
                        ingredients.clear();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 115, 138, 219)),
                      child: Text(
                        'View All Ingredients',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        ingredientsList.add(ingredients.text.toString());
                        ingredients.clear();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 115, 138, 219)),
                      child: Text(
                        'Add Ingredient',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: preparationSteps,
                  minLines: 5,
                  maxLines: 8,
                  maxLength: 1500, //character limit
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cooking Instructions'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 115, 138, 219)),
                  child: Text(
                    'Confirm Recipe Creation',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    //checking if there is another recipe with the same name
                    final DocumentSnapshot recipeDoc = await FirebaseFirestore
                        .instance
                        .collection('created recipes')
                        .doc(recipeTitle as String)
                        .get();
                    //if recipe does not already exist
                    if (!recipeDoc.exists) {
                      //send the image to cloud storage
                      await uploadImageToFirebase(
                          image: image, recipeName: recipeTitle as String);

                      //temporary variables hold recipe data
                      String url = await getImageUrl(recipeTitle as String);
                      Map<String, dynamic> data = {
                        'title': recipeTitle as String,
                        'servings': servings as int,
                        'ingredients': ingredientsList as List<String>,
                        'preparationSteps': preparationSteps as String,
                        'thumbnailUrl': url as String,
                        'cookTime': timeCook as String
                      };

                      //send the recipe to firestore
                      await uploadRecipeToFirebase(
                          recipeData: data, imageUrl: url);
                    }
                    //else: notify user that they already created that recipe (duplicate name)
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ), // ),
    );
  }
}
