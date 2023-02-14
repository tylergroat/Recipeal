import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:food_for_thought/forgot_password.dart';
import 'package:food_for_thought/registration_page.dart';
import 'home_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static const enterEmailMessage = SnackBar(
    content: Text('Please enter an email'),
  );
  static const enterPasswordMessage = SnackBar(
    content: Text('Please enter a password'),
  );
  static const userDNEMessage = SnackBar(
    content:
        Text('No user exists with these credentials, please register first'),
  );
  static const emailFormatMessage = SnackBar(
    content: Text('Please enter a valid email'),
  );

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController loginButton =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController registerButton =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //main scaffold
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(3))),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 115, 138, 219),
        title: Text(
          "Recipeal",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 10000,
                height: 0,
              ),
              SizedBox(
                width: 200,
                child: Text(
                  'WELCOME BACK',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      height: 1.0,
                      fontFamily: 'Oswald'),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 10000,
                height: 5,
              ),
              SizedBox(
                width: 200,
                height: 90,
                child: Image.asset('assets/logo/logo.png' //to display the image
                    ),
              ),
              SizedBox(
                width: 10000,
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
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
                //padding: EdgeInsets.symmetric(horizontal: 15),
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
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              RoundedLoadingButton(
                borderRadius: 10,
                animateOnTap: true,
                successColor: Colors.green,
                errorColor: Colors.red,
                resetDuration: Duration(seconds: 2),
                color: Color.fromARGB(255, 115, 138, 219),
                controller: loginButton,
                onPressed: () async {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(enterEmailMessage);
                    loginButton.error();
                    Timer(Duration(seconds: 2), () => loginButton.reset());

                    return;
                  } else if (passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(enterPasswordMessage);
                    loginButton.error();
                    Timer(Duration(seconds: 2), () => loginButton.reset());
                    return;
                  } else {
                    User? user = await signInWithEmailPassword(
                        emailController.text.toString(),
                        passwordController.text.toString());

                    if (user != null) {
                      loginButton.success();
                      print(user);
                      // ignore: use_build_context_synchronously
                      Timer(
                          Duration(seconds: 1),
                          () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => HomePage())));
                    } else {
                      loginButton.error();
                      Timer(Duration(seconds: 2), () => loginButton.reset());

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                          .showSnackBar(userDNEMessage);
                    }
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
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
                  controller: registerButton,
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RegistrationPage()));
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
      ),
    );
  }
}
