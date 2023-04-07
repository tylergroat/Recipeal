import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/admin.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:food_for_thought/forgot_password.dart';
import 'package:food_for_thought/registration_page.dart';
import 'home_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isHidden = true;

  final enterEmailMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please enter an email!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  final userDNEMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'User not found',
      message: 'Please register first!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  final enterPasswordMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please enter a password!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  final invalidEmailMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Invalid Input',
      message: 'Please enter a valid email!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController loginButton =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController registerButton =
      RoundedLoadingButtonController();

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //main scaffold
      appBar: AppBar(
        toolbarHeight: 20,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 250,
                height: 250,
                child: Image.asset('assets/logo/1.png' //to display the image
                    ),
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
                  obscureText: isHidden, //to hide text (password field)
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText:
                        'Password must have at least 6 alphanumeric characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.visibility,
                      ),
                      onPressed: () {
                        print(isHidden);
                        togglePasswordView();
                        setState(
                          () {
                            isHidden;
                          },
                        );
                      },
                    ),
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
                width: 250,
                borderRadius: 8,
                animateOnTap: true,
                successColor: Colors.green,
                errorColor: Colors.red,
                resetDuration: Duration(seconds: 2),
                color: Color.fromARGB(255, 244, 4, 4),
                controller: loginButton,
                onPressed: () async {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(enterEmailMessage);
                    loginButton.error();
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                    Timer(Duration(seconds: 1), () => loginButton.reset());

                    return;
                  } else if (passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(enterPasswordMessage);
                    loginButton.error();
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                    loginButton.error();
                    Timer(Duration(seconds: 2), () => loginButton.reset());
                    return;
                  } else {
                    User? user = await signInWithEmailPassword(
                        emailController.text.toString(),
                        passwordController.text.toString());

                    if (user != null) {
                      if (user.email == 'admin@admin.com') {
                        loginButton.success();
                        Timer(
                          Duration(seconds: 1),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminPage(),
                            ),
                          ),
                        );
                        return;
                      }

                      loginButton.success();
                      print(user);
                      // ignore: use_build_context_synchronously
                      Timer(
                          Duration(seconds: 1),
                          () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => HomePage())));
                    } else if (!emailController.text.contains('@')) {
                      loginButton.error();
                      Timer(Duration(seconds: 1), () => loginButton.reset());
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                        ..hideCurrentMaterialBanner()
                        ..showMaterialBanner(invalidEmailMessage);
                      Timer(
                          Duration(seconds: 2),
                          () => ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner());
                    } else {
                      loginButton.error();
                      Timer(Duration(seconds: 1), () => loginButton.reset());
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                        ..hideCurrentMaterialBanner()
                        ..showMaterialBanner(userDNEMessage);
                      Timer(
                          Duration(seconds: 2),
                          () => ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner());
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
                  width: 250,
                  borderRadius: 8,
                  animateOnTap: false,
                  resetDuration: Duration(seconds: 3),
                  color: Color.fromARGB(255, 244, 4, 4),
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
