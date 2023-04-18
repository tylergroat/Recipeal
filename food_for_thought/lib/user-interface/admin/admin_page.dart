import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/authentification.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/created_recipe_class.dart';
import 'package:food_for_thought/classes/public_created_recipe_class.dart';
import 'package:food_for_thought/user-interface/admin/all_recipes_page.dart';
import 'package:food_for_thought/user-interface/admin/created_recipes_approval_page.dart';
import 'package:food_for_thought/user-interface/user-functions/login_page.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'all_users_page.dart';

//class to allow admin to apprive user created recipes -- Implemented by : Gavin Fromm

class AdminPage extends StatefulWidget {
  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<PublicCreatedRecipe> createdRecipesVerification = [];
  List<PublicCreatedRecipe> verifiedRecipes = [];
  int recipeCount = 0; //varibale for recipe statstics
  int userCount = 0; //variable for user statistics
  int recipesWaiting =
      0; //variable to show if a recipe is waiting to be approved
  int recipesVerified =
      0; //variable to show how many recipes have been verified
  bool loading = true; //variable to display loading icon

  Future<void> getStatistics() async {
    recipeCount = await DatabaseService.countRecipes(); //get recipe count
    userCount = await DatabaseService.countUsers(); //get user count
    createdRecipesVerification = await DatabaseService
        .getCreatedRecipesForVerification(); //get recipes waiting for approval
    recipesWaiting = createdRecipesVerification
        .length; //number of recipes waiting for approval
    verifiedRecipes = await DatabaseService
        .getVerifiedCreatedRecipes(); //get verified recipes
    recipesVerified = verifiedRecipes.length; //get number of verified recipes

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(context),
    );
  }

  RefreshIndicator body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getStatistics(),
      child: loading
          ? loadingIndicator()
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        height: 50,
                        width: 180,
                        child: Center(
                          child: Text(
                            'Total Recipes: $recipeCount',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        height: 50,
                        width: 180,
                        child: Center(
                          child: Text(
                            'Total Users: $userCount',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        height: 50,
                        width: 300,
                        child: Center(
                          child: Text(
                            'Recipes Waiting For Verification: $recipesWaiting',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        height: 50,
                        width: 300,
                        child: Center(
                          child: Text(
                            'Recipes Verified: $recipesVerified',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(255, 244, 4, 4),
                    ),
                    height: 70,
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllRecipesPage(),
                          ),
                        );
                      },
                      child: Text(
                        'View All Recipes',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(255, 244, 4, 4),
                    ),
                    height: 70,
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllUsersPage(),
                          ),
                        );
                      },
                      child: Text(
                        'View All Users',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(255, 244, 4, 4),
                    ),
                    height: 70,
                    width: 180,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ApproveCreatedRecipesPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Created Recipe Approval',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
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
              colors: [Color.fromARGB(255, 244, 4, 4)],
              strokeWidth: 2,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Loading Statistics...',
            style: TextStyle(
                color: Color.fromARGB(255, 244, 4, 4),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey,
      title: Text('Admin Page'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          signOut();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoginPage(),
            ),
          );
        },
        icon: Icon(Icons.logout),
      ),
    );
  }
}
