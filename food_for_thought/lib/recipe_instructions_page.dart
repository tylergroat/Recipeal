import 'package:flutter/material.dart';
import 'package:food_for_thought/edit_recipe.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecipeInstructionsPage extends StatefulWidget {
  @override
  RecipeInstructionsPageState createState() => RecipeInstructionsPageState();
}

@override
class RecipeInstructionsPageState extends State {
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
          'Add Cooking Instructions',
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
                // controller: cookingInstructions,
                minLines: 6,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:
                        'Cooking Instructions'),
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
                    onPressed: () { // async?
                      // TODO: Save recipe in database
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HomePage()));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
