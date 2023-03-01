import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/recipe_card.dart';
import 'authentification.dart';
import 'database.dart';

class ViewSavedRecipesPage extends StatefulWidget {
  @override
  ViewSavedRecipesPageState createState() => ViewSavedRecipesPageState();
}

class ViewSavedRecipesPageState extends State<ViewSavedRecipesPage> {
  late DatabaseReference db =
      FirebaseDatabase.instance.ref('user data/$uid/saved recipes');

  late List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    recipes = DatabaseService.getRecipesFromDB(uid!) as List<Recipe>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text(
          'Saved Recipes',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => getRecipes(),
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (BuildContext context, int index) {
            return RecipeCard(
              title: recipes[index].name,
              servings: recipes[index].servings,
              ingredients: recipes[index].ingredients,
              preparationSteps: recipes[index].preparationSteps,
              cookTime: recipes[index].totalTime,
              thumbnailUrl: recipes[index].images,
            );
          },
        ),
      ),
    );
  }
}
