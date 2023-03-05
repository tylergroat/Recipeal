import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/feed_page.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/recipe_card.dart';
import 'package:food_for_thought/saved_recipe_card.dart';
import 'authentification.dart';
import 'database.dart';

class ViewSavedRecipesPage extends StatefulWidget {
  @override
  ViewSavedRecipesPageState createState() => ViewSavedRecipesPageState();
}

class ViewSavedRecipesPageState extends State<ViewSavedRecipesPage> {
  late List<Recipe> recipes = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    recipes = await DatabaseService.getSavedRecipes(uid);
    setState(() {
      recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort))
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text(
          'Liked Recipes',
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
            return SavedRecipeCard(
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
