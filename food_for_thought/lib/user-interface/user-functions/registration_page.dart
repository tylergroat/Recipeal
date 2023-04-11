import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../back-end/authentification.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
  final weakPasswordMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Weak Password',
      message: 'Password must be at least 6 alphanumberic characters',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );
  final userExistsMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'User exists',
      message: 'A user with this email already exists',

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
  final passwordsDoNotMatchMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Passwords Do Not Match',
      message: 'Please confirn your password',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  static const creationSuccessful = SnackBar(
    content: Text('Account Created! Redirecting.....'),
  );

  @override
  Widget build(BuildContext context) {
    final RoundedLoadingButtonController registerButton =
        RoundedLoadingButtonController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text(
          'Register',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              width: 150,
              height: 150,
              child: Image.asset('assets/logo/2.png' //to display the image
                  ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 0),
              child: TextField(
                controller: firstnameController,
                //Text Field for username/email
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  labelText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 0),
              child: TextField(
                controller: lastnameController,
                //Text Field for username/email
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  labelText: 'Last Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 0),
              child: TextField(
                controller: usernameController,
                //Text Field for username/email
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 0),
              child: TextField(
                controller: emailController,
                //Text Field for username/email
                decoration: InputDecoration(
                    focusColor: Colors.black,
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail),
                    labelText: 'Email',
                    hintText: 'example@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 15, bottom: 0),
              child: TextField(
                controller: passwordController,
                //Text Field for password
                obscureText: true, //to hide text (password field)
                decoration: InputDecoration(
                  focusColor: Colors.black,
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(244, 4, 4, 255))),
                  labelText: 'Password',
                  hintText:
                      'Password must have at least 6 alphanumeric characters',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 15, bottom: 0),
              child: TextField(
                controller: confirmPasswordController,
                //Text Field for password
                obscureText: true, //to hide text (password field)
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText:
                      'Password must have at least 6 alphanumeric characters',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 20, bottom: 30),
              child: RoundedLoadingButton(
                borderRadius: 8,
                width: 250,
                color: Color.fromARGB(255, 244, 4, 4),
                controller: registerButton,
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      firstnameController.text.isEmpty ||
                      lastnameController.text.isEmpty ||
                      usernameController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty ||
                      emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(emptyInputMessage);
                    registerButton.error();
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                    Timer(Duration(seconds: 1), () => registerButton.reset());
                    return;
                  } else if (passwordController.text.length <= 6) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(weakPasswordMessage);
                    registerButton.error();
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                    Timer(Duration(seconds: 1), () => registerButton.reset());
                    return;
                  } else if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(passwordsDoNotMatchMessage);
                    registerButton.error();
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                    Timer(Duration(seconds: 1), () => registerButton.reset());
                    return;
                  } else {
                    User? user = await registerWithEmailPassword(
                        firstnameController.text.trim(),
                        lastnameController.text.trim(),
                        usernameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim());

                    if (user != null) {
                      registerButton.success();
                      Timer(
                          Duration(seconds: 1),
                          () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => LoginPage())));
                      print(user);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(creationSuccessful);
                      // ignore: use_build_context_synchronously
                    } else if (!emailController.text.characters.contains('@')) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentMaterialBanner()
                        ..showMaterialBanner(emailFormatMessage);
                      registerButton.error();
                      Timer(
                          Duration(seconds: 2),
                          () => ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner());
                      registerButton.error();
                      Timer(Duration(seconds: 1), () => registerButton.reset());
                      return;
                    } else {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentMaterialBanner()
                        ..showMaterialBanner(userExistsMessage);
                      registerButton.error();
                      Timer(
                          Duration(seconds: 2),
                          () => ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner());
                      registerButton.error();
                      Timer(Duration(seconds: 1), () => registerButton.reset());
                      return;
                    }
                  }
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
