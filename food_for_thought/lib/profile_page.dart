import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/change_email.dart';
import 'package:food_for_thought/database.dart';
import 'package:food_for_thought/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'change_name.dart';
import 'change_password.dart';
import 'change_username.dart';

//class to define how the profile information is presented to the user -- Implemented by : Gavin Fromm

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  String profilePicLink = " ";
  late String userId = uid.toString();
  UserInformation? userInformation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    userInformation = await DatabaseService.getUser(uid);
    setState(() {
      _isLoading = false;
    });
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
/////////  APP BAR  //////////////
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        backgroundColor: Color.fromARGB(255, 244, 4, 4),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text(
          'User Information',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
/////////  APP BAR  //////////////
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    ////
///////////////////////  PROFILE PHOTO  /////////////////////////
                    GestureDetector(
                      onTap: () {
                        setProfilePhoto();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 12),
                        height: 120,
                        width: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
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
///////////////////////  PROFILE PHOTO  /////////////////////////

                    SizedBox(
                      height: 10,
                    ),
                    ///////////////////////  DISPLAY NAME //////////////////////

                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 4, 4),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        height: 130,
                        width: 300,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${userInformation?.firstName} ${userInformation?.lastName}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Username: @${userInformation?.userName}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Email: ${user.email!}',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 151, 151, 151),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          width: 160,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChangeEmailPage()));
                            },
                            child: Text(
                              'Change Email',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 151, 151, 151),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          width: 160,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChangeUsernamePage()));
                            },
                            child: Text(
                              'Change Username',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 151, 151, 151),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          width: 160,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChangeNamePage()));
                            },
                            child: Text(
                              'Change Name',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 151, 151, 151),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          width: 160,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChangePasswordPage()));
                            },
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
