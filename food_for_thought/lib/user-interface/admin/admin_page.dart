import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:food_for_thought/back-end/authentification.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/user-interface/admin/all_recipes_page.dart';
import 'package:food_for_thought/user-interface/admin/created_recipes_approval.dart';
import 'package:food_for_thought/user-interface/admin/statistics_page.dart';
import 'package:food_for_thought/user-interface/home_page.dart';
import 'package:food_for_thought/user-interface/user-functions/login_page.dart';

//class to allow admin to apprive user created recipes -- Implemented by : Gavin Fromm

class AdminPage extends StatefulWidget {
  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Center(
        child: Column(
          children: [
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
                      builder: (_) => ViewStatisticsPage(),
                    ),
                  );
                },
                child: Text(
                  'View Statistics',
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
              height: 30,
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
}
