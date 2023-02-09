import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'authentification.dart';
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

  static const enterEmailMessage = SnackBar(
    content: Text('Please enter an email'),
  );
  static const confirmPasswordMessage = SnackBar(
    content: Text('Please confirm your password'),
  );
  static const enterPasswordMessage = SnackBar(
    content: Text('Please enter a password'),
  );
  static const passwordsDoNotMatchMessage = SnackBar(
    content: Text('Passwords must match'),
  );
  static const emailFormatMessage = SnackBar(
    content: Text('Please enter a valid email'),
  );
  static const creationSuccessful = SnackBar(
    content: Text('Account Created! Redirecting.....'),
  );
  static const accountExistsMessage = SnackBar(
    content: Text('Account with this email exists'),
  );
  static const weakPasswordMessage = SnackBar(
    content: Text('Password must be at least 6 alphanumeric characters'),
  );

  @override
  Widget build(BuildContext context) {
    final RoundedLoadingButtonController registerButton =
        RoundedLoadingButtonController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
        ),
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
        title: Text('Register', textAlign: TextAlign.center),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset(
                        'assets/images/tomato.png' //to display the image
                        )),
              ),
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
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 20, bottom: 30),
              child: RoundedLoadingButton(
                borderRadius: 8,
                color: Color.fromARGB(255, 115, 138, 219),
                controller: registerButton,
                onPressed: () async {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(enterEmailMessage);
                    registerButton.error();
                    Timer(Duration(seconds: 1), () => registerButton.reset());
                    return;
                  } else if (passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(enterPasswordMessage);
                    registerButton.error();
                    Timer(Duration(seconds: 1), () => registerButton.reset());
                    return;
                  } else if (confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(confirmPasswordMessage);
                    registerButton.error();
                    Timer(Duration(seconds: 1), () => registerButton.reset());
                    return;
                  } else if (passwordController.text.length <= 6) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(weakPasswordMessage);
                    registerButton.error();
                    Timer(Duration(seconds: 1), () => registerButton.reset());
                    return;
                  } else if (passwordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(passwordsDoNotMatchMessage);
                    registerButton.error();
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
                          .showSnackBar(emailFormatMessage);
                      registerButton.error();
                      Timer(Duration(seconds: 1), () => registerButton.reset());
                      return;
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(accountExistsMessage);
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
          ],
        ),
      ),
    );
  }
}
