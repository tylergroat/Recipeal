import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/login_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'authentification.dart';

class ChangeInfoPage extends StatefulWidget {
  @override
  ChangeInfoPageState createState() => ChangeInfoPageState();
}

class ChangeInfoPageState extends State<ChangeInfoPage> {
  static const creationSuccessful = SnackBar(
    content: Text('Email Updated! Redirecting.....'),
  );

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = TextButton(
      child: Text(
        "Confirm change",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        updateInfoButton.success();
        await user.updateEmail(newEmailController.text.trim());
        updateUserDetails(newEmailController.text.trim(), user.uid);
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

  TextEditingController oldEmailController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final RoundedLoadingButtonController updateInfoButton =
      RoundedLoadingButtonController();
  final user = FirebaseAuth.instance.currentUser!;

  final incorrectEmailMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Incorrect Email',
      message: 'Email entered does not match current user',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );
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

  final emailFormatMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Email Format Incorrect',
      message: 'Please enter a valid email',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

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
          'Update Email',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 100,
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
                controller: oldEmailController,
                //Text Field for username/email
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail),
                    labelText: 'Old Email',
                    hintText: 'example@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: newEmailController,
                //Text Field for username/email
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail),
                    labelText: 'New Email',
                    hintText: 'example@gmail.com'),
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
                borderRadius: 10,
                animateOnTap: false,
                resetDuration: Duration(seconds: 3),
                color: Color.fromARGB(255, 115, 138, 219),
                controller: updateInfoButton,
                onPressed: () async {
                  if (oldEmailController.text.isEmpty ||
                      newEmailController.text.isEmpty ||
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
                  } else if (oldEmailController.text != user.email!) {
                    updateInfoButton.error();
                    Timer(Duration(seconds: 2), () => updateInfoButton.reset());
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(incorrectEmailMessage);
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                  } else if (!newEmailController.text.contains('@')) {
                    updateInfoButton.error();
                    Timer(Duration(seconds: 2), () => updateInfoButton.reset());
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(emailFormatMessage);
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                  } else {
                    User? user = await signInWithEmailPassword(
                        oldEmailController.text.toString(),
                        confirmPasswordController.text.toString());
                    if (user != null) {
                      showAlertDialog(context);
                    } else {
                      updateInfoButton.error();
                      Timer(
                          Duration(seconds: 2), () => updateInfoButton.reset());
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
      ),
    );
  }
}
