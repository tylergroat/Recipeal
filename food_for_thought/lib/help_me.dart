import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  void _showFeedExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feed Page Explanation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'At the top, you will find a Navbar with a button for the hamburger menu. '),
              SizedBox(height: 20),
              Text(
                  'Below the Navbar, You can find the recipe card, filters, like and dislike buttons. '),
              SizedBox(height: 0),
              Text(
                  'The Recipe card displays ingrediants and instructions for the recipe once clicked upon'),
              SizedBox(height: 0),
              Text('Liked recipes will be saved to users liked recipes page.'),
              SizedBox(height: 20),
              Text(
                  'The Pencil button will take you to a create recipe page where the user can create and upload their own recipes. '),
              SizedBox(height: 0),
              Text('The Page button represents the Feed page.'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            ElevatedButton(
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
          title: Text('User Information Explanation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Here the user can change email, username, name and password.'),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            ElevatedButton(
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
          title: Text('Liked Recipes Explanation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'This is a collection of all recipes that were liked by the user. '),
              SizedBox(height: 20),
              Text(
                  'At the top on the navbar, there is a filter and search feature to help you sort and select the recipe you would like to make. '),
              SizedBox(height: 0),
              Text(
                  'Underneath the navbar are your liked recipes. The user can pin the recipes by double clicking on the recipes putting the recipe in the pinned page. The user can also remove recipes from liked recipes by taping and holding on the recipe and clicking confirm.'),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            ElevatedButton(
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
          title: Text('Pinned Recipes Explanation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This is a collection of all recipes that were pinned. '),
              SizedBox(height: 20),
              Text(
                  'At the top on the nav bar, there is a filter and search feature to help you sort and select the recipe you would like to make.'),
              SizedBox(height: 0),
              Text(
                  'Underneath the navbar are your pinned recipes. If you like to remove a recipe from the pinned recipes by taping and holding on the recipe and clicking confirm.'),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            ElevatedButton(
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
          title: Text('Created Recipes Explanation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Here the user will find all of your created recipes. '),
              SizedBox(height: 20),
              Text(
                  'At the top on the navbar, there is a filter and search feature to help you sort and select the recipe.'),
              SizedBox(height: 0),
            ],
          ),
          actions: [
            ElevatedButton(
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
          title: Text('Help Page Explanation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Here the user will be able to find instructions to help guide you through the application.'),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            ElevatedButton(
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
          title: Text('About Us Explanation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Here the user will find information about the application and its creators.'),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            ElevatedButton(
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
            Text(
              'Welcome to the Help Page!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showFeedExplanation(context);
              },
              child: Text('Feed Page'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 115, 138, 219),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showUserInfoExplanation(context);
              },
              child: Text('User Information Page'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 115, 138, 219),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showLikedRecipesExplanation(context);
              },
              child: Text('Liked Recipes Page'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 115, 138, 219),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showPinnedRecipesExplanation(context);
              },
              child: Text('Pinned Recipes Page'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 115, 138, 219),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showCreatedRecipesExplanation(context);
              },
              child: Text('Created Recipes Page'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 115, 138, 219),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showHelpExplanation(context);
              },
              child: Text('Help Page'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 115, 138, 219),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showAboutUsExplanation(context);
              },
              child: Text('About Us Page'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 115, 138, 219),
                onPrimary: Colors.white,
              ),
            ),
            // Add similar buttons for other pages
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
