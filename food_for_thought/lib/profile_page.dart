import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:food_for_thought/read%20data/get_user_name.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();
  String profilePicLink = " ";

  Future<void> getUserDetails() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {});
  }

  void setProfilePhoto() async {
    final profilePhoto = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 90);

    Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");

    await ref.putFile(File(profilePhoto!.path));
    ref.getDownloadURL().then((value) => {
          print(value),
          setState(() {
            profilePicLink = value;
          })
        });
  }

  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 35,
        centerTitle: true,
        title: Text(
          'Profile Page',
          style: TextStyle(color: Colors.red),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setProfilePhoto();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 24),
                  height: 120,
                  width: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: profilePicLink == " "
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 70,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(profilePicLink),
                          ),
                  ),
                ),
              ),
              Text(
                'Email:  ${user.email!}',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getUserDetails(),
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: 1000,
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Center(
                                child: GetUserName(documentID: user.uid)),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 10, bottom: 0),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'View Saved Recipes',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 10, bottom: 0),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'View Created Recipes',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 10, bottom: 0),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginPage()));
                      ScaffoldMessenger.of(context).showSnackBar(logOutMessage);
                    },
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
