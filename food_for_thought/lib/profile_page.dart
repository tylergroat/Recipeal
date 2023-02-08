import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/read%20data/get_user_name.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
                'Signed in as:  ${user.email!}',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
