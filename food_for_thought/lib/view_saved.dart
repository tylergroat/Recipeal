import 'package:flutter/material.dart';

class ViewSavedRecipesPage extends StatefulWidget {
  @override
  ViewSavedRecipesPageState createState() => ViewSavedRecipesPageState();
}

class ViewSavedRecipesPageState extends State<ViewSavedRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
          backgroundColor: Color.fromARGB(255, 115, 138, 219),
          toolbarHeight: 40,
          centerTitle: true,
          title: Text(
            'Saved Recipes',
            style: TextStyle(
                color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
          ),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      leading: Icon(Icons.food_bank),
                      title: Text('Recipe 1'),
                      onTap: () => {Navigator.of(context).pop()},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      leading: Icon(Icons.food_bank),
                      title: Text('Recipe 2'),
                      onTap: () => {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      leading: Icon(Icons.food_bank),
                      title: Text('Recipe 3'),
                      onTap: () => {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      leading: Icon(Icons.food_bank),
                      title: Text('Recipe 4'),
                      onTap: () => {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      leading: Icon(Icons.food_bank),
                      title: Text('Recipe 5'),
                      onTap: () => {},
                    ),
                  ),
                ],
              ),
            ],
          )),
        ));
  }
}
