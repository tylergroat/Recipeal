import 'package:flutter/material.dart';
import 'package:food_for_thought/recipe_instructions_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecipeCreation extends StatefulWidget {
  @override
  RecipeCreationState createState() => RecipeCreationState();
}

class RecipeCreationState extends State<RecipeCreation> {
  TextEditingController recipeTitle = TextEditingController();
  TextEditingController recipe = TextEditingController();
  TextEditingController timeCook = TextEditingController();
  TextEditingController servings = TextEditingController();

  final List<TextEditingController> ingredients = [];
  List<TextField> fields = [];

  XFile? image;
  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

  @override
  void dispose() {
    for (final controller in ingredients) {
      controller.dispose();
    }
    super.dispose();
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

  Widget listView() {
    return ListView.builder(
      itemCount: fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: fields[index],
        );
      },
    );
  }

  Widget addIngredient() {
    return ListTile(
      title: SizedBox(
        width: 20.0,
        height: 50.0,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 115, 138, 219)),
            child: Text(
              'Add Ingredient',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              final ingredientController = TextEditingController();
              final field = TextField(
                controller: ingredientController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ingredient ${ingredients.length + 1}",
                ),
              );

              setState(() {
                ingredients.add(ingredientController);
                fields.add(field);
              });
            }),
      ),
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: TextField(
                controller: recipeTitle,
                //Text Field for username/email
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Recipe Title'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: ElevatedButton(
                onPressed: () {
                  displayImageChoice();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 115, 138, 219)),
                child: Text('Upload Photo'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //if image not null show the image
            //if image null show text
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: image != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.file(
                            //to show image, you type like this.
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                    : Text(' ')),
            addIngredient(),
            Expanded(child: listView()),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 380.0,
                height: 50.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 115, 138, 219)),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //TODO: Combine the data from this and the instructions page input and save to the database
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RecipeInstructionsPage()));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
