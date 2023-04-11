///Mixin for Created Recipe functionalities
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
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

  //Gets entire doc of a created recipe
  Future<Map<String, dynamic>> getCreatedRecipeData(
      {required String recipeName}) async {
    try {
      if (user == null) throw Exception("User not logged in");

      final DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
          .collection('created recipes')
          .doc(recipeName)
          .get();

      //if recipe exists, get data
      if (recipeDoc.exists) {
        final Map<String, dynamic> recipeData =
            recipeDoc.data() as Map<String, dynamic>;
        final String imageUrl = recipeData['imageUrl'];
        return {...recipeData, imageUrl: imageUrl};
      }
      //else recipe does not exist throw exception
      else {
        throw Exception("Recipe not found with id: $recipeName");
      }
    } catch (e) {
      throw Exception("Error getting created recipe data: $e");
    }
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
      await documentReference.set({...recipeData});
    } catch (e) {
      throw Exception(
          'Failed to upload the recipe to the public created recipes collection: $e');
    }
  }

//Only needed for cases when a recipe needs to have its image updated
//Not needed when deleting a recipe because the image gets deleted by the deleteRecipeFromFirebase function already
  Future<void> deleteImageFromFirebase({required String recipeName}) async {
    try {
      if (user == null) throw Exception("User not logged in");

      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('created recipes')
          .child(recipeName);

      await firebaseStorageRef.delete();
    } catch (e) {
      throw Exception("Error deleting image from Firebase: $e");
    }
  }

  //Deletes both the recipe and recipe image (in firestore and cloud storage)
  Future<void> deleteRecipeFromFirebase({required String recipeName}) async {
    final String? userId = user?.uid;

    //Check if the recipe exists
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('created recipes')
        .doc(recipeName)
        .delete();

    //Delete the recipe
  }

  //TODO: NEEDS TO BE UPDATED
  //updates the image for the recipe and deletes the old image
  // Future<void> updateImageInFirebase(String recipeName, XFile newImage) async {
  //   try {
  //     final User? user = FirebaseAuth.instance.currentUser;
  //     if (user == null) throw Exception("User not logged in");
  //     final String userId = user.uid;

  //     //Overwrite the image
  //     await uploadImageToFirebase(image: newImage, recipeName: recipeName);

  //     String newImageUrl = await getImageUrl(recipeName);
  //     //update the imageUrl field in the recipes collection in Firebase Firestore
  //     final DocumentReference recipeDocRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('created recipes')
  //         .doc(recipeName);
  //     await recipeDocRef.update({'imageUrl': newImageUrl});
  //   } catch (e) {
  //     throw Exception('Failed to update image in Firebase: $e');
  //   }
  // }
}
