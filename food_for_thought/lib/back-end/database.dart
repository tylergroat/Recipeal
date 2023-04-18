import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_for_thought/classes/recipe_class.dart';
import 'package:food_for_thought/classes/user_class.dart';
import '../classes/created_recipe_class.dart';
import '../classes/public_created_recipe_class.dart';

//class to define database operations involivng recipes -- Implemented by : Gavin Fromm

class DatabaseService {
  //get users recipe based on path given
  static Future<List<Recipe>> getRecipes(String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .get(); //get collection based on path

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes; //return list of recipes
  }

  //get recipes created by the user that are public
  static Future<List<PublicCreatedRecipe>> getPublicCreatedRecipes(
      String uid, String path) async {
    late List<PublicCreatedRecipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(PublicCreatedRecipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //get all recipes stored in the system
  static Future<List<Recipe>> getStoredRecipes() async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance.collection("recipes").get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //get recipes for recommending given filter
  static Future<List<Recipe>> getAllRecipes(String filter) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("recipes")
        .where(filter, isEqualTo: true)
        .where('isPopular', isEqualTo: true)
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //get a users created recipe
  static Future<List<CreatedRecipe>> getCreatedRecipes(String uid) async {
    late List<CreatedRecipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('created recipes')
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(CreatedRecipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

//returns all created recipes that have not yet been verified
  static Future<List<PublicCreatedRecipe>>
      getCreatedRecipesForVerification() async {
    late List<PublicCreatedRecipe> recipes = [];
    final docs = FirebaseFirestore.instance.collection("created recipes").get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(PublicCreatedRecipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

//returns all verified created recipes
  static Future<List<PublicCreatedRecipe>> getVerifiedCreatedRecipes() async {
    late List<PublicCreatedRecipe> recipes = [];
    final docs =
        FirebaseFirestore.instance.collection("verified-created-recipes").get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(PublicCreatedRecipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  // //returns a specific user's verified created recipes
  static Future<List<PublicCreatedRecipe>> getMyVerifiedCreatedRecipes(
      String userId) async {
    late List<PublicCreatedRecipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("verified-created-recipes")
        .where("userId", isEqualTo: userId)
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(PublicCreatedRecipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //returns a specific user's public created recipes that have not yet been verified
  static Future<List<PublicCreatedRecipe>> getMyCreatedRecipesForVerification(
      String userId) async {
    late List<PublicCreatedRecipe> recipes = [];
    final docs = await FirebaseFirestore.instance
        .collection("created recipes")
        .where("userId", isEqualTo: userId)
        .get();

    print('Number of docs returned: ${docs.docs.length}');

    for (var docSnapshot in docs.docs) {
      print('Adding recipe: ${docSnapshot.data()}');
      recipes.add(PublicCreatedRecipe.fromFirestore(docSnapshot));
    }

    print('Number of recipes added: ${recipes.length}');

    return recipes;
  }

  //sort recipes in aplhpabetical order
  static Future<List<Recipe>> sortByAlpha(String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('title')
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //sort recipes in reverse aplhpabetical order

  static Future<List<Recipe>> sortByAlphaDescending(
      String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('title', descending: true)
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //sort recipes by shortest time cook

  static Future<List<Recipe>> sortByTime(String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('cookTime')
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //sort recipes by longest time cook

  static Future<List<Recipe>> sortByTimeDescending(
      String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('cookTime', descending: true)
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //sort recipes by servings
  static Future<List<Recipe>> sortByServings(String uid, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .orderBy('servings')
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  //method to handle recipe filtering

  static Future<List<Recipe>> filterBy(
      String uid, String path, String filter) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .where(filter, isEqualTo: true)
        .get();

    await docs.then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return recipes;
  }

  /// method for searching recipes
  static Future<List<Recipe>> searchRecipes(
      String uid, String search, String path) async {
    late List<Recipe> recipes = [];
    final docs = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection(path)
        .where('title', isGreaterThanOrEqualTo: search)
        .where('title', isLessThanOrEqualTo: '$search\uf8ff');

    await docs.get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          recipes.add(Recipe.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    print(recipes);
    return recipes;
  }

  //get user based on uid

  static Future<UserInformation> getUser(String uid) async {
    late UserInformation user;
    final doc = FirebaseFirestore.instance.collection("users").doc(uid).get();

    await doc.then((querySnapshot) {
      user = UserInformation.fromFirestore(querySnapshot);
    });
    return user;
  }

  //get users name from uid
  static Future<String> getUsersName(String uid) async {
    late UserInformation user;
    String name = '';
    final doc = FirebaseFirestore.instance.collection("users").doc(uid).get();

    await doc.then((querySnapshot) {
      user = UserInformation.fromFirestore(querySnapshot);
      name = user.firstName;
    });
    print(name);
    return name;
  }

  //mehtod to get all users
  static Future<List<UserInformation>> getAllUsers() async {
    late List<UserInformation> users = [];
    final doc = FirebaseFirestore.instance.collection("users").get();

    await doc.then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        users.add(UserInformation.fromFirestore(docSnapshot));
      }
    });
    return users;
  }

  //method to get number of users
  static Future<int> countUsers() async {
    late int count = 0;
    late List<UserInformation> users = [];

    final doc = FirebaseFirestore.instance.collection("users").get();

    await doc.then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        users.add(UserInformation.fromFirestore(docSnapshot));
      }
      count = users.length;
    });
    return count;
  }

  //method to get number of recipes

  static Future<int> countRecipes() async {
    late int count = 0;
    late List<Recipe> recipes = [];

    final doc = FirebaseFirestore.instance.collection("recipes").get();

    await doc.then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        recipes.add(Recipe.fromFirestore(docSnapshot));
      }
      count = recipes.length;
    });
    return count;
  }
}
