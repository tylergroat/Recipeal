import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:food_for_thought/feed_page.dart';
import 'package:food_for_thought/login_page.dart';
import 'package:food_for_thought/profile_page.dart';
import 'package:food_for_thought/recipecreation_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final screens = [
    RecipeCreation(),
    FeedPage(),
    ProfilePage(),
  ];

  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(3))),
        leading: IconButton(
          onPressed: () {
            /////////////////////   SETTINGS PAGE ????? /////////////
          },
          icon: Icon(Icons.settings),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(logOutMessage);

                signOut();
                print('User Logged Out');
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
        centerTitle: true,
        title: const Text(
          'Food for Thought',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.white),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
