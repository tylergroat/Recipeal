import 'package:flutter/material.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/recipe_card.dart';

import 'api_config.dart';

class DiscoverPage extends StatefulWidget {
  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  late List<Recipe> recipes = [];
  bool _isLoading = true;
  int index = 0;
  int count = 0;

  @override
  void initState() {
    super.initState();
    // getFeaturedRecipes();
  }

  Future<void> getFeaturedRecipes() async {
    recipes = await RecipeApi.getFeaturedRecipe();
    setState(() {
      _isLoading = false;
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
          'Discover',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  RecipeCard(
                    title: recipes[index].name,
                    servings: recipes[index].servings,
                    ingredients: recipes[index].ingredients,
                    preparationSteps: recipes[index].preparationSteps,
                    cookTime: recipes[index].totalTime,
                    thumbnailUrl: recipes[index].images,
                  ),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 115, 138, 219),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        size: 35,
                      ),
                      onPressed: () {
                        getFeaturedRecipes();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
