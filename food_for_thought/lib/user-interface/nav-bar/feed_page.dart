import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:food_for_thought/user-interface/cards/recipe_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../back-end/api_config.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

//class to define how the recipe feed is presented to the user -- Implemented by : Gavin Fromm
//Tags for Filtering system Implemented by : Jaideep Chunduri

class FeedPage extends StatefulWidget {
  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  //initilize varibles
  final cardController = CardSwiperController();
  int index = 0;
  bool isLoading = true;
  late List<Recipe> recipes = [];
  late List<String> ingredients = [];
  late int lastIndex = recipes.length - 3; //max length before refresh
  FirebaseFirestore db = FirebaseFirestore.instance; //instance of database
  //list of tags for filtering
  List<String> tags = [
    'Random',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Vegan',
    'Vegetarian',
    'Dairy Free'
  ];

  String? selectedTag = 'Random'; //default random recipes filter

  @override
  void initState() {
    super.initState();
    try {
      Timer(Duration(seconds: 1), () => getRecipes(selectedTag));
    } on Exception {
      getRecipes(selectedTag);
    }
  }

  Future<void> getRecipes(String? tag) async {
    //method to get recipes from api to populate our page
    if (selectedTag == "Random") {
      //default - if choice is random, show random recipes
      print('getting random recipes');
      recipes = await RecipeApi.getRecipes();
    } else if (selectedTag == "random") {
      print('getting random recipes');
      recipes = await RecipeApi.getRecipes();
    } else {
      //if filter is selected, display recipes that match the given filter
      print('getting $tag recipes');
      recipes = await RecipeApi.getRecipesByTag(tag!);
      print(recipes[index].name);
    }

    for (int i = 0; i < recipes.length; i++) {
      //to add api recipes to our local database
      Map<String, dynamic> savedRecipe = {
        'id': recipes[i].id,
        'title': recipes[i].name,
        'servings': recipes[i].servings,
        'ingredients': recipes[i].ingredients,
        'preparationSteps': recipes[i].preparationSteps,
        'cookTime': recipes[i].totalTime,
        'thumbnailUrl': recipes[i].images,
        'isVegetarian': recipes[i].isVegetarian,
        'isVegan': recipes[i].isVegan,
        'isGlutenFree': recipes[i].isGlutenFree,
        'isDairyFree': recipes[i].isDairyFree,
        'isVeryHealthy': recipes[i].isVeryHealthy,
        'isPopular': recipes[i].isPopular,
      };
      db.collection("recipes").doc(recipes[i].name).set(savedRecipe);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropDownMenuItems = tags
        .map((String item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList();
    return Scaffold(
      floatingActionButton: floatingIcon(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: appBar(),
      body: isLoading ? loadingIndicator() : body(dropDownMenuItems),
    );
  }

  SingleChildScrollView body(List<DropdownMenuItem<String>> dropDownMenuItems) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment(.75, 0),
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 190, 189, 189),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    weight: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Center(
                        child: DropdownButton<String>(
                          onChanged: (s) {
                            print(s?.toLowerCase());
                            setState(() {
                              selectedTag = s;
                            });
                            getRecipes(selectedTag?.toLowerCase());
                          },
                          items: dropDownMenuItems,
                          value: selectedTag,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            width: MediaQuery.of(super.context).size.width,
            height: (MediaQuery.of(super.context).size.width)*.85,
            child: Expanded(
              child: CardSwiper(
                cardBuilder: (context, index) => RecipeCard(
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

                cardsCount: recipes.length,
                padding: const EdgeInsets.all(0.0),

                // layout: SwiperLayout.STACK,
                // itemWidth: 300,
                // itemHeight: 400,
                // pagination: SwiperPagination(),
                controller: cardController,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 244, 4, 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  radius: 30,
                  onTap: () {
                    if (index >= lastIndex) {
                      index = 0;
                      getRecipes(selectedTag?.toLowerCase());
                      print('Getting ${selectedTag} recipes');
                    } else {
                      index++;
                      recipes.removeAt(index);
                      setState(() {});
                    }
                  },
                  splashColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Container(
                    height: 65,
                    width: 100,
                    child: Icon(
                      Icons.thumb_down_alt,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Material(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 244, 4, 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  radius: 30,
                  onTap: () {
                    Map<String, dynamic> savedRecipe = {
                      'id': recipes[index].id,
                      'title': recipes[index].name,
                      'servings': recipes[index].servings,
                      'ingredients': recipes[index].ingredients,
                      'preparationSteps': recipes[index].preparationSteps,
                      'cookTime': recipes[index].totalTime,
                      'thumbnailUrl': recipes[index].images,
                      'isVegetarian': recipes[index].isVegetarian,
                      'isVegan': recipes[index].isVegan,
                      'isGlutenFree': recipes[index].isGlutenFree,
                      'isDairyFree': recipes[index].isDairyFree,
                      'isVeryHealthy': recipes[index].isVeryHealthy,
                      'isPopular': recipes[index].isPopular,
                    };

                    db
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("saved recipes")
                        .doc(recipes[index].name)
                        .set(savedRecipe);

                    if (index >= lastIndex) {
                      index = 0;
                      getRecipes(selectedTag?.toLowerCase());
                      print('Getting : ${selectedTag} recipes');
                      ;
                    } else {
                      recipes.removeAt(index);
                      index++;
                      setState(
                        () {
                          index = index;
                        },
                      );
                    }
                  },
                  splashColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Container(
                    height: 65,
                    width: 100,
                    child: Icon(
                      Icons.thumb_up_alt,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Center loadingIndicator() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 220,
          ),
          SizedBox(
            height: 70,
            width: 70,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,
              strokeWidth: 2,
              colors: [Color.fromARGB(255, 244, 4, 4)],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Loading Recipes...',
            style: TextStyle(
                color: Color.fromARGB(
                  255,
                  244,
                  4,
                  4,
                ),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(80),
        ),
      ),
      backgroundColor: Colors.grey,
      toolbarHeight: 30,
      centerTitle: true,
      title: Text(
        'Feed',
        style:
            TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Container floatingIcon(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 244, 4, 4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Welcome to Recipeal!"),
                content: Text(
                    "This is the feed page. Here, you will find a wide variety of recipes, unless you would like to apply a filter! Simply choose the like or dislike button to begin!"),
                actions: [
                  Container(
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color.fromARGB(255, 244, 4, 4),
                    ),
                    child: TextButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
        icon: Icon(
          Icons.info,
          color: Colors.white,
          weight: 70,
          size: 20,
        ),
      ),
    );
  }
}
