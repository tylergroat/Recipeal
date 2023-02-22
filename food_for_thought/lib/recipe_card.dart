import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable/expandable.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final int servings;
  final List<dynamic> ingredients;
  final String preparationSteps;
  final int cookTime;
  final String thumbnailUrl;
  RecipeCard({
    required this.title,
    required this.servings,
    required this.ingredients,
    required this.preparationSteps,
    required this.cookTime,
    required this.thumbnailUrl,
  });
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: Container(
        margin: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        width: MediaQuery.of(context).size.width,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage(thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.yellow,
                          size: 18,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Serves $servings',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.yellow,
                          size: 18,
                        ),
                        SizedBox(width: 7),
                        Text('$cookTime',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      back: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            width: MediaQuery.of(context).size.width,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: Offset(
                    0.0,
                    10.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: -6.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                    child: Container(
                      width: 300,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return ingredients[index];
                    //     },
                    //   ),
                    // ),
                    InkWell(
                        child: Text(
                          'Preparation Steps',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          launchUrl(Uri.parse(
                              preparationSteps.replaceAll('/private', '')));
                          print('URL:$preparationSteps');
                        }),

                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
