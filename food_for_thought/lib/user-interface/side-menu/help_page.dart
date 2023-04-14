import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


// Help page implemented by : Jaideep Chunduri
class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        backgroundColor: Color.fromARGB(255, 244, 4, 4),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text(
          'Help',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 20,
            ),
            CarouselSlider(
              options: CarouselOptions(height: 400.0),
              items: [
                feedPage(context),
                likedRecipes(context),
                pinnedRecipes(context),
                createdRecipes(context),
                userInformation(context),
                recommendedRecipes(context)
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 83, 83, 83),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: i,
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Container feedPage(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            Text(
              'Feed Page',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            SizedBox(height: 15),
            Icon(
              Icons.feed,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 15),
            Text(
              'This is the main page of our application. \n\nHere, you will be greeted with varying types of recipes. Liking the recipe will add it to your liked recipes, and disliking it will simply remove it from your feed.\n\nThe filter option will allow you to find recipes specific to the chosen filter.\n\nTo view more information about the recipe, simply press the recipe card.',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
  }

  Container pinnedRecipes(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Pinned Recipes',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          Icon(
            Icons.push_pin,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 15),
          Text(
            'Here, you can find all of the recipes that you have pinned. This is meant to house your favorite recipes!\n\nTo delete a recipe from your pinned recipes, press and hold the recipe and select "delete".\n\nFiltering and searching functionality is located at the top of this page.',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  Container likedRecipes(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Liked Recipes',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          Icon(
            Icons.favorite,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 15),
          Text(
            'Here, you can find all of the recipes that you have liked.\n\nTo delete a recipe from your liked recipes, press and hold the recipe press and hold the recipe and select "delete". To add a liked recipe to your pinned recipes, double tap the recipe, and select "confirm".\n\nFiltering and searching functionality is located at the top of this page.',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  Container createdRecipes(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Created Recipes',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          Icon(
            Icons.create,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 15),
          Text(
            'Here you will find all of the recipes you have created. These are for personal use only. \n\nThis is meant to be used as a personal, virtual cookbook.',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  Container recommendedRecipes(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Recommended Recipes',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          Icon(
            Icons.recommend,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 15),
          Text(
            'Here you will find recipes that are suggsted to you based on your liked recipes. \n\nThis page is available via the navigation bar as the third option. To add one of these recipes to your liked recipes, simply double click it, and select "confirm".',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  Container userInformation(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Miscellaneous',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          Icon(
            Icons.miscellaneous_services,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 15),
          Text(
            'User Details - Here the user can view and update their account details.',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Divider(
            color: Colors.white,
            thickness: 2,
          ),
          SizedBox(height: 5),
          Text(
            'Navigation Bar - Allows for quick access to the three most important functions of our app: Recipe Creation, the Feed Page, and Recipe Recommendations.',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Divider(
            color: Colors.white,
            thickness: 2,
          ),
          SizedBox(height: 5),
          Text(
            'Side Menu - Various options are located here, such as the users liked and pinned recipes, as well as the logout functionality.',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }
}
