import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/user-interface/user-functions/login_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../back-end/authentification.dart';

//UI screen for updating user emails

class ChangeUsernamePage extends StatefulWidget {
  @override
  ChangeUsernamePageState createState() => ChangeUsernamePageState();
}

class ChangeUsernamePageState extends State<ChangeUsernamePage> {
  static const creationSuccessful = SnackBar(
    content: Text('Username Updated! Redirecting.....'),
  );

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      style:
          TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 244, 4, 4)),
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = TextButton(
      style:
          TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 244, 4, 4)),
      child: Text(
        "Confirm change",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        updateInfoButton.success();
        updateUsername(newUsernameController.text.trim(), user.uid);
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
        signOut();
        ScaffoldMessenger.of(context).showSnackBar(creationSuccessful);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("You will be logged out after performing this action."),
      actions: [cancelButton, confirmButton],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextEditingController newUsernameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final RoundedLoadingButtonController updateInfoButton =
      RoundedLoadingButtonController();
  final user = FirebaseAuth.instance.currentUser!;
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  final incorrectPasswordMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Incorrect Password',
      message: 'password entered does not match current user',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  final emptyInputMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please fill in all inputs',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(context),
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          SizedBox(
            height: 150,
          ),
          SizedBox(
              width: 200,
              height: 90,
              child: Icon(
                Icons.person,
                size: 70,
              ) //to display the image
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: newUsernameController,
              //Text Field for username/email
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.verified_user),
                labelText: 'New Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: confirmPasswordController,
              //Text Field for username/email
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.lock),
                  labelText: 'Confirm Password',
                  hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 10, bottom: 0),
            child: RoundedLoadingButton(
              borderRadius: 8,
              width: 250,
              animateOnTap: false,
              resetDuration: Duration(seconds: 3),
              color: Color.fromARGB(255, 244, 4, 4),
              controller: updateInfoButton,
              onPressed: () async {
                if (newUsernameController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  updateInfoButton.error();
                  Timer(Duration(seconds: 1), () => updateInfoButton.reset());
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                    ..hideCurrentMaterialBanner()
                    ..showMaterialBanner(emptyInputMessage);
                  Timer(
                      Duration(seconds: 2),
                      () => ScaffoldMessenger.of(context)
                          .hideCurrentMaterialBanner());
                } else {
                  User? user = await signInWithEmailPassword(
                      userEmail.toString(),
                      confirmPasswordController.text.toString());
                  if (user != null) {
                    // ignore: use_build_context_synchronously
                    showAlertDialog(context);
                  } else {
                    updateInfoButton.error();
                    Timer(Duration(seconds: 2), () => updateInfoButton.reset());
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(incorrectPasswordMessage);
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                  }
                }
              },
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
      backgroundColor: Color.fromARGB(255, 244, 4, 4),
      toolbarHeight: 40,
      centerTitle: true,
      title: Text(
        'Update Username',
        style:
            TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
      ),
      automaticallyImplyLeading: true,
    );
  }
}
