import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

String? uid;
String? userEmail;

//registers user to firebase auth

Future<User?> registerWithEmailPassword(String firstName, String lastName,
    String userName, String email, String password) async {
  // Initialize Firebase
  await Firebase.initializeApp();
  User? user;
  // try to create user with user inputs

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
      await user.updateDisplayName(userName);
//creates user document in the Firestore database
      addUserDetails(firstName, lastName, userName, email);

      print('Successfully Registered');
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('An account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
  return user;
}

Future addUserDetails(
    String firstName, String lastName, String userName, String email) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'first name': firstName,
    'last name': lastName,
    'user name': userName,
    'email': email,
    'uid': uid
  });
}

//method for updating user email

Future updateUserEmail(String email, String uid) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'email': email,
  });
}

Future updateUsername(String uname, String uid) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'user name': uname,
  });
}

Future updateName(String fName, String lName, String uid) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'first name': fName,
    'last name': lName,
  });
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  //method for handling log in functionality
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);

      print('Successful Login');
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided.');
    }
  }
  return user;
}

//method to handle sign out functionality

Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  userEmail = null;

  return 'User signed out';
}
