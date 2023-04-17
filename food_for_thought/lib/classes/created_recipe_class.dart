///Mixin for Created Recipe functionalities
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatedRecipe {
  final String name;
  final String servings;
  final List<dynamic> ingredients;
  final String cookInstructions;
  final String image;
  final String totalTime;

  CreatedRecipe(
      {required this.name,
      required this.servings,
      required this.ingredients,
      required this.cookInstructions,
      required this.image,
      required this.totalTime});

  factory CreatedRecipe.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CreatedRecipe(
        name: data?['title'],
        servings: data?['servings'],
        ingredients: data?['ingredients'],
        cookInstructions: data?['cookInstructions'],
        image: data?['thumbnailUrl'],
        totalTime: data?['cookTime']);
  }
}

mixin CreatedRecipeMixin {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final User? user = FirebaseAuth.instance.currentUser;

//check if a recipe exists in the public collection
  Future<bool> publicVerifiedRecipeExists(
      String recipeName, String userId) async {
    bool exists = false;
    final CollectionReference publicCreatedRecipesCollection =
        FirebaseFirestore.instance.collection('verified-created-recipes');

    // Query for the recipe with the given name and userId
    final QuerySnapshot<Object?> snapshot = await publicCreatedRecipesCollection
        .where('title', isEqualTo: recipeName)
        .where('userId', isEqualTo: userId)
        .get();

    // returns true if it exists, false if it doesn't
    if (snapshot.docs.isNotEmpty) {
      exists = true;
    } else {
      exists = false;
    }
    return exists;
  }

//Gets url of image in cloud storage
  Future<String> getImageUrl(String recipeName) async {
    try {
      if (user == null) throw Exception("User not logged in");

      final String userId = user!.uid;
      final DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('created recipes')
          .doc(recipeName)
          .get();

      final Map<String, dynamic> data =
          recipeDoc.data() as Map<String, dynamic>;
      final String imageUrl = data["imageUrl"] as String;
      return imageUrl;
    } catch (e) {
      throw Exception("Error getting image URL: $e");
    }
  }

  Future<String> uploadImageToFirebase({
    required XFile? image,
    required String recipeName,
  }) async {
    try {
      if (user == null) throw Exception("User not logged in");

      final Reference firebaseStorageRef =
          storage.ref().child('created recipes').child(recipeName);

      // Uploading with the following line
      if (image != null) {
        final File file = File(image.path);
        await firebaseStorageRef.putFile(file);
        final String downloadUrl = await firebaseStorageRef.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception("Image file is null");
      }
    } catch (e) {
      throw Exception("Error uploading image to Firebase: $e");
    }
  }

//Uploads recipe data in firestore
  Future<void> uploadRecipeToFirebase(
      {required Map<String, dynamic> recipeData, required String name}) async {
    try {
      if (user == null) throw Exception("User not logged in");

      final String userId = user!.uid;
      final CollectionReference createdRecipesCollection = FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .collection('created recipes');
      final DocumentReference documentReference =
          createdRecipesCollection.doc(name);
      await documentReference.set({...recipeData});
    } catch (e) {
      throw Exception(
          'Failed to upload the recipe to user: "$user"\'s created recipes collection: $e');
    }
  }

  Future<void> uploadPublicRecipeToFirebase(
      {required Map<String, dynamic> recipeData, required String name}) async {
    try {
      if (user == null) throw Exception("User not logged in");

      final CollectionReference publicCreatedRecipesCollection =
          FirebaseFirestore.instance.collection('created recipes');
      final DocumentReference documentReference =
          publicCreatedRecipesCollection.doc(name);
      // Add the userId field to the recipeData Map
      recipeData['userId'] = user!.uid;

      await documentReference.set({...recipeData});
    } catch (e) {
      throw Exception(
          'Failed to upload the recipe to the public created recipes collection: $e');
    }
  }

//deletes the image by its downloadUrl
  Future<void> deleteImageFromFirebaseByUrl(String downloadUrl) async {
    try {
      // Get the reference to the storage object using the download URL
      final storageReference = FirebaseStorage.instance.refFromURL(downloadUrl);
      // Deletes the storage object (the image)
      await storageReference.delete();
    } catch (e) {
      throw Exception('Failed to delete image from Firebase Cloud Storage: $e');
    }
  }

//Use this only for deleting recipes that are inside the user's personal collection
//deletes only the given recipe from the user's private collection in firestore, does not delete the image or delete the recipe in any other location
  Future<void> deletePrivateRecipeFromFirebase(
      {required String recipeName}) async {
    final String? userId = user?.uid;
    //Check if the recipe exists and delete the recipe
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('created recipes')
        .doc(recipeName)
        .delete();
  }

//use this for recipes that are in the public collection that are not yet verified
  Future<void> deletePublicUnverifiedRecipeFromFirebase(
      String recipeName, String userId) async {
    try {
      final CollectionReference publicCreatedRecipesCollection =
          FirebaseFirestore.instance.collection('created recipes');

      // Query for the recipe with the given name and userId
      final QuerySnapshot<Object?> snapshot =
          await publicCreatedRecipesCollection
              .where('title', isEqualTo: recipeName)
              .where('userId', isEqualTo: userId)
              .get();

      // Delete the recipe if it exists
      if (snapshot.docs.isNotEmpty) {
        final DocumentReference documentReference =
            snapshot.docs.first.reference;
        await documentReference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete the recipe: $e');
    }
  }

//use this for recipes that are in the public collection that have been verified
  Future<void> deletePublicVerifiedRecipeFromFirebase(
      String recipeName, String userId) async {
    try {
      final CollectionReference publicCreatedRecipesCollection =
          FirebaseFirestore.instance.collection('verified-created-recipes');

      // Query for the recipe with the given name and userId
      final QuerySnapshot<Object?> snapshot =
          await publicCreatedRecipesCollection
              .where('title', isEqualTo: recipeName)
              .where('userId', isEqualTo: userId)
              .get();

      // Delete the recipe if it exists
      if (snapshot.docs.isNotEmpty) {
        final DocumentReference documentReference =
            snapshot.docs.first.reference;
        await documentReference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete the recipe: $e');
    }
  }
}
