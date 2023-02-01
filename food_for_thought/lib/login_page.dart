import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/authentification.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //main scaffold
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Login Page - Food for Thought"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: emailController,
                //Text Field for username/email
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText:
                        'Password must contain between 8-16 alphanumeric characters'),
              ),
            ),

            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  if (emailController.text.isEmpty) {
                    print('Please enter an email');
                    return;
                  } else if (passwordController.text.isEmpty) {
                    print("Please enter a password");
                    return;
                  } else {
                    User? user = await signInWithEmailPassword(
                        emailController.text.toString(),
                        passwordController.text.toString());
                    print(user);
                    if (user != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomePage()));
                    }
                  }
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
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
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      print('Please enter an email');
                      return;
                    } else if (passwordController.text.isEmpty) {
                      print("Please enter a password");
                      return;
                    } else {
                      User? user = await registerWithEmailPassword(
                          emailController.text.toString(),
                          passwordController.text.toString());
                      print(user);
                      if (user != null) {
                        // ignore: use_build_context_synchronously
                        print('Successfully Registered');
                      }
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),

            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //       color: Colors.red, borderRadius: BorderRadius.circular(20)),
            //   child: TextButton(
            //     onPressed: () {
            //       registerWithEmailPassword(emailController.text.toString(),
            //           passwordController.text.toString());
            //       // Navigator.push(
            //       //     context, MaterialPageRoute(builder: (_) => HomePage()));
            //     },
            //     child: Text(
            //       'Register',
            //       style: TextStyle(color: Colors.white, fontSize: 25),
            //     ),
            //   ),
            // ),

            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
