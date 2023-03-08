import 'package:flutter/material.dart';
import 'package:food_for_thought/edit_recipe.dart';
import 'dart:io';
import 'package:food_for_thought/created_recipe.dart';
import 'package:food_for_thought/recipecreation_page.dart';

class RecipeInstructionsPage extends StatefulWidget {
  @override
  RecipeInstructionsPageState createState() => RecipeInstructionsPageState();
}

@override
class RecipeInstructionsPageState extends State {
  TextEditingController cookingInstructions = TextEditingController();
  TextEditingController cookingTime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
        backgroundColor: Colors.grey,
        toolbarHeight: 35,
        centerTitle: true,
        title: Text(
          'Add Cooking Instructions',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: TextField(
                controller: cookingInstructions,
                minLines: 5,
                maxLines: 8,
                maxLength: 1500, //character limit
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cooking Instructions'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: TextField(
                controller: cookingTime,
                maxLength: 3, //character limit
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'How many minutes does it take to cook?'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 380.0,
                height: 50.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 115, 138, 219)),
                    child: Text(
                      'Confirm Recipe Creation',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      // async?
                      createdRecipeObject.preparationSteps =
                          cookingInstructions as String?;
                      createdRecipeObject.totalTime = cookingTime as int?;
                      // TODO: Save recipe in database - CreatedRecipe.sendToDatabase();

                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomePage()));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
