import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HelpPage extends StatelessWidget {
  void _showFeedExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feed Page'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'At the top, you will find a Navbar with a button for the hamburger menu. '),
              SizedBox(height: 10),
              Text(
                  'Below the Navbar, You can find the recipe card, filters, like and dislike buttons. '),
              SizedBox(height: 0),
              Text(
                  'The Recipe card displays ingrediants and instructions for the recipe once clicked upon'),
              SizedBox(height: 0),
              Text('Liked recipes will be saved to users liked recipes page.'),
              SizedBox(height: 10),
              Text(
                  'The Pencil button will take you to a create recipe page where the user can create and upload their own recipes. '),
              SizedBox(height: 0),
              Text('The Page button represents the Feed page.'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 115, 138, 219)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showUserInfoExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Information'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Here the user can change email, username, name and password.'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 115, 138, 219)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLikedRecipesExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Liked Recipes'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'This is a collection of all recipes that were liked by the user. '),
              SizedBox(height: 10),
              Text(
                  'At the top on the navbar, there is a filter and search feature to help you sort and select the recipe you would like to make. '),
              SizedBox(height: 0),
              Text(
                  'Underneath the navbar are your liked recipes. The user can pin the recipes by double clicking on the recipes putting the recipe in the pinned page. The user can also remove recipes from liked recipes by taping and holding on the recipe and clicking confirm.'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 115, 138, 219)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPinnedRecipesExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pinned Recipes'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This is a collection of all recipes that were pinned. '),
              SizedBox(height: 10),
              Text(
                  'At the top on the nav bar, there is a filter and search feature to help you sort and select the recipe you would like to make.'),
              SizedBox(height: 0),
              Text(
                  'Underneath the navbar are your pinned recipes. If you like to remove a recipe from the pinned recipes by taping and holding on the recipe and clicking confirm.'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 115, 138, 219)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showCreatedRecipesExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Created Recipes'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Here the user will find all of your created recipes. '),
              SizedBox(height: 10),
              Text(
                  'At the top on the navbar, there is a filter and search feature to help you sort and select the recipe.'),
              SizedBox(height: 0),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 115, 138, 219)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help Page'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Here the user will be able to find instructions to help guide you through the application.'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 115, 138, 219)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutUsExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Us'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Here the user will find information about the application and its creators.'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 115, 138, 219)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Add similar functions for other pages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Help Page'),
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                        color: Color.fromARGB(255, 115, 138, 219),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: i,
                    );
                  },
                );
              }).toList(),
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
            'Side Menu - Various options are located here, such as the users liked and pinned recipes, and the logout functionality is also located here.',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }
}
