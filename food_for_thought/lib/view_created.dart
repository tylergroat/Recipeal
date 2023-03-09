import 'package:flutter/material.dart';

class CreatedRecipesPage extends StatefulWidget {
  @override
  CreatedRecipesPageState createState() => CreatedRecipesPageState();
}

class CreatedRecipesPageState extends State<CreatedRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text(
          'Created Recipes',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
