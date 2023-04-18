import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../back-end/database.dart';
import '../../classes/recipe_class.dart';
import '../cards/recipe_card.dart';

//class to allow admin to approve user created recipes -- Implemented by : Gavin Fromm

class AllRecipesPage extends StatefulWidget {
  @override
  AllRecipesPageState createState() => AllRecipesPageState();
}

class AllRecipesPageState extends State<AllRecipesPage> {
  late List<Recipe> recipes = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  bool loaded = true;

  Future<void> getRecipes() async {
    recipes = await DatabaseService.getStoredRecipes();
    setState(() {
      recipes;
      loaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  RefreshIndicator body() {
    return RefreshIndicator(
      onRefresh: () => getRecipes(),
      child: loaded
          ? Center(
              child: SizedBox(
              height: 70,
              width: 70,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                strokeWidth: 2,
                colors: [Color.fromARGB(255, 244, 4, 4)],
              ),
            ))
          : Scrollbar(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: recipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: RecipeCard(
                      id: recipes[index].id,
                      title: recipes[index].name,
                      servings: recipes[index].servings,
                      ingredients: recipes[index].ingredients,
                      preparationSteps: recipes[index].preparationSteps,
                      cookTime: recipes[index].totalTime,
                      thumbnailUrl: recipes[index].images,
                      isVegetarian: recipes[index].isVegetarian,
                      isDairyFree: recipes[index].isDairyFree,
                      isPopular: recipes[index].isPopular,
                      isGlutenFree: recipes[index].isGlutenFree,
                      isVegan: recipes[index].isVegan,
                      isVeryHealthy: recipes[index].isVeryHealthy,
                    ),
                  );
                },
              ),
            ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.grey,
      title: Text('All Recipes'),
      centerTitle: true,
      automaticallyImplyLeading: true,
    );
  }
}
