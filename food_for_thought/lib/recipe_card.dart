import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:food_for_thought/nutrition.dart';

import 'api_config.dart';

//class to define how the recipes are presented to the user -- Implemented by : Gavin Fromm

class RecipeCard extends StatelessWidget {
  final int id;
  final String title;
  final int servings;
  final List<dynamic> ingredients;
  final String preparationSteps;
  final int cookTime;
  final String thumbnailUrl;
  final bool isVegetarian;
  final bool isDairyFree;
  final bool isPopular;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isVeryHealthy;
  RecipeCard({
    required this.id,
    required this.title,
    required this.servings,
    required this.ingredients,
    required this.preparationSteps,
    required this.cookTime,
    required this.thumbnailUrl,
    required this.isVegetarian,
    required this.isDairyFree,
    required this.isPopular,
    required this.isGlutenFree,
    required this.isVegan,
    required this.isVeryHealthy,
  });
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: buildFront(context),
      back: buildBack(context),
    );
  }

  Widget buildFront(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 1),
      width: MediaQuery.of(context).size.width,
      height: 340,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 190, 189, 189)),
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
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
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      isVegetarian
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Vegetarian',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      isDairyFree
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Dairy Free',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      isPopular
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Popular',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Serves $servings',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    // Color.fromARGB(255, 244, 4, 4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      showNutrition(context, id);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          'Nutrition',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )
                      ],
                    ),
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
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text('$cookTime min',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showNutrition(BuildContext context, int id) async {
    Nutrition nutrition = await RecipeApi.nutritionById(id);
    String calories = nutrition.calories;
    String carbs = nutrition.carbs;
    String fat = nutrition.fat;
    // ignore: use_build_context_synchronously
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Nutrition Facts'),
              content: Container(
                height: 350,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        'Calories: ${nutrition.calories}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 200,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        'Carbs: ${nutrition.carbs}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 200,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          'Fat: ${nutrition.fat}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 200,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                          child: Text(
                        'Protein: ${nutrition.protein}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
              ));
        });
  }

  Widget buildBack(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      width: MediaQuery.of(context).size.width,
      height: 340,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 190, 189, 189)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: Container(
                  width: 300,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              width: 325,
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
            ),
            Column(
              children: [
                Text(
                  '\nIngredients',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.underline),
                ),
                SizedBox(
                  height: 20,
                ),
                for (int i = 1; i <= ingredients.length - 1; i++) ...[
                  Container(
                    width: 200,
                    child: Text(("$i. ${ingredients[i]['original']}\n"),
                        style: TextStyle()),
                  )
                ],
                Text(
                  '\nPreparation Steps',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.underline),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350,
                  child: Html(
                    data: preparationSteps,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Additional Information',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.underline),
                ),
                SizedBox(
                  height: 10,
                ),

                /////////////////////////top row//////////////////////////////////////////////////
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          isVegetarian
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Vegetarian',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          isDairyFree
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Dairy Free',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          isPopular
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Popular',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                ////////////bottom row////////////////////////////////////////////////////////
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          isVegan
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Vegan',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          isGlutenFree
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Gluten Free',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          isVeryHealthy
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Very Healthy',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
