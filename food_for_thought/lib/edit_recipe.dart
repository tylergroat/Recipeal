import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


  class Recipe {
  String name;
  String image;
  List<String> ingredients;
  String description;

  Recipe({
    required this.name,
    required this.image,
    required this.ingredients,
    required this.description,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Recipe myRecipe = Recipe(
    name: "Chocolate Cake",
    image: "https://www.example.com/chocolate_cake.jpg",
    ingredients: ["flour", "sugar", "cocoa powder", "baking powder", "eggs", "milk", "vegetable oil"],
    description: "A delicious chocolate cake recipe that is perfect for any occasion.",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe App"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditRecipePage(recipe: myRecipe),
              ),
            );
          },
          child: Text("Edit Recipe"),
        ),
      ),
    );
  }
}

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;

  EditRecipePage({required this.recipe});

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _ingredientsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.recipe.name;
    _imageController.text = widget.recipe.image;
    _descriptionController.text = widget.recipe.description;
    _ingredientsController.text = widget.recipe.ingredients.join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Recipe"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
              ),
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(
                labelText: "Image URL",
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                labelText: "Ingredients (separate with commas)",
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                widget.recipe.name = _nameController.text;
                widget.recipe.image = _imageController.text;
                widget.recipe.description = _descriptionController.text;
                widget.recipe.ingredients = _ingredientsController.text.split(",").map((e) => e.trim()).toList();

                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}