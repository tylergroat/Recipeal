import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/authentification.dart';
import 'package:food_for_thought/registration_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  @override
  Widget build(BuildContext context) {
    bool isHidden = true;

    void togglePasswordView() {
      setState(() {
        isHidden = !isHidden;
      });
      print(isHidden);
    }

    return Scaffold(
      backgroundColor: Colors.white, //main scaffold
      appBar: AppBar(
        leading: Icon(Icons.food_bank),
        backgroundColor: Colors.red,
        title: Text("Food for Thought"),
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
                  suffix: InkWell(
                      onTap: togglePasswordView,
                      child: Icon(
                        Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      )),
                ),
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
                    ScaffoldMessenger.of(context)
                        .showSnackBar(enterEmailMessage);
                    return;
                  } else if (passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(enterPasswordMessage);
                    return;
                  } else {
                    User? user = await signInWithEmailPassword(
                        emailController.text.toString(),
                        passwordController.text.toString());

                    if (user != null) {
                      print(user);
                      // ignore: use_build_context_synchronously
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomePage()));
                    } else {
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
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RegistrationPage()));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
