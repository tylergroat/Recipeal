import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_for_thought/created_recipe.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

////global (accessed in recipe_instructions_page.dart)
////CreatedRecipe createdRecipeObject = CreatedRecipe();

class RecipeCreation extends StatefulWidget {
  @override
  RecipeCreationState createState() => RecipeCreationState();
}

class RecipeCreationState extends State<RecipeCreation> {
  TextEditingController recipeTitle = TextEditingController();
  TextEditingController recipe = TextEditingController();
  TextEditingController timeCook = TextEditingController();
  TextEditingController servings = TextEditingController();
  TextEditingController preparationSteps = TextEditingController();
  TextEditingController ingredients = TextEditingController();
  List<String> ingredientsList = [];

  List<TextField> fields = [];

  ///For the image:
  ///This is going to be saved in firebase "Storage" using a folder system.
  ///Each user has a folder created for them, and the image name will be set to the name of the recipe and stored within the user-specific folder.
  ///In the created recipe within the firestore database, there needs to be a "foreign key" to the corresponding image in the cloud storage.
  ///In code, this would look like:
  ///(1) get the foreign key(for the image) from the selected created recipe
  ///(2) get the image from the cloud storage
  ///(3) display the image within the app appropriately
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  //This function takes the user's selected image for the created recipe and
  //saves it to firebase storage with parameter recipeName as the file name
  Future<void> uploadImageToFirebase(XFile imageFile, String recipeName) async {
    Reference ref = storage.ref().child('images/$recipeName');
    await ref.putFile(File(imageFile.path));
  }

  //This deletes the image of the created recipe from firebase storage
  Future<void> deleteImageFromFirebase(String recipeName) async {
    storage.ref().child('images/$recipeName').delete();
  }

  //This function takes the text input from the fields and saves the created recipe info
  //to firestore as collection:users > [current user] > collection:created recipes > [adding this recipe here]
  Future<void> uploadRecipeToFirebase(
      String recipeName,
      int servings,
      String ingredients,
      String preparationSteps,
      int cookTime,
      String thumbnailUrl) async {
    Map<String, dynamic> createdRecipe = {
      'title': recipeName,
      'servings': servings,
      'ingredients': ingredients,
      'preparationSteps': preparationSteps,
      'cookTime': cookTime,
      'thumbnailUrl': thumbnailUrl,
    };
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('created recipes')
        .add(createdRecipe);
  }

  Future<void> deleteRecipeFromFirebase(String recipeName) async {
    //First delete the fields of the created recipe.
    //This does not happen automatically when delete() is called on the parent.
    final recipe = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('created recipes')
        .doc(recipeName);
    final deleteTheFields = <String, dynamic>{
      'title': FieldValue.delete(),
      'servings': FieldValue.delete(),
      'ingredients': FieldValue.delete(),
      'preparationSteps': FieldValue.delete(),
      'cookTime': FieldValue.delete(),
      'thumbnailUrl': FieldValue.delete(),
    };
    recipe.update(deleteTheFields);

    //Next, delete the created recipe parent document after all fields are deleted
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('created recipes')
        .doc(recipeName)
        .delete()
        .then(
          (doc) => print("Document deleted: $recipeName"),
          onError: (e) => print("Error updating document $e"),
        );

    //Finally, delete the image from Firebase storage
    deleteImageFromFirebase(recipeName);
  }

  //This returns the url of the image that was saved in the firebase cloud storage
  //Note: recipeName should be the same as the argument passed to the uploadImageToFirebase
  //function so the correct reference is made
  Future<String> getImageUrl(String recipeName) async {
    Reference ref = storage.ref().child('images/$recipeName');
    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

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
                  //TODO: either wrap onPressed with while(all inputs not null){onPressed(){}} OR inside onPressed say if(input1==null || input2==null || ...) {give user empty input error}
                  onPressed: () {
                    //TODO: send the created recipe to database

                    uploadImageToFirebase(
                        image,
                        recipeTitle
                            as String); //First upload the image to firebase
                    //Next save the recipe to firebase
                    //
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
