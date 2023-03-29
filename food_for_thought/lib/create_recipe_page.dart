import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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

class RecipeCreationState extends State<RecipeCreation>
    with CreatedRecipeMixin {
  TextEditingController recipeTitle = TextEditingController();
  TextEditingController recipe = TextEditingController();
  TextEditingController timeCook = TextEditingController();
  TextEditingController servings = TextEditingController();
  TextEditingController preparationSteps = TextEditingController();
  TextEditingController ingredients = TextEditingController();
  List<dynamic> ingredientsList = [];

  //variable to hold value after calling areAllFieldsFilled()
  bool allFieldsAreFilled = false;
  void areAllFieldsFilled() {
    //all controllers except ingredients because ingredients controller is cleared after 'add ingredient' button is clicked
    if (recipeTitle.text.toString().isNotEmpty &&
        servings.text.toString().isNotEmpty &&
        timeCook.text.toString().isNotEmpty &&
        // ingredientsList.isNotEmpty &&
        preparationSteps.text.toString().isNotEmpty) {
      setState(() {
        allFieldsAreFilled = true;
      });
    }
    //else
    setState(() {
      allFieldsAreFilled = false;
    });
  }

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  //For user to input an image
  final picker = ImagePicker();
  // final pickedFile = await picker.getImage(source: ImageSource.gallery);

  XFile? xfileImage;
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      xfileImage = img!;
    });
  }

  Future<String> uploadImageToFirebase({
    required XFile? image,
    required String recipeName,
  }) async {
    try {
      if (user == null) throw Exception("User not logged in");

      final Reference firebaseStorageRef =
          storage.ref().child('created recipes').child(recipeName);

      // Uploading with the following line
      if (image != null) {
        final File file = File(image.path);
        await firebaseStorageRef.putFile(file);
        final String downloadUrl = await firebaseStorageRef.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception("Image file is null");
      }
    } catch (e) {
      throw Exception("Error uploading image to Firebase: $e");
    }
  }

  final emptyIngredientList = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please enter an ingredient first!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );
  final emptyInput = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Field',
      message: 'Please input all fields first!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

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
                          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
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
                          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
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
                  onChanged: (value) {
                    // didChangeDependencies();
                    areAllFieldsFilled();
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: servings,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Servings',
                  ),
                  onChanged: (value) {
                    // didChangeDependencies();
                    areAllFieldsFilled();
                  },
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
                  onChanged: (value) {
                    // didChangeDependencies();
                    areAllFieldsFilled();
                  },
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
                  onChanged: (value) {
                    // didChangeDependencies();
                    areAllFieldsFilled();
                  },
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

                        if (ingredientsList.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  width: 300,
                                  height: 300,
                                  child: Center(
                                    child: ListView.builder(
                                      itemCount: ingredientsList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                            title:
                                                Text(ingredientsList[index]));
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentMaterialBanner()
                            ..showMaterialBanner(emptyIngredientList);

                          Timer(
                              Duration(seconds: 3),
                              () => ScaffoldMessenger.of(context)
                                  .hideCurrentMaterialBanner());
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
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
                        if (ingredients.text.toString().isNotEmpty) {
                          ingredientsList.add(ingredients.text.toString());
                          ingredients.clear();
                          // didChangeDependencies();
                          areAllFieldsFilled();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please enter an ingredient.')),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
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
                  onChanged: (value) {
                    // didChangeDependencies();
                    areAllFieldsFilled();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                //     child: Text(
                //       'Choose a Photo!',
                //       style: TextStyle(fontSize: 20),
                //     ),
                //     onPressed: () {
                //       displayImageChoice();
                //     }),
                // //if image not null show the image
                // //if image null show text
                // Padding(
                //     padding: const EdgeInsets.all(4.0),
                //     child: xfileImage != null
                //         ? Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 20),
                //             child: ClipRRect(
                //               borderRadius: BorderRadius.circular(2),
                //               child: Image.file(
                //                 //to show image, you type like this.
                //                 File(xfileImage!.path),
                //                 fit: BoxFit.cover,
                //                 width: MediaQuery.of(context).size.width,
                //                 height: 300,
                //               ),
                //             ),
                //           )
                //         : Text(' ')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                    onPressed: () async {
                      if (recipeTitle.text.toString().isNotEmpty &&
                          servings.text.toString().isNotEmpty &&
                          timeCook.text.toString().isNotEmpty &&
                          // ingredientsList.toString().isNotEmpty &&
                          preparationSteps.text.toString().isNotEmpty) {
                        //checking if there is another recipe with the same name
                        final DocumentSnapshot recipeDoc =
                            await FirebaseFirestore.instance
                                .collection('created recipes')
                                .doc(recipeTitle.text)
                                .get();
                        //if recipe does not already exist

                        // //send the image to cloud storage
                        // String downloadUrl = await uploadImageToFirebase(
                        //     image: xfileImage, recipeName: recipeTitle.text);

                        //temporary variables hold recipe data
                        Map<String, dynamic> data = {
                          'title': recipeTitle.text,
                          'servings': servings.text,
                          'ingredients': ingredientsList,
                          'preparationSteps': preparationSteps.text,
                          // 'thumbnailUrl': downloadUrl,
                          'cookTime': timeCook.text
                        };

                        //send the recipe to firestore
                        await uploadRecipeToFirebase(recipeData: data);
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Recipe Created"),
                              content: Text(
                                  "Your recipe has been created successfully!"),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        );
                        // Clear all fields
                        recipeTitle.clear();
                        recipe.clear();
                        timeCook.clear();
                        servings.clear();
                        ingredients.clear();
                        ingredientsList.clear();
                        preparationSteps.clear();
                        setState(() {
                          xfileImage = null;
                        });
                      } else {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentMaterialBanner()
                          ..showMaterialBanner(emptyInput);

                        Timer(
                            Duration(seconds: 3),
                            () => ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner());
                      }
                    },
                    child: Text(
                      'Confirm Recipe Creation',
                      style: TextStyle(fontSize: 20),
                    )
                    //else: notify user that they already created that recipe (duplicate name)

                    ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ), // ),
    );
  }
}
