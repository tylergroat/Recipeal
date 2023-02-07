import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authentification.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
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
    bool isHidden = true;

    void togglePasswordView() {
      setState(() {
        isHidden = !isHidden;
      });
    }

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
        backgroundColor: Colors.red,
        title: Text('Register'),
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
                  suffix: InkWell(
                      onTap: togglePasswordView, child: Icon(Icons.visibility)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 15, bottom: 0),
              child: TextField(
                controller: confirmPasswordController,
                //Text Field for password
                obscureText: isHidden, //to hide text (password field)
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText:
                      'Password must have at least 6 alphanumeric characters',
                  suffix: InkWell(
                      onTap: togglePasswordView, child: Icon(Icons.visibility)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 15, bottom: 0),
              child: Container(
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
                    } else if (confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(confirmPasswordMessage);
                      return;
                    } else if (passwordController.text.length <= 6) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(weakPasswordMessage);
                      return;
                    } else if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(passwordsDoNotMatchMessage);
                      return;
                    } else {
                      User? user = await registerWithEmailPassword(
                          emailController.text.toString(),
                          passwordController.text.toString());

                      if (user != null) {
                        print(user);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(creationSuccessful);
                        // ignore: use_build_context_synchronously
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginPage()));
                      } else if (!emailController.text.characters
                          .contains('@')) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(emailFormatMessage);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(accountExistsMessage);
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
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
