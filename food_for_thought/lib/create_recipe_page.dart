import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  TextEditingController cookTime = TextEditingController();
  TextEditingController servings = TextEditingController();
  TextEditingController cookInstructions = TextEditingController();
  TextEditingController ingredients = TextEditingController();
  List<dynamic> ingredientsList = [];

  //variable to hold value after calling areAllFieldsFilled()
  bool allFieldsAreFilled = false;
  void areAllFieldsFilled() {
    //all controllers except ingredients because ingredients controller is cleared after 'add ingredient' button is clicked
    if (recipeTitle.text.toString().isNotEmpty &&
        servings.text.toString().isNotEmpty &&
        cookTime.text.toString().isNotEmpty &&
        // ingredientsList.isNotEmpty &&
        cookInstructions.text.isNotEmpty) {
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

  // TextField character limits
  int recipeTitleMaxLength = 50;
  int servingsMaxLength = 3;
  int cookTimeMaxLength = 3;
  int ingredientsMaxLength = 50;
  int cookInstructionsMaxLength = 1500;
  // FocusNodes for TextFields, toggles the suffixIcons being visible
  FocusNode recipeTitleFocusNode = FocusNode();
  FocusNode servingsFocusNode = FocusNode();
  FocusNode cookTimeFocusNode = FocusNode();
  FocusNode ingredientsFocusNode = FocusNode();
  FocusNode cookInstructionsFocusNode = FocusNode();
  // textfield suffixicon character count colors
  MaterialColor? recipeTitleCharCountColor;
  MaterialColor? cookInstructionsCharCountColor;
  MaterialColor? ingredientsCharCountColor;
  MaterialColor? cookTimeCharCountColor; //inactive
  MaterialColor? servingsCharCountColor; //inactive

  @override
  void initState() {
    super.initState();
    recipeTitleFocusNode.addListener(_onFocusChange);
    servingsFocusNode.addListener(_onFocusChange);
    cookTimeFocusNode.addListener(_onFocusChange);
    ingredientsFocusNode.addListener(_onFocusChange);
    cookInstructionsFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    recipeTitleFocusNode.dispose();
    servingsFocusNode.dispose();
    cookTimeFocusNode.dispose();
    ingredientsFocusNode.dispose();
    cookInstructionsFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {}); //update the state when the focus changes
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
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          //to set width of containers and other things, set to 90% of screen width
          double widthOfWidgets = constraints.maxWidth * .9;
          if (recipeTitle.text.length < (recipeTitleMaxLength * .5)) {
            // characters are < 50% of the limit
            recipeTitleCharCountColor = Colors.grey;
          } else if (recipeTitle.text.length < (recipeTitleMaxLength * .8)) {
            // characters are >= 50% and < 80% of the limit
            recipeTitleCharCountColor = Colors.orange;
          } else {
            // characters are >= 80% of the limit
            recipeTitleCharCountColor = Colors.red;
          }
          if (ingredients.text.length < (ingredientsMaxLength * .5)) {
            ingredientsCharCountColor = Colors.grey;
          } else if (ingredients.text.length < (ingredientsMaxLength * .8)) {
            ingredientsCharCountColor = Colors.orange;
          } else {
            ingredientsCharCountColor = Colors.red;
          }
          if (cookInstructions.text.length < (cookInstructionsMaxLength * .5)) {
            cookInstructionsCharCountColor = Colors.grey;
          } else if (cookInstructions.text.length <
              (cookInstructionsMaxLength * .8)) {
            cookInstructionsCharCountColor = Colors.orange;
          } else {
            cookInstructionsCharCountColor = Colors.red;
          }

          //these last 2 are inactive
          if (servings.text.length < (servingsMaxLength * .5)) {
            servingsCharCountColor = Colors.grey;
          } else if (servings.text.length < (servingsMaxLength * .8)) {
            servingsCharCountColor = Colors.orange;
          } else {
            servingsCharCountColor = Colors.red;
          }
          if (cookTime.text.length < (cookTimeMaxLength * .5)) {
            cookTimeCharCountColor = Colors.grey;
          } else if (cookTime.text.length < (cookTimeMaxLength * .8)) {
            cookTimeCharCountColor = Colors.orange;
          } else {
            cookTimeCharCountColor = Colors.red;
          }

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),

                    Container(
                      width: widthOfWidgets,
                      child: TextField(
                        focusNode: recipeTitleFocusNode,
                        controller: recipeTitle,
                        //Text Field for recipe namer
                        maxLength: recipeTitleMaxLength, //50 character limit
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Recipe Title',
                          suffixIcon: recipeTitleFocusNode.hasFocus
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    '${recipeTitle.text.length}/$recipeTitleMaxLength',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: recipeTitleCharCountColor),
                                  ),
                                )
                              : null,
                          counterText: '',
                          counterStyle: TextStyle(height: 0),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onEditingComplete: areAllFieldsFilled,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: (widthOfWidgets - 10) / 2,
                          child: TextField(
                            focusNode: servingsFocusNode,
                            controller: servings,
                            maxLength: servingsMaxLength,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Servings',
                              counterText: '',
                              counterStyle: TextStyle(height: 0),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            onEditingComplete: areAllFieldsFilled,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: (widthOfWidgets - 10) / 2,
                          child: TextField(
                            focusNode: cookTimeFocusNode,
                            controller: cookTime,
                            //Text Field for recipe name
                            maxLength:
                                cookTimeMaxLength, // 3 digit number max length
                            keyboardType: TextInputType
                                .number, // number keyboard for easy input
                            // allows only numbers in the input, useful in the case of preventing copy/pasting text into the field
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Cook Time (Minutes)',
                              counterText: '',
                              counterStyle: TextStyle(height: 0),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            onEditingComplete: areAllFieldsFilled,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // only show ingredients list if it has at least one item in it
                    Visibility(
                      visible: ingredientsList.isNotEmpty,
                      // ignore: sized_box_for_whitespace
                      child: Column(
                        children: [
                          Container(
                            width: widthOfWidgets,
                            height: 190,
                            child: Column(
                              children: [
                                Text("Your Ingredients:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(
                                  height: 5,
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: widthOfWidgets,
                                        height: 160,
                                        child: ListView.builder(
                                          itemCount: ingredientsList.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              dense: true,
                                              title:
                                                  Text(ingredientsList[index]),
                                              trailing: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  setState(() {
                                                    ingredientsList[index] =
                                                        null;
                                                    ingredientsList.removeWhere(
                                                        (element) =>
                                                            element ==
                                                            null); //this preserves the list
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),

                    Container(
                      width: widthOfWidgets,
                      child: Row(
                        //row containing the input field and the button to add ingredient
                        children: [
                          Expanded(
                            child: TextField(
                              // ingredient input field
                              controller: ingredients,
                              focusNode: ingredientsFocusNode,
                              maxLength:
                                  ingredientsMaxLength, //50 character max per ingredient entry
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Ingredients',
                                suffixIcon: ingredientsFocusNode.hasFocus
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          '${ingredients.text.length}/$ingredientsMaxLength',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: ingredientsCharCountColor),
                                        ),
                                      )
                                    : null,
                                counterText: '',
                                counterStyle: TextStyle(height: 0),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onEditingComplete: areAllFieldsFilled,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              //add ingredient button
                              onPressed: () {
                                if (ingredients.text.toString().isNotEmpty) {
                                  setState(() {
                                    ingredientsList
                                        .add(ingredients.text.toString());
                                    ingredients.clear();
                                  });
                                  // didChangeDependencies();
                                  areAllFieldsFilled();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please enter an ingredient.')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 244, 4, 4)),
                              child: Text(
                                'Add Ingredient',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: widthOfWidgets,
                      child: TextField(
                        focusNode: cookInstructionsFocusNode,
                        controller: cookInstructions,
                        minLines: 5,
                        maxLines: 8,
                        maxLength: cookInstructionsMaxLength, //character limit
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cooking Instructions',
                          suffixIcon: cookInstructionsFocusNode.hasFocus
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    '${cookInstructions.text.length}/$cookInstructionsMaxLength',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: cookInstructionsCharCountColor),
                                  ),
                                )
                              : null,
                          counterText: '',
                          counterStyle: TextStyle(height: 0),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        onEditingComplete: areAllFieldsFilled,
                      ),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
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
                    Container(
                      width: widthOfWidgets,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 244, 4, 4)),
                          onPressed: () async {
                            if (recipeTitle.text.toString().isNotEmpty &&
                                servings.text.toString().isNotEmpty &&
                                cookTime.text.toString().isNotEmpty &&
                                // ingredientsList.toString().isNotEmpty &&
                                cookInstructions.text.toString().isNotEmpty) {
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
                                'cookInstructions': cookInstructions.text,
                                // 'thumbnailUrl': downloadUrl,
                                'cookTime': cookTime.text
                              };
                              //send the recipe to firestore
                              await uploadRecipeToFirebase(
                                  recipeData: data, name: recipeTitle.text);
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
                              cookTime.clear();
                              servings.clear();
                              ingredients.clear();
                              ingredientsList.clear();
                              cookInstructions.clear();
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
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
