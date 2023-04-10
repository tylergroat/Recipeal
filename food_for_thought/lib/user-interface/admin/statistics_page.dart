import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/back-end/authentification.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/user-interface/user-functions/login_page.dart';
import 'package:loading_indicator/loading_indicator.dart';

//class to allow admin to apprive user created recipes -- Implemented by : Gavin Fromm

class ViewStatisticsPage extends StatefulWidget {
  @override
  ViewStatisticsPageState createState() => ViewStatisticsPageState();
}

class ViewStatisticsPageState extends State<ViewStatisticsPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  int recipeCount = 0;
  int userCount = 0;
  bool loaded = true;

  Future<void> getStatistics() async {
    recipeCount = await DatabaseService.countRecipes();
    userCount = await DatabaseService.countUsers();
    setState(() {
      loaded = false;
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
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Statistics Page'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: loaded
          ? Center(
              child: SizedBox(
                height: 70,
                width: 70,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: [Color.fromARGB(255, 244, 4, 4)],
                  strokeWidth: 2,
                ),
              ),
            )
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12)),
                    height: 50,
                    width: 200,
                    child: Center(
                      child: Text(
                        'Total Recipes: $recipeCount',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12)),
                    height: 50,
                    width: 200,
                    child: Center(
                      child: Text(
                        'Total Users: $userCount',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
