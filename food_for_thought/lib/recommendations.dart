import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/api_config.dart';
import 'package:food_for_thought/database.dart';
import 'package:food_for_thought/recipe.dart';
import 'package:food_for_thought/similar_recipe.dart';

class RecommendationPage extends StatefulWidget {
  @override
  RecommendationPageState createState() => RecommendationPageState();
}

class RecommendationPageState extends State<RecommendationPage> {
  late List<SimilarRecipe> urls = [];
  late List<Recipe> recipes = [];
  bool _isLoading = true;
  int index = 0;
  int count = 0;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> getRecipes() async {
    recipes = await DatabaseService.getRecipes(uid, 'saved recipes');
    print(recipes[0].id);

    urls = await RecipeApi.getSimilarRecipes(recipes[0].id);

    for (int i = 0; i < urls.length - 1; i++) {
      print(urls[i].title);
    }
    setState(() {
      _isLoading = false;
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
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
        backgroundColor: Colors.grey,
        toolbarHeight: 30,
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
                  Text('${recipes[0].id}')
                ],
              ),
            ),
    );
  }
}
