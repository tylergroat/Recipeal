import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/classes/created_recipe_class.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../back-end/database.dart';
import '../create-recipes/created_recipe_card.dart';

//class to allow admin to apprive user created recipes -- Implemented by : Gavin Fromm

class ApproveCreatedRecipesPage extends StatefulWidget {
  @override
  ApproveCreatedRecipesPageState createState() =>
      ApproveCreatedRecipesPageState();
}

class ApproveCreatedRecipesPageState extends State<ApproveCreatedRecipesPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<CreatedRecipe> createdRecipes = [];
  bool loaded = true;

  Future<void> getRecipes() async {
    createdRecipes = await DatabaseService.getCreatedRecipesForVerification();
    setState(() {
      createdRecipes;
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
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Approve Recipes'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
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
                  itemCount: createdRecipes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: CreatedRecipeCard(
                        title: createdRecipes[index].name,
                        servings: createdRecipes[index].servings,
                        ingredients: createdRecipes[index].ingredients,
                        cookInstructions:
                            createdRecipes[index].cookInstructions,
                        cookTime: createdRecipes[index].totalTime,
                        thumbnailUrl: '',
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
