///Mixin for Created Recipe functionalities
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin CreatedRecipe {
  Future<Map<String, dynamic>> getCreatedRecipeData(
      {required String recipeId}) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final String userId = user.uid;
      final DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
          .collection('created recipes')
          .doc(recipeId)
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
        throw Exception("Recipe not found with id: $recipeId");
      }
    } catch (e) {
      throw Exception("Error getting created recipe data: $e");
    }
  }

  Future<String> getCreatedRecipeName(String recipeId) async {
    // Get the recipe document from Firebase using the recipeId
    DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
        .collection('created recipes')
        .doc(recipeId)
        .get();

    // Extract the recipeName field from the retrieved document
    String recipeName = recipeDoc.get('recipeName');

    return recipeName;
  }

  Future<String> uploadImageToFirebase(
      {required File image, required String recipeName}) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('created recipes')
          .child(recipeName);

      final UploadTask uploadTask = firebaseStorageRef.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      throw Exception("Error uploading image to Firebase: $e");
    }
  }

  //updates the image for the recipe and deletes the old image
  Future<void> updateImageInFirebase(
      String recipeId, String oldImageUrl, File newImage) async {
    try {
      String recipeName = getCreatedRecipeName(recipeId) as String;
      final String newImageUrl =
          await uploadImageToFirebase(image: newImage, recipeName: recipeName);

      //delete the old image from Firebase Storage
      await deleteImageFromFirebase(imageUrl: oldImageUrl);

      //update the imageUrl field in the recipes collection in Firebase Firestore
      final DocumentReference recipeDocRef =
          FirebaseFirestore.instance.collection('recipes').doc(recipeId);
      await recipeDocRef.update({'imageUrl': newImageUrl});
    } catch (e) {
      throw Exception('Failed to update image in Firebase: $e');
    }
  }

//to call this:
// final documentReference = await uploadRecipeToFirebase(
//   recipeData: recipeData,
//   imageUrl: imageUrl,
// );
  Future<DocumentReference> uploadRecipeToFirebase(
      {required Map<String, dynamic> recipeData,
      required String imageUrl}) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final String userId = user.uid;
      final CollectionReference createdRecipesCollection =
          FirebaseFirestore.instance.collection('created recipes');
      final DocumentReference documentReference = await createdRecipesCollection
          .add({...recipeData, imageUrl: imageUrl, userId: userId});

      return documentReference;
    } catch (e) {
      throw Exception('Failed to upload recipe to Firebase: $e');
    }
  }

//only needed for cases when a recipe needs to have its image updated
//not needed when deleting a recipe because the image gets deleted by the deleteRecipeFromFirebase function already
  Future<void> deleteImageFromFirebase({required String imageUrl}) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final String userId = user.uid;
      final String fileName = Path.basename(imageUrl);
      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('$userId/$fileName');

      await firebaseStorageRef.delete();
    } catch (e) {
      throw Exception("Error deleting image from Firebase: $e");
    }
  }

  //
  Future<void> deleteRecipeFromFirebase({required String documentId}) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final String userId = user.uid;
      final DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('created recipes')
          .doc(documentId)
          .get();

      if (!recipeDoc.exists) {
        throw Exception('Recipe not found');
      }

      final Map<String, dynamic> data =
          recipeDoc.data() as Map<String, dynamic>;
      final String imageUrl = data['imageUrl'];

      if (imageUrl.isNotEmpty) {
        final String fileName = imageUrl.split('/').last;
        final Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('created recipes/$fileName');
        await firebaseStorageRef.delete();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('created recipes')
          .doc(documentId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete recipe from Firebase: $e');
    }
  }

  Future<String> getImageUrl(String recipeId) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final String userId = user.uid;
      final DocumentSnapshot recipeDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('recipes')
          .doc(recipeId)
          .get();

      final Map<String, dynamic> data =
          recipeDoc.data() as Map<String, dynamic>;
      final String imageUrl = data["imageUrl"] as String;
      return imageUrl;
    } catch (e) {
      throw Exception("Error getting image URL: $e");
    }
  }
}
